//
//  UIViewController+EXModalPickerExtension.m
//  Spasibo
//
//  Created by strelok on 07.06.13.
//  Copyright (c) 2013 adwz. All rights reserved.
//

#import "UIViewController+EXModalPickerExtension.h"
#import <objc/runtime.h>

static char kEXModalPickerControllerObjectKey;

@implementation UIViewController (EXModalPickerExtension)

- (void)setExPickerController:(EXModalPickerController *)controller
{
    objc_setAssociatedObject(self, &kEXModalPickerControllerObjectKey, controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (EXModalPickerController *)exPickerController
{
    return objc_getAssociatedObject(self, &kEXModalPickerControllerObjectKey);
}

- (void)showModalPicker {
    self.exPickerController = [[EXModalPickerController alloc] initWithNibName:@"EXModalPickerController" bundle:nil];
    self.exPickerController.delegate = (id <EXModalPickerControllerDelegate>) self;
    [self showModalPicker:self.exPickerController];
}

- (void)showModalPicker:(EXModalPickerController *)controller {
//    [self showModalPicker:controller inView:UIApplication.sharedApplication.delegate.window.rootViewController.view];
    [self showModalPicker:controller inView:self.view];
}

- (void)showModalPicker:(EXModalPickerController *)controller inView:(UIView *)rootView {
    
	UIView *modalView = controller.view;
	UIView *coverView = controller.coverView;
    
	coverView.frame = rootView.bounds;
    coverView.alpha = 0.0f;
    
    modalView.frame = rootView.bounds;
    //place view beyond screen to perform slide in animation
	modalView.center = self.offScreenCenter;
	
	[rootView addSubview:coverView];
	[rootView addSubview:modalView];
	
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	
    //slide in
	modalView.frame = CGRectMake(0, 0, modalView.frame.size.width, modalView.frame.size.height);
	coverView.alpha = 0.5;
    
	[UIView commitAnimations];
}

- (void)hideModalPicker {
    [self hideModalPicker:self.exPickerController];
}

- (void)hideModalPicker:(EXModalPickerController *)controller {
	double animationDelay = 0.7;
	
    UIView *modalView = controller.view;
	UIView *coverView = controller.coverView;
    
	[UIView beginAnimations:nil context:(__bridge void *)(modalView)];
	[UIView setAnimationDuration:animationDelay];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideModalPickerStopped:finished:context:)];
	
    //slide out
    modalView.center = self.offScreenCenter;
	coverView.alpha = 0.0f;
    
	[UIView commitAnimations];
    
	[coverView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:animationDelay];
    
}

- (void)hideModalPickerStopped:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	UIView *modalView = (__bridge UIView *)context;
	[modalView removeFromSuperview];
}

- (CGPoint)offScreenCenter {
    CGPoint offScreenCenter = CGPointZero;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    CGSize offSize = UIScreen.mainScreen.bounds.size;
    
	if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
		offScreenCenter = CGPointMake(offSize.height / 2.0, offSize.width * 1.5);
	}
    else {
		offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
	}
    
    return offScreenCenter;
}

@end
