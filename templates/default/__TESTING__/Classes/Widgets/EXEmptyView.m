//
// Created by strelok on 08.07.13.
// Copyright (c) 2013 adwz. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EXEmptyView.h"


@implementation EXEmptyView {

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
        [self setBackgroundColor:[UIColor clearColor]];
    }

    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    //Shadows
    UIColor *shadow = [UIColor grayColor];
    CGSize shadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat shadowBlurRadius = 3;
    UIColor *shadowText = [UIColor blackColor];
    CGSize shadowTextOffset = CGSizeMake(0.1, -1.1);
    CGFloat shadowTextBlurRadius = 0.1;

    UIColor *bgColor = [UIColor lightGrayColor];
    UIColor *textColor = [UIColor whiteColor];
    UIFont *textFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    CGFloat topMargin = 20.0f;
    CGFloat sideMargin = 20.0f;

    CGSize textSize = [self.text sizeWithFont:textFont constrainedToSize:CGSizeMake(self.frame.size.width - sideMargin * 2, self.frame.size.height - topMargin * 2) lineBreakMode:NSLineBreakByTruncatingTail];
    if (textSize.width < 120) {
        textSize.width = 120;
    }
    if (textSize.height < 16) {
        textSize.height = 30;
    }

    CGContextSaveGState(context);
    [[UIColor clearColor] setFill];
    CGContextFillRect(context, self.frame);
    CGContextRestoreGState(context);

    //Bg
    CGRect bgRect = CGRectMake((self.frame.size.width - textSize.width - sideMargin * 2) * 0.5f, (self.frame.size.height - textSize.height - topMargin * 2) * 0.5f, textSize.width + sideMargin * 2, textSize.height + topMargin * 2);
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithRoundedRect:bgRect cornerRadius:4];
    CGContextSaveGState(context);
//    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [bgColor setFill];
    [bgPath fill];
    CGContextRestoreGState(context);

    //Text
    CGRect textRect = CGRectMake(bgRect.origin.x + sideMargin, bgRect.origin.y + topMargin, textSize.width, textSize.height);
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowTextOffset, shadowTextBlurRadius, shadowText.CGColor);
    [textColor setFill];
    [self.text drawInRect:textRect withFont:textFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    CGContextRestoreGState(context);
}
@end