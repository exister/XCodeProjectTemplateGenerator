//
// Created by strelok on 27.09.13.
// Copyright (c) 2013 __COMPANY__NAME__. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EXBaseAppDelegate.h"
#import "UIViewController+EXStoryBoard.h"
#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "EXLocationManager.h"
#import "EXAppDelegateLocationManager.h"
#import "EXRegistrationHelper.h"
#import "__CLASS__PREFIX__RegistrationHelper.h"
#import "NSString+EXUtils.h"
#import "UIScreen+EXScreen.h"
#import "AFHTTPRequestOperation.h"
#import "EXRestAPI.h"
#import "NSString+SSToolkitAdditions.h"


#ifdef LOCAL
    #warning include only for development builds
#else
    //include HockeyApp only for Beta and AppStore releases
    #import "BITHockeyManager.h"
#endif


#ifdef BETA
    #warning include only for Beta releases
    #import "TestFlight.h"
#endif

#ifdef RELEASE
    #warning include only for AppStore releases
    #import "Flurry.h"
#endif

#if RUN_KIF_TESTS
    #import__CLASS__PREFIX__TestControllerstController.h"
#endif

/**
* Global logging level
*/
#ifdef DEBUG
    int const ddLogLevel = LOG_LEVEL_VERBOSE;
#else
    int const ddLogLevel = LOG_LEVEL_WARN;
#endif


@implementation EXBaseAppDelegate

/** Override point for customization after application launch.
*
* @return YES
*/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initManagers];

    [self initPush];
    [self initLoggers];
    [self initLocation];
    [self initNetwork];
    [self initDB];
    [self initAuth];
    [self initServices];
    [self initAppearance];

    [self handleLaunchOptions:launchOptions];

    [self presentMainScreen];

    [self showSplashScreen];

    [self runTests];

    return YES;
}

- (void)initManagers {
    self.locationManager = [EXAppDelegateLocationManager sharedInstance];
}

/**
* Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
*
* Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
*/
- (void)applicationWillResignActive:(UIApplication *)application
{
    DDLogInfo(@"%@", THIS_METHOD);
}

/**
* Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
*
* If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
*/
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DDLogInfo(@"%@", THIS_METHOD);
}

/**
* Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
*/
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DDLogInfo(@"%@", THIS_METHOD);
}

/**
* Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
*/
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DDLogInfo(@"%@", THIS_METHOD);
}

/**
* Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
*/
- (void)applicationWillTerminate:(UIApplication *)application
{
    DDLogInfo(@"%@", THIS_METHOD);
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
    return NO;
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

        UILocalNotification *localNotificationData = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (localNotificationData != nil) {
            DDLogInfo(@"Launched from local notification");
            [self handleLocalNotification:localNotificationData];
        }
    }
}

- (void)runTests {
#if RUN_KIF_TESTS
    [[__CLASS__PREFIX__TestController sharedInstance] startTestingWithCompletionBlock:^{
        // Exit after the tests complete so that CI knows we're done
__CLASS__PREFIX__TestControllerfailureCount]);
    }];
#endif
}

- (void)presentMainScreen {
    //manual loading of rootViewController used to load views before splash screen
    self.window.rootViewController = [UIViewController loadFromMainStoryBoard:@"__CLASS__PREFIX__ViewController"];
    [self.window makeKeyAndVisible];
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
        [TestFlight takeOff:@""];//TODO
    });
#endif

#ifdef RELEASE
    #error No Flurry token
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [Flurry setAppVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        [Flurry setShowErrorInLogEnabled:YES];
        [Flurry setDebugLogEnabled:YES];
        [Flurry startSession:@""];//TODO
    });
#endif

#ifndef LOCAL
    [[BITHockeyManager sharedHockeyManager] configureWithBetaIdentifier:k__CLASS__PREFIX__HockeyAppApiKeyBeta liveIdentifier:k__CLASS__PREFIX__HockeyAppApiKeyLive delegate:self];
    [[BITHockeyManager sharedHockeyManager] startManager];
#endif
}

/** Registers to accept push notifications
*
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initPush
{
    DDLogInfo(@"%@", THIS_METHOD);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceRegistered:) name:k__CLASS__PREFIX__DeviceRegisteredNotification object:nil];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
}

/**
* Initializes location manager
*
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initLocation
{
    [self.locationManager initLocation];
}

/**
* Initializes HTTP Stubs
*
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initNetwork
{

}

/**
* Initializes Core Data
*
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initDB
{

}

/**
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initAuth
{
    [__CLASS__PREFIX__RegistrationHelper setDeviceRegistered:NO];

    //load auth token from keychain to cache
    [__CLASS__PREFIX__RegistrationHelper authToken];

    //generate device id
    NSString *deviceId = [__CLASS__PREFIX__RegistrationHelper deviceId];
    if (deviceId == nil) {
        [__CLASS__PREFIX__RegistrationHelper setDeviceId:[NSString stringWithUUID]];
    }
    DDLogInfo(@"deviceId: %@", deviceId);

    [[__CLASS__PREFIX__RegistrationHelper sharedInstance] startObserving];
}

/**
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initServices
{

}

- (void)initAppearance {

}

#pragma mark - Notifications
/** @name Notifications */

