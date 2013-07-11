#import "UIViewController+EXStoryBoard.h"


@implementation UIViewController (EXStoryBoard)

+ (UIViewController *)loadFromMainStoryBoard:(NSString *)identifier
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:identifier];
    return vc;
}

@end