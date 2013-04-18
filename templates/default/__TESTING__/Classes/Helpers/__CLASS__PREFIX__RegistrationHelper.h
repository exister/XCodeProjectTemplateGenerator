#import <Foundation/Foundation.h>

@interface __CLASS__PREFIX__RegistrationHelper : NSObject

+ (NSString *)authToken;

+ (void)setAuthToken:(NSString *)token;

+ (NSString *)deviceId;

+ (void)setDeviceId:(NSString *)deviceID;

+ (BOOL)isAuthenticated;

+ (NSString *)pushToken;

+ (BOOL)deviceRegistered;

+ (void)setDeviceRegistered:(BOOL)registered;
@end
