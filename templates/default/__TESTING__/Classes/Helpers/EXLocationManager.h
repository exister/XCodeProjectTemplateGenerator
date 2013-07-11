//
// Created by strelok on 10.07.13.
// Copyright (c) 2013 adwz. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define EXLocationManagerDidUpdateToLocationNotification @"EXLocationManagerDidUpdateToLocationNotification"
#define EXLocationManagerDidFailWithErrorNotification @"EXLocationManagerDidFailWithErrorNotification"


@interface EXLocationManager : NSObject <CLLocationManagerDelegate>
+ (instancetype)sharedInstance;

- (BOOL)locationServicesEnabled;

- (void)startUpdatingLocation;

- (void)startMonitoringSignificantLocationChanges;

- (void)stopUpdatingLocation;

- (void)stopMonitoringSignificantLocationChanges;

@property (nonatomic, assign) CLLocationAccuracy desiredLocationAccuracy;
@property (nonatomic, assign) BOOL shouldRejectRepeatedLocations;
@property (nonatomic, assign) CLLocationDistance distanceFilter;
@property (nonatomic, assign) CLLocationDegrees headingFilter;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic) BOOL strictMode;
@end