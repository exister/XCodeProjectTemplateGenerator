#import "UIViewController+__CLASS__PREFIX__StoryBoard.h"


@implementation UIViewController (__CLASS__PREFIX__StoryBoard)

+ (UIViewController *)loadFromMainStoryBoard:(NSString *)identifier
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:identifier];
    return vc;
}

@end