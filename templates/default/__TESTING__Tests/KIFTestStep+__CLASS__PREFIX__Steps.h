//
//  KIFTestStep+__CLASS__PREFIX__Steps.h
//  Spasibo
//
//  Created by strelok on 28.06.13.
//  Copyright (c) 2013 adwz. All rights reserved.
//

#import "KIFTestStep.h"

@interface KIFTestStep (__CLASS__PREFIX__Steps)
+ (NSArray *)stepsToGoToPartnerDetailsPage;

+ (NSArray *)stepsToGoToSettingsPage;

+ (id)stepsToTapMenu;

+ (id)stepToReturnBack;

+ (id)stepsToReturnBack:(NSInteger)level;
@end
