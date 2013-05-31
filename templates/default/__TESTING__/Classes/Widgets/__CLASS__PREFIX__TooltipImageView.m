//
//  __CLASS__PREFIX__TooltipImageView.m
//
//  Created by strelok on 21.05.13.
//  Copyright (c) 2013 adwz. All rights reserved.
//

#import "__CLASS__PREFIX__TooltipImageView.h"
#import "__CLASS__PREFIX__TooltipImageViewProtectedMethods.h"

static const CGFloat kMargin = 10.0;

@implementation __CLASS__PREFIX__TooltipImageView

#pragma mark - Initialization

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    CGRect textLabelFrame = CGRectMake(kMargin, 10.0, self.frame.size.width - kMargin - kMargin, 50.0);
    _textLabel = [[UILabel alloc] initWithFrame:textLabelFrame];
    _textLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    _textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    _textLabel.numberOfLines = 2;
    _textLabel.minimumFontSize = 11.0;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.adjustsFontSizeToFitWidth = YES;
    _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _textLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    _textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    [self addSubview:_textLabel];
}

- (void)updateUI
{
    _textLabel.text = _text;
    [self resizeForText];
}

- (void)resizeForText
{
    CGSize size = [_textLabel.text sizeWithFont:_textLabel.font
                              constrainedToSize:CGSizeMake(self.frame.size.width - kMargin - kMargin, 9999)
                                  lineBreakMode:_textLabel.lineBreakMode];
    
    _textLabel.frame = CGRectMake(kMargin, 10.0, self.frame.size.width - kMargin - kMargin, size.height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height + 14.0);
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    [self updateUI];
}

@end
