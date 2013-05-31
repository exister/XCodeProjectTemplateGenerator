#import <Foundation/Foundation.h>

@interface __CLASS__PREFIX__RegistrationHelper : NSObject

+ (id)sharedInstance;

- (void)startObserving;

+ (NSString *)authToken;

+ (void)setAuthToken:(NSString *)token;

+ (NSString *)deviceId;

+ (void)setDeviceId:(NSString *)deviceID;

+ (BOOL)isAuthenticated;

+ (NSString *)pushToken;

+ (void)setPushToken:(NSString *)pushToken;

+ (BOOL)deviceRegistered;

+ (void)setDeviceRegistered:(BOOL)registered;
@end
