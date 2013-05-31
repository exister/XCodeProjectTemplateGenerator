//
// Created by strelok on 21.05.13.
// Copyright (c) 2013 adwz. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class __CLASS__PREFIX__TooltipImageView;

@interface __CLASS__PREFIX__FormHelper : NSObject

+ (void)handleFormErrors:(AFHTTPRequestOperation *)operation fields:(NSDictionary *)fields defaultMessage:(NSString *)message view:(UIView *)view;

+ (void)handleFailure:(AFHTTPRequestOperation *)operation message:(NSString *)message view:(UIView *)view;

+ (void)showNetworkError:(AFHTTPRequestOperation *)operation message:(NSString *)message view:(UIView *)view;
@end