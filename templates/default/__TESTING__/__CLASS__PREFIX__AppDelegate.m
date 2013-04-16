#import "__CLASS__PREFIX__AppDelegate.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"
#import "VPPLocationController.h"
#import "__CLASS__PREFIX__RegistrationHelper.h"
#import "UIScreen+__CLASS__PREFIX__Screen.h"
#import "UIViewController+__CLASS__PREFIX__StoryBoard.h"
#import "NSDate+SSToolkitAdditions.h"
#import "DefaultSHKConfigurator.h"
#import "__CLASS__PREFIX__SHKConfigurator.h"
#import "SHKConfiguration.h"
#import "SHK.h"
#import "SHKFacebook.h"
#import "AJNotificationView.h"
#import "Appirater.h"
#import "NSString+SSToolkitAdditions.h"
#import "NSDate+__CLASS__PREFIX__TimeZone.h"
//include JIRA and HockeyApp only for Beta and AppStore releases
#ifndef LOCAL
    #import "BITHockeyManager.h"
    #import "JMC.h"
#endif
//include only for development builds
#ifdef LOCAL
    #import <OHHTTPStubs/OHHTTPStubs.h>
#endif
//include only for Beta releases
#ifdef BETA
    #import "TestFlight.h"
#endif
//include only for AppStore releases
#ifdef RELEASE
    #import "Flurry.h"
#endif

/**
* Global logging level
*/
#ifdef DEBUG
    int const ddLogLevel = LOG_LEVEL_VERBOSE;
#else
    int const ddLogLevel = LOG_LEVEL_WARN;
#endif

#ifdef RELEASE
    void flurryUncaughtExceptionHandler(NSException *exception) {
        [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
    }
#endif

#define k__CLASS__PREFIX__SplashScreenJobDoneNotification @"k__CLASS__PREFIX__SplashScreenJobDoneNotification"
#define k__CLASS__PREFIX__SplashScreenAllJobsDoneNotification @"k__CLASS__PREFIX__SplashScreenAllJobsDoneNotification"

@interface __CLASS__PREFIX__AppDelegate ()
- (void)initLoggers;

- (void)initPush;

- (void)initLocation;

- (void)initNetwork;

- (void)initDB;

- (void)initAuth;

- (void)initServices;

- (void)runSplashScreenJobs;

- (void)onSplashScreenJobDone:(NSNotification *)notification;

- (void)onSplashScreenAllJobsDone:(NSNotification *)notification;


@property (atomic, assign) NSInteger splashScreenJobsNumber;

@property(nonatomic, strong) UIImageView *splashScreenView;

@end

@implementation __CLASS__PREFIX__AppDelegate
@synthesize splashScreenView = _splashScreenView;
@synthesize splashScreenJobsNumber = _splashScreenJobsNumber;

/** Override point for customization after application launch.
*
* @return YES
*/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initLoggers];
    [self initPush];
    [self initLocation];
    [self initNetwork];
    [self initDB];
    [self initAuth];
    [self initServices];

    [self handleLaunchOptions:launchOptions];
    
    // Override point for customization after application launch.
    
    //manual loading of rootViewController used to load views before splash screen
    self.window.rootViewController = [UIViewController loadFromMainStoryBoard:@"__CLASS__PREFIX__ViewController"];
    [self.window makeKeyAndVisible];

    [self showSplashScreen];

    return YES;
}
                            
/**
* Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
*
* Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
*/
- (void)applicationWillResignActive:(UIApplication *)application
{
    DDLogInfo(@"applicationWillResignActive");
}

/**
* Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
*
* If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
*/
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DDLogInfo(@"applicationDidEnterBackground");
}

/**
* Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
*/
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DDLogInfo(@"applicationWillEnterForeground");
    [Appirater appEnteredForeground:YES];
}

/**
* Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
*/
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DDLogInfo(@"applicationDidBecomeActive");
    [SHKFacebook handleDidBecomeActive];
}

/**
* Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
*/
- (void)applicationWillTerminate:(UIApplication *)application
{
    DDLogInfo(@"applicationWillTerminate");
    [MagicalRecord cleanUp];
    [SHKFacebook handleWillTerminate];
}

#pragma mark - Urls
/** @name Urls */

