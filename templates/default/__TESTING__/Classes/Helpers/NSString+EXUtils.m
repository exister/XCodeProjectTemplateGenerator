#import "NSString+EXUtils.h"


@implementation NSString (EXUtils)

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