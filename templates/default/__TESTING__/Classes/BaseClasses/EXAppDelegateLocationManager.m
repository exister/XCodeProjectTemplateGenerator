//
// Created by strelok on 27.09.13.
// Copyright (c) 2013 __COMPANY__NAME__. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreLocation/CoreLocation.h>
#import "EXAppDelegateLocationManager.h"
#import "EXLocationManager.h"


@implementation EXAppDelegateLocationManager {

}

+ (id)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)initLocation {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdate:) name:EXLocationManagerDidUpdateToLocationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationError:) name:EXLocationManagerDidFailWithErrorNotification object:nil];

    [EXLocationManager sharedInstance].desiredLocationAccuracy = kCLLocationAccuracyThreeKilometers;
    [EXLocationManager sharedInstance].distanceFilter = 100.0;
    [EXLocationManager sharedInstance].headingFilter = 50.0;
    [EXLocationManager sharedInstance].shouldRejectRepeatedLocations = YES;

    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        [[EXLocationManager sharedInstance] stopMonitoringSignificantLocationChanges];
    }
}
@end