/**
* Asks the delegate to open a resource identified by URL.
*
* @return YES if the delegate successfully handled the request; NO if the attempt to open the URL resource failed.
*/
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *scheme = [url scheme];
    NSString *prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
    if ([scheme hasPrefix:prefix])
        return [SHKFacebook handleOpenURL:url];
    return YES;
}


#pragma mark - Helpers
/** @name Helpers */

/** Looks for different launch options and forwards found options to appropriate handler
*
* Should be called from application:didFinishLaunchingWithOptions
*
* @param launchOptions Options dictionary from application:didFinishLaunchingWithOptions
*/
- (void)handleLaunchOptions:(NSDictionary *)launchOptions
{
    if (launchOptions != nil) {
        // Check for remote notification
        NSDictionary *remoteNotificationData = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotificationData != nil) {
            DDLogInfo(@"Launched from remote notification");
            [self handleRemoteNotification:remoteNotificationData];
        }
    }
}

#pragma mark - Initializers
/** @name Initializers */

/** Initializes CocoaLumberJack loggers, Flurry, Testflight, HockeyApp and JIRA
*
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initLoggers
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
#ifdef BETA
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
#error No TestFlight token
        [TestFlight takeOff:@""]; //TODO: add token
    });
#endif

#ifdef RELEASE
#error No Flurry token
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [Flurry setAppVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        [Flurry setShowErrorInLogEnabled:YES];
        [Flurry setDebugLogEnabled:YES];
        NSSetUncaughtExceptionHandler(&flurryUncaughtExceptionHandler);
        [Flurry startSession:@""]; //TODO: add token
    });
#endif

#ifndef LOCAL
    JMCOptions *options = [JMCOptions optionsWithUrl:k__CLASS__PREFIX__JIRAHost
                                          projectKey:k__CLASS__PREFIX__JIRAProject
                                              apiKey:k__CLASS__PREFIX__JIRAApiKey
                                              photos:YES
                                               voice:NO
                                            location:YES
                                      crashReporting:NO
                                       notifications:YES
                                        customFields:nil];

    [[JMC sharedInstance] configureWithOptions:options];

    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:k__CLASS__PREFIX__HockeyAppApiKey
                                                           delegate:self];
    [[BITHockeyManager sharedHockeyManager] startManager];
#endif
}

/** Registers to accept push notifications
*
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initPush
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
}

/**
* Initializes location manager
*
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initLocation
{
    [VPPLocationController sharedInstance].desiredLocationAccuracy = kCLLocationAccuracyBest;
    [VPPLocationController sharedInstance].distanceFilter = 5.0;
    [VPPLocationController sharedInstance].headingFilter = 30.0;
    [VPPLocationController sharedInstance].shouldRejectRepeatedLocations = YES;
}

/**
* Initializes HTTP Stubs
*
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initNetwork
{
#ifdef LOCAL
    NSArray* stubs = @[
           
    ];

    [OHHTTPStubs shouldStubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [stubs containsObject:request.URL.pathComponents.lastObject];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString* file = [request.URL.pathComponents.lastObject stringByAppendingPathExtension:@"json"];
        return [OHHTTPStubsResponse responseWithFile:file contentType:@"text/json"
                                        responseTime:OHHTTPStubsDownloadSpeedGPRS];
    }];
#endif
}

/**
* Initializes Core Data
*
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initDB
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"__TESTING__"];
}

/**
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initAuth
{
    //load auth token from keychain to cache
    [__CLASS__PREFIX__RegistrationHelper authToken];
}

/**
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initServices
{
    //setup ShareKit
    DefaultSHKConfigurator *configurator = [[__CLASS__PREFIX__SHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    [SHK flushOfflineQueue];

    //setup Appirater
    #warning Set real app id
    [Appirater setAppId:@""];
    [Appirater setDaysUntilPrompt:10.0f];
    [Appirater setTimeBeforeReminding:2.0f];
    [Appirater appLaunched:YES];
}

#pragma mark - Notifications
/** @name Notifications */

