//
//  __CLASS__PREFIX__TooltipImageView.h
//
//  Created by strelok on 21.05.13.
//  Copyright (c) 2013 adwz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface __CLASS__PREFIX__TooltipImageView : UIImageView {
@protected
    UILabel  *_textLabel;
    NSString *_text;
}

@property (nonatomic, copy) NSString *text;

@end
