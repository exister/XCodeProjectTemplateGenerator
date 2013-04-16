#import <Foundation/Foundation.h>

@interface NSDate (__CLASS__PREFIX__TimeZone)
+ (NSDate *)dateFromISO8601StringStrippingPrecision:(NSString *)iso8601;
- (NSDate *)toLocalTime;


@end