//
// Created by strelok on 21.05.13.
// Copyright (c) 2013 adwz. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface __CLASS__PREFIX__ValidatableTextField : UITextField

@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, assign) id validationDelegate;

- (void)setError:(NSString *)error;
@end