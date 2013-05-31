//
//  __CLASS__PREFIX__InvalidTooltipImageView.m
//
//  Created by strelok on 21.05.13.
//  Copyright (c) 2013 adwz. All rights reserved.
//

#import "__CLASS__PREFIX__InvalidTooltipImageView.h"
#import "__CLASS__PREFIX__TooltipImageViewProtectedMethods.h"

@implementation __CLASS__PREFIX__InvalidTooltipImageView

- (void)buildUI
{
    [super buildUI];

    self.image = [[UIImage imageNamed:@"image_tooltip_invalid.png"] stretchableImageWithLeftCapWidth:48 topCapHeight:18];
}
@end
