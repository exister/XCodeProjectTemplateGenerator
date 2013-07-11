//
//  __CLASS__PREFIX__TestController.m
//  Spasibo
//
//  Created by strelok on 28.06.13.
//  Copyright (c) 2013 adwz. All rights reserved.
//

#import "__CLASS__PREFIX__TestController.h"
#import "KIFTestScenario+SPPartners.h"
#import "KIFTestScenario+SPSettings.h"

@implementation __CLASS__PREFIX__TestController

- (void)initializeScenarios;
{
    [self addScenario:[KIFTestScenario scenarioToOpenDetails]];
    [self addScenario:[KIFTestScenario scenarioToChangeCity]];
}

@end
