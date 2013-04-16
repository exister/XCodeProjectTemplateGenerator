#import "NSString+__CLASS__PREFIX__Utils.h"


@implementation NSString (__CLASS__PREFIX__Utils)

- (BOOL)stringIsEmpty
{
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (self == nil) {
        return YES;
    }
    else if ([self length] == 0) {
        return YES;
    }
    else {
        if ([[self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            return YES;
        }
    }
    return NO;
}

@end