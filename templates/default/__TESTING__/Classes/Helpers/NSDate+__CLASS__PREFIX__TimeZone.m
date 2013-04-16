#import <xlocale/_time.h>
#import "NSDate+__CLASS__PREFIX__TimeZone.h"

#define ISO8601_MAX_LEN 25

@implementation NSDate (__CLASS__PREFIX__TimeZone)

- (NSDate *)toLocalTime
{
    NSTimeZone *systemTz = [NSTimeZone systemTimeZone];
    NSInteger systemOffset = [systemTz secondsFromGMTForDate:self];
    return [NSDate dateWithTimeInterval:systemOffset sinceDate:self];
}

+ (NSDate *)dateFromISO8601StringStrippingPrecision:(NSString *)iso8601 {
    if (!iso8601) {
        return nil;
    }
    
    //TODO: transform NSString here instead of memory manipulations

    char *str = (char *)[iso8601 cStringUsingEncoding:NSUTF8StringEncoding];
    char newStr[ISO8601_MAX_LEN];
    bzero(newStr, ISO8601_MAX_LEN);

    size_t len = strlen(str);
    if (len == 0) {
        return nil;
    }

    //2013-02-22T15:27:21.322035+00:00
    //2013-02-22T15:27:21.322035Z

    char point = '.';
    char *point_position = strchr(str, point);
    if (point_position) {
        char plus = '+';
        char z = 'Z';
        char *plus_position = strchr(str, plus);
        char *z_position = strchr(str, z);

        if (plus_position) {
            memcpy(newStr, str, (point_position - str));
            memcpy(newStr + (point_position - str), str + (plus_position - str), 6);
        }
        else if (z_position) {
            memcpy(newStr, str, (point_position - str));
            strncpy(newStr + (point_position - str), "Z\0", 2);
        }

        len = strlen(newStr);
        strncpy(str, newStr, sizeof(newStr));
        bzero(newStr, ISO8601_MAX_LEN);
    }

    // UTC dates ending with Z
    if (len == 20 && str[len - 1] == 'Z') {
        memcpy(newStr, str, len - 1);
        strncpy(newStr + len - 1, "+0000\0", 6);
    }

            // Timezone includes a semicolon (not supported by strptime)
    else if (len == 25 && str[22] == ':') {
        memcpy(newStr, str, 22);
        memcpy(newStr + 22, str + 23, 2);
    }

            // Fallback: date was already well-formatted OR any other case (bad-formatted)
    else {
        memcpy(newStr, str, len > ISO8601_MAX_LEN - 1 ? ISO8601_MAX_LEN - 1 : len);
    }

    // Add null terminator
    newStr[sizeof(newStr) - 1] = 0;

    struct tm tm = {
            .tm_sec = 0,
            .tm_min = 0,
            .tm_hour = 0,
            .tm_mday = 0,
            .tm_mon = 0,
            .tm_year = 0,
            .tm_wday = 0,
            .tm_yday = 0,
            .tm_isdst = -1,
    };

    if (strptime_l(newStr, "%FT%T%z", &tm, NULL) == NULL) {
        return nil;
    }

    return [NSDate dateWithTimeIntervalSince1970:mktime(&tm)];
}

@end