//
// Created by strelok on 21.05.13.
// Copyright (c) 2013 adwz. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreGraphics/CoreGraphics.h>
#import "__CLASS__PREFIX__ValidatableTextField.h"
#import "NSString+__CLASS__PREFIX__Utils.h"
#import "__CLASS__PREFIX__InvalidTooltipImageView.h"


@interface __CLASS__PREFIX__ValidatableTextField ()
@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, strong) __CLASS__PREFIX__InvalidTooltipImageView *tooltip;
@property (nonatomic, strong) UITapGestureRecognizer *tooltipTap;
@end

@implementation __CLASS__PREFIX__ValidatableTextField {

}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }

    return self;
}


- (void)setup {
    _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _iconButton.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
    [_iconButton setImage:[UIImage imageNamed:@"image_icon_validation_invalid.png"] forState:UIControlStateNormal];
    [_iconButton setImage:[UIImage imageNamed:@"image_icon_validation_invalid.png"] forState:UIControlStateHighlighted];
    [_iconButton addTarget:self action:@selector(iconButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightViewMode:UITextFieldViewModeNever];
    self.rightView = _iconButton;

    _tooltipTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTooltip:)];
}

- (void) drawPlaceholderInRect:(CGRect)rect {
    [[UIColor colorWithRed:1/76.0 green:1/76.0 blue:1/76.0 alpha:1.0] setFill];
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:12]];
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 5);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 5);
}

- (void)iconButtonTouched:(id)sender {
    if (self.tooltip != nil) {
        [self.tooltip removeFromSuperview];
        self.tooltip = nil;
    }
    else {
        CGPoint point = [self.rightView convertPoint:CGPointMake(0.0, self.rightView.frame.size.height - 4.0) toView:self.superview];
        CGRect tooltipViewFrame = CGRectMake(self.frame.origin.x, point.y, self.frame.size.width, 0);
        self.tooltip = [[__CLASS__PREFIX__InvalidTooltipImageView alloc] init];
        [self.tooltip setUserInteractionEnabled:YES];
        
        [self.tooltip addGestureRecognizer:self.tooltipTap];
        self.tooltip.frame = tooltipViewFrame;
        self.tooltip.text = self.errorMessage;
        [self.superview addSubview:self.tooltip];
    }
}

- (void)hideTooltip:(UITapGestureRecognizer *)recognizer {
    if (self.tooltip != nil) {
        [self.tooltip removeFromSuperview];
        self.tooltip = nil;
    }
}

- (void)setError:(NSString *)error {
    self.errorMessage = error;

    if ([self.errorMessage stringIsEmpty] || self.errorMessage == nil) {
        [self setRightViewMode:UITextFieldViewModeNever];
    }
    else {
        [self setRightViewMode:UITextFieldViewModeAlways];
    }
}
@end