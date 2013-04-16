/** Collection of application-wide constants
*/

extern int const ddLogLevel;

#define k__CLASS__PREFIX__UDPushToken @"__CLASS__PREFIX__PushToken"
#define k__CLASS__PREFIX__KeychainServiceName @"com.adwz.codriver"

/**
* JIRA
*/
#define k__CLASS__PREFIX__JIRAHost @""
#define k__CLASS__PREFIX__JIRAProject @"__TESTING__"
#define k__CLASS__PREFIX__JIRAApiKey @""

/**
* HockeyApp
*/
#define k__CLASS__PREFIX__HockeyAppApiKey @""

/**
* ShareKit
*/
#define k__CLASS__PREFIX__SHKAppName NSLocalizedString(@"__TESTING__", @"")
#warning Set real url
#define k__CLASS__PREFIX__SHKAppUrl @""
#warning Set real FB id here, in FacebookAppID key in .plist file and in URL Schemes
#define k__CLASS__PREFIX__SHKFacebookAppId @""
#define k__CLASS__PREFIX__SHKVkontakteAppId @""

/**
* Notifications
*/

#define k__CLASS__PREFIX__ReachabilityChanged @"k__CLASS__PREFIX__ReachabilityChanged"
#define k__CLASS__PREFIX__RegisteredForRemoteNotifications @"k__CLASS__PREFIX__RegisteredForRemoteNotifications"

/**
* Rest API Configuration
*/
#ifndef k__CLASS__PREFIX__RestApiBaseUrl
    #define k__CLASS__PREFIX__RestApiBaseUrl @"http://127.0.0.1:8000/api"
#endif

#define k__CLASS__PREFIX__NetworkUnreachableStatus @"k__CLASS__PREFIX__NetworkUnreachableStatus"
#define k__CLASS__PREFIX__NetworkReachableViaWWANStatus @"k__CLASS__PREFIX__NetworkReachableViaWWANStatus"
#define k__CLASS__PREFIX__NetworkReachableViaWiFiStatus @"k__CLASS__PREFIX__NetworkReachableViaWiFiStatus"

typedef enum {
    __CLASS__PREFIX__NetworkUnknownStatus = -1,
    __CLASS__PREFIX__NetworkUnreachableStatus = 0,
    __CLASS__PREFIX__NetworkReachableViaWWANStatus = 1,
    __CLASS__PREFIX__NetworkReachableViaWiFiStatus = 2,
} __CLASS__PREFIX__NetworkReachabilityStatus;