#import <Foundation/Foundation.h>

@interface __CLASS__PREFIX__RegistrationHelper : NSObject

+ (NSString *)authToken;

+ (void)setAuthToken:(NSString *)token;

+ (BOOL)isAuthenticated;

+ (NSString *)pushToken;

@end