/** Called if app has successfully registered for remote notifications
*
* @param deviceToken Assigned token
*/
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DDLogInfo(@"Registered for remote notifications: %@", deviceToken);

    NSString *pushToken = [deviceToken description];
    pushToken = [pushToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    pushToken = [pushToken stringByReplacingOccurrencesOfString:@" " withString:@""];

    [[NSUserDefaults standardUserDefaults] setObject:pushToken forKey:k__CLASS__PREFIX__UDPushToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:k__CLASS__PREFIX__RegisteredForRemoteNotifications object:nil];
}

/** Called if app has failed to register for remote notifications
*/
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DDLogError(@"Failed to register for remote notifications: %@", error.localizedDescription);
#if TARGET_IPHONE_SIMULATOR
    if (![[NSUserDefaults standardUserDefaults] stringForKey:k__CLASS__PREFIX__UDPushToken]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithUUID] forKey:k__CLASS__PREFIX__UDPushToken];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:k__CLASS__PREFIX__RegisteredForRemoteNotifications object:nil];
#else
    [self hideSplashScreen];
#endif
}

/** Called if app is active when the notification comes in
*
* @param userInfo Remote notification
*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DDLogInfo(@"Recieved remote notification");
    [self handleRemoteNotification:userInfo];
}

/** Processes remote notification
*
* @param data Remote notification data
*/
- (void)handleRemoteNotification:(NSDictionary *)data
{
    DDLogInfo(@"Processing remote notification: %@", data);

    if (data[@"type"] && [(NSString *)data[@"type"] hasPrefix:@"show_"] && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [AJNotificationView showNoticeInView:self.window
                                        type:AJNotificationTypeBlue
                                       title:data[@"text"]
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:2.5f];
    }
}

#pragma mark - Splash screen
/** @name Splash screen */

//TODO: extract to stand-alone splash screen class

- (void)showSplashScreen
{
    DDLogInfo(@"showSplashScreen");
    if ([UIScreen isRetina4InchDisplay]) {
        self.splashScreenView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568h.png"]];
    }
    else {
        self.splashScreenView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    }
    self.splashScreenView.frame = [UIScreen mainScreen].bounds;
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.splashScreenView.frame];
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView startAnimating];
    [self.splashScreenView addSubview:activityIndicatorView];
    [self.window addSubview:self.splashScreenView];
    [self.window bringSubviewToFront:self.splashScreenView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runSplashScreenJobs) name:k__CLASS__PREFIX__RegisteredForRemoteNotifications object:nil];
}

- (void)hideSplashScreen
{
    DDLogInfo(@"hideSplashScreen");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k__CLASS__PREFIX__RegisteredForRemoteNotifications object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k__CLASS__PREFIX__SplashScreenJobDoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k__CLASS__PREFIX__SplashScreenAllJobsDoneNotification object:nil];

    __weak __CLASS__PREFIX__AppDelegate *weakSelf = self;
    [UIView animateWithDuration:1.0
                     animations:^{weakSelf.splashScreenView.alpha = 0.0;}
                     completion:^(BOOL finished){ [weakSelf.splashScreenView removeFromSuperview]; }];
}

/**
* Called from kCDRegisteredForRemoteNotifications after push token has been received
*/
- (void)runSplashScreenJobs
{
    DDLogInfo(@"runSplashScreenJobs");
    //TODO: maybe use operation queue?
    //set number of jobs after which splash screen will be dismissed
    self.splashScreenJobsNumber = 1;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSplashScreenJobDone:) name:k__CLASS__PREFIX__SplashScreenJobDoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSplashScreenAllJobsDone:) name:k__CLASS__PREFIX__SplashScreenAllJobsDoneNotification object:nil];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:k__CLASS__PREFIX__SplashScreenJobDoneNotification object:nil];
}

/**
* Called when one splash screen job has finished
*/
- (void)onSplashScreenJobDone:(NSNotification *)notification
{
    DDLogInfo(@"onSplashScreenJobDone");
    self.splashScreenJobsNumber--;
    if (self.splashScreenJobsNumber <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:k__CLASS__PREFIX__SplashScreenAllJobsDoneNotification object:nil];
    }
}

/**
* Called when all splash screen jobs have finished
*/
- (void)onSplashScreenAllJobsDone:(NSNotification *)notification
{
    DDLogInfo(@"onSplashScreenJobDone");
    [self hideSplashScreen];
}

@end
