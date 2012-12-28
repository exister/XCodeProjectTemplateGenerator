#import "__CLASS__PREFIX__AppDelegate.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

/**
* Global logging level
*/
#ifdef DEBUG
    int const ddLogLevel = LOG_LEVEL_VERBOSE;
#else
    int const ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation __CLASS__PREFIX__AppDelegate

/** Override point for customization after application launch.
*
* @return YES
*/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initLoggers];
    [self initPush];

    [self handleLaunchOptions:launchOptions];

    return YES;
}
                            
/**
* Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
*
* Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
*/
- (void)applicationWillResignActive:(UIApplication *)application
{

}

/**
* Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
*
* If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
*/
- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

/**
* Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
*/
- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

/**
* Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
*/
- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

/**
* Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
*/
- (void)applicationWillTerminate:(UIApplication *)application
{

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

/** Initializes CocoaLumberJack loggers
*
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initLoggers
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

/** Registers to accept push notifications
*
* Should be called from application:didFinishLaunchingWithOptions
*/
- (void)initPush
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
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
}

/** Called if app has failed to register for remote notifications
*/
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DDLogError(@"Failed to register for remote notifications: %@", error.localizedDescription);
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
}

@end
