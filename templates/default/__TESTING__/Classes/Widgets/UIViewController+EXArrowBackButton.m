//
//  UIViewController+EXArrowBackButton.m
//  Spasibo
//
//  Created by strelok on 04.07.13.
//  Copyright (c) 2013 adwz. All rights reserved.
//

#import "UIViewController+EXArrowBackButton.h"

@implementation UIViewController (EXArrowBackButton)

- (void)arrowBackButton {
    UIImage *buttonImage = [UIImage imageNamed:@"bar_icon_back.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 39, 30);
    button.contentMode = UIViewContentModeCenter;
    [button addTarget:self action:@selector(onBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:customBarItem];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)onBackButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
