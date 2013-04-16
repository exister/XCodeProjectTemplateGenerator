/** Collection of methods to work with registration related tasks
*/

#import "SSKeychain.h"
#import "NSString+SSToolkitAdditions.h"
#import "__CLASS__PREFIX__RegistrationHelper.h"

#define kAuthTokenAccount @"auth_token"

@implementation __CLASS__PREFIX__RegistrationHelper

static NSString *cachedAuthToken = nil;
static NSString *cachedPushToken = nil;

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
    [SSKeychain setPassword:token forService:kCDKeychainServiceName account:kAuthTokenAccount];
#endif
}

+ (BOOL)isAuthenticated
{
    return cachedAuthToken != nil;
}

+ (NSString *)pushToken
{
    if (cachedPushToken == nil) {
        cachedPushToken = [[NSUserDefaults standardUserDefaults] stringForKey:k__CLASS__PREFIX__UDPushToken];
    }
    return cachedPushToken;
}

@end
