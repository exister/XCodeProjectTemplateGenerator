#import "UIScreen+__CLASS__PREFIX__Screen.h"


@implementation UIScreen (__CLASS__PREFIX__Screen)

+ (BOOL)isRetina4InchDisplay {
    static dispatch_once_t predicate;
    static BOOL answer;

    dispatch_once(&predicate, ^{
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        answer = ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f);
    });
    return answer;
}

@end