/** Called if app has successfully registered for remote notifications
*
* @param deviceToken Assigned token
*/
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DDLogInfo(@"%@: %@", THIS_METHOD, deviceToken);

    NSString *pushToken = [deviceToken description];
    pushToken = [pushToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    pushToken = [pushToken stringByReplacingOccurrencesOfString:@" " withString:@""];

    [__CLASS__PREFIX__RegistrationHelper setPushToken:pushToken];

    [[NSNotificationCenter defaultCenter] postNotificationName:k__CLASS__PREFIX__RegisteredForRemoteNotifications object:nil];

    [self registerPushId];
}

/** Called if app has failed to register for remote notifications
*/
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DDLogError(@"%@: %@", THIS_METHOD, error.localizedDescription);
#if TARGET_IPHONE_SIMULATOR
    if (![__CLASS__PREFIX__RegistrationHelper pushToken]) {
        [__CLASS__PREFIX__RegistrationHelper setPushToken:[NSString stringWithUUID]];
    }
#endif
}

/** Called if app is active when the notification comes in
*
* @param userInfo Remote notification
*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DDLogInfo(@"%@", THIS_METHOD);
    [self handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    DDLogInfo(@"%@", THIS_METHOD);
    [self handleLocalNotification:notification];
}

/** Processes remote notification
*
* @param data Remote notification data
*/
- (void)handleRemoteNotification:(NSDictionary *)data
{
    DDLogInfo(@"%@: %@", THIS_METHOD, data);

    if (data[@"t"] && [(NSString *)data[@"t"] isEqualToString:@"sh"] && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [self showNotification:data[@"aps"][@"alert"]];
    }
}

- (void)handleLocalNotification:(UILocalNotification *)notification
{
    DDLogInfo(@"%@: %@", THIS_METHOD, notification);

    NSDictionary *data = notification.userInfo;
}

- (void)showNotification:(NSString *)message {

}

- (void)onDeviceRegistered:(NSNotification *)notification {
    DDLogInfo(@"%@", THIS_METHOD);

    [self registerPushId];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:k__CLASS__PREFIX__DeviceRegisteredNotification object:nil];
}

- (void)registerPushId {
    if (![[__CLASS__PREFIX__RegistrationHelper pushToken] stringIsEmpty]) {
        [[__CLASS__PREFIX__RestAPI sharedInstance] registerPushToken:[__CLASS__PREFIX__RegistrationHelper pushToken] success:^(AFHTTPRequestOperation *operation, id o) {
            DDLogInfo(@"registerPushToken success");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DDLogError(@"registerPushToken failed");
        } owner:self];
    }
}

#pragma mark - Splash screen
/** @name Splash screen */

- (void)showSplashScreen
{
    DDLogInfo(@"%@", THIS_METHOD);
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

    [self runSplashScreenJobs];
}

- (void)hideSplashScreen
{
    DDLogInfo(@"%@", THIS_METHOD);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k__CLASS__PREFIX__SplashScreenJobDoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k__CLASS__PREFIX__SplashScreenAllJobsDoneNotification object:nil];

    __typeof (&*self) __weak weakSelf = self;
    [UIView animateWithDuration:1.0
                     animations:^{weakSelf.splashScreenView.alpha = 0.0;}
                     completion:^(BOOL finished){
                         [weakSelf.splashScreenView removeFromSuperview];
                         [[NSNotificationCenter defaultCenter] postNotificationName:k__CLASS__PREFIX__SplashScreenFinished object:nil];
                     }];
}

/**
* Called from kCDRegisteredForRemoteNotifications after push token has been received
*/
- (void)runSplashScreenJobs
{
    DDLogInfo(@"%@", THIS_METHOD);
    //set number of jobs after which splash screen will be dismissed
    self.splashScreenJobsNumber = 1;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSplashScreenJobDone:) name:k__CLASS__PREFIX__SplashScreenJobDoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSplashScreenAllJobsDone:) name:k__CLASS__PREFIX__SplashScreenAllJobsDoneNotification object:nil];

    //register device
    [[__CLASS__PREFIX__RestAPI sharedInstance] registerDeviceWithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DDLogInfo(@"Register device finished");
        [__CLASS__PREFIX__RegistrationHelper setDeviceRegistered:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:k__CLASS__PREFIX__DeviceRegisteredNotification object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:k__CLASS__PREFIX__SplashScreenJobDoneNotification object:nil];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DDLogError(@"Register device failed");
        [__CLASS__PREFIX__RegistrationHelper setDeviceRegistered:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:k__CLASS__PREFIX__SplashScreenJobDoneNotification object:nil];
    }
    owner:self];
}

/**
* Called when one splash screen job has finished
*/
- (void)onSplashScreenJobDone:(NSNotification *)notification
{
    DDLogInfo(@"%@", THIS_METHOD);
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
    DDLogInfo(@"%@", THIS_METHOD);
    [self hideSplashScreen];
}

@end