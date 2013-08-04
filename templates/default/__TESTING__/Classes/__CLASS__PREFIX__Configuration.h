/** Collection of application-wide constants
*/

extern int const ddLogLevel;

/**
* TestFlight
*/
#define k__CLASS__PREFIX__TestFlightAppToken @""

/**
* JIRA
*/
#define k__CLASS__PREFIX__JIRAHost @""
#define k__CLASS__PREFIX__JIRAProject @"__TESTING__"
#define k__CLASS__PREFIX__JIRAApiKey @""

/**
* HockeyApp
*/
#define k__CLASS__PREFIX__HockeyAppApiKeyBeta @""
#define k__CLASS__PREFIX__HockeyAppApiKeyLive @""

/**
* Notifications
*/

#define k__CLASS__PREFIX__ReachabilityChanged @"k__CLASS__PREFIX__ReachabilityChanged"
#define k__CLASS__PREFIX__RegisteredForRemoteNotifications @"k__CLASS__PREFIX__RegisteredForRemoteNotifications"
#define k__CLASS__PREFIX__SplashScreenJobDoneNotification @"k__CLASS__PREFIX__SplashScreenJobDoneNotification"
#define k__CLASS__PREFIX__SplashScreenAllJobsDoneNotification @"k__CLASS__PREFIX__SplashScreenAllJobsDoneNotification"
#define k__CLASS__PREFIX__SplashScreenFinished @"k__CLASS__PREFIX__SplashScreenFinished"

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


/**
 * Messages
 */
#define k__CLASS__PREFIX__MessageServerError @"Проблемы с соединением"