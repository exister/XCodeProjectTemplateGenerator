//
//  KIFTestStep+__CLASS__PREFIX__Steps.m
//  Spasibo
//
//  Created by strelok on 28.06.13.
//  Copyright (c) 2013 adwz. All rights reserved.
//

#import "KIFTestStep+__CLASS__PREFIX__Steps.h"
#import "UIApplication-KIFAdditions.h"

@implementation KIFTestStep (__CLASS__PREFIX__Steps)

+ (id)stepToReturnBack
{
    return [KIFTestStep stepToTapViewWithAccessibilityLabel:@"Back"];
}

+ (id)stepsToReturnBack:(NSInteger)level
{
    NSMutableArray *steps = [NSMutableArray array];

    for (NSInteger i = 0; i < level; i++) {
        [steps addObject:[KIFTestStep stepToReturnBack]];
    }

    return steps;
}

@end
