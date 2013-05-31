/** Collection of methods to work with registration related tasks
*/

#import "SSKeychain.h"
#import "NSString+SSToolkitAdditions.h"
#import "__CLASS__PREFIX__RegistrationHelper.h"

#define kAuthTokenAccount @"auth_token"

@implementation __CLASS__PREFIX__RegistrationHelper

static NSString *cachedDeviceId = nil;
static NSString *cachedAuthToken = nil;
static NSString *cachedPushToken = nil;
static NSNumber *cachedDeviceRegistered = nil;

+ (id)sharedInstance
{
    static __CLASS__PREFIX__RegistrationHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)startObserving {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle401:) name:k__CLASS__PREFIX__UnauthorizedNotification object:nil];
}

- (void)handle401:(NSNotification *)notification {
    [__CLASS__PREFIX__RegistrationHelper setAuthToken:nil];
}

+ (NSString *)authToken
{
    if (cachedAuthToken == nil) {
        cachedAuthToken = [SSKeychain passwordForService:k__CLASS__PREFIX__KeychainServiceName account:kAuthTokenAccount];
    }
    return cachedAuthToken;
}

+ (void)setAuthToken:(NSString *)token
{
    cachedAuthToken = token;
#warning Saving auth token disabled for debug configuration
#ifndef DEBUG
    [SSKeychain setPassword:token forService:k__CLASS__PREFIX__KeychainServiceName account:kAuthTokenAccount];
#endif
}

+ (NSString *)deviceId
{
    if (cachedDeviceId == nil) {
        cachedDeviceId = [SSKeychain passwordForService:k__CLASS__PREFIX__KeychainServiceName account:k__CLASS__PREFIX__UDDeviceId];
    }
    return cachedDeviceId;
}

+ (void)setDeviceId:(NSString *)deviceID
{
    cachedDeviceId = deviceID;
    [SSKeychain setPassword:deviceID forService:k__CLASS__PREFIX__KeychainServiceName account:k__CLASS__PREFIX__UDDeviceId];
}

+ (BOOL)isAuthenticated
{
    return cachedAuthToken != nil;
}

+ (NSString *)pushToken
{
    if (cachedPushToken == nil) {
        cachedPushToken = [[NSUserDefaults standardUserDefaults] stringForKey:k__CLASS__PREFIX__UDPushToken];
        if (cachedPushToken == nil) {
            cachedPushToken = @"";
        }
    }
    return cachedPushToken;
}

+ (void)setPushToken:(NSString *)pushToken {
    [[NSUserDefaults standardUserDefaults] setObject:pushToken forKey:k__CLASS__PREFIX__UDPushToken];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (pushToken == nil) {
        cachedPushToken = @"";
    }
    else {
        cachedPushToken = pushToken;
    }
}

+ (BOOL)deviceRegistered
{
    if (cachedDeviceRegistered == nil) {
        cachedDeviceRegistered = [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:k__CLASS__PREFIX__UDDeviceRegistered]];
    }
    return [cachedDeviceRegistered boolValue];
}

+ (void)setDeviceRegistered:(BOOL)registered
{
    cachedDeviceRegistered = [NSNumber numberWithBool:registered];
    [[NSUserDefaults standardUserDefaults] setBool:registered forKey:k__CLASS__PREFIX__UDDeviceRegistered];
}

@end
