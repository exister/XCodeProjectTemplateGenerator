//
// Created by strelok on 21.05.13.
// Copyright (c) 2013 adwz. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "__CLASS__PREFIX__FormHelper.h"
#import "__CLASS__PREFIX__TooltipImageView.h"
#import "__CLASS__PREFIX__ValidatableTextField.h"
#import "AFJSONRequestOperation.h"
#import <QuartzCore/QuartzCore.h>
#import <AJNotificationView/AJNotificationView.h>


@implementation __CLASS__PREFIX__FormHelper {

}

+ (void)handleFormErrors:(AFHTTPRequestOperation *)operation fields:(NSDictionary *)fields defaultMessage:(NSString *)message view:(UIView *)view {
    if (operation.response.statusCode == 400) {
        id JSON = ((AFJSONRequestOperation *)operation).responseJSON;
        NSArray *nonFieldErrors = JSON[@"non_field_errors"];
        if (nonFieldErrors != nil) {
            [AJNotificationView showNoticeInView:view.window
                                            type:AJNotificationTypeRed
                                           title:[__CLASS__PREFIX__RestAPI convertNonFieldErrorsToString:nonFieldErrors]
                                 linedBackground:AJLinedBackgroundTypeDisabled
                                       hideAfter:2.5f];
            return;
        }
        else {
            [JSON enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if (fields[key] != nil) {
                    __CLASS__PREFIX__ValidatableTextField *editView = fields[key][@"field"];
                    [editView setError:[__CLASS__PREFIX__RestAPI convertNonFieldErrorsToString:obj]];
                }
            }];
            return;
        }
    }
    [__CLASS__PREFIX__FormHelper handleFailure:operation message:message view:view];
}

+ (void)handleFailure:(AFHTTPRequestOperation *)operation message:(NSString *)message view:(UIView *)view {
    if (operation.response.statusCode == 401) {
        [[NSNotificationCenter defaultCenter] postNotificationName:k__CLASS__PREFIX__UnauthorizedNotification object:nil];
    }
    else {
        [__CLASS__PREFIX__FormHelper showNetworkError:operation message:message view:view];
    }
}

+ (void)showNetworkError:(AFHTTPRequestOperation *)operation message:(NSString *)message view:(UIView *)view {
    if (operation != nil) {
        if (operation.response.statusCode >= 500) {
            message = k__CLASS__PREFIX__MessageServerError;
        }
    }

    [AJNotificationView showNoticeInView:view.window
                                    type:AJNotificationTypeRed
                                   title:message
                         linedBackground:AJLinedBackgroundTypeDisabled
                               hideAfter:2.5f];
}

@end