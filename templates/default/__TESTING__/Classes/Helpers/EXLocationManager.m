//
// Created by strelok on 10.07.13.
// Copyright (c) 2013 adwz. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EXLocationManager.h"


@interface EXLocationManager ()
@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic, strong) NSDate *startDate;

- (void)setup;

- (BOOL)isValidLocation:(CLLocation *)location;

- (void)start;

- (void)handleNewLocation:(CLLocation *)newLocation;
@end

@implementation EXLocationManager {

}

+ (instancetype)sharedInstance
{
    static EXLocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance setup];
    });
    return sharedInstance;
}

- (void)setup {
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    self.manager.distanceFilter = 1.0;
    self.manager.headingFilter = 1.0;
    self.strictMode = YES;
}

- (BOOL)isValidLocation:(CLLocation*)location {
    // Filter out nil locations
    if (location == nil) {
        return NO;
    }

    if (self.strictMode) {
        // Filter out points by invalid accuracy
        if (location.horizontalAccuracy < 0) {
            return NO;
        }

        // Filter out points that are out of order
        NSTimeInterval secondsSinceLastPoint = [location.timestamp timeIntervalSinceDate:self.currentLocation.timestamp];

        if (secondsSinceLastPoint < 0) {
            return NO;
        }

        // Filter out points created before the manager was initialized
        NSTimeInterval secondsSinceManagerStarted = [location.timestamp timeIntervalSinceDate:self.startDate];

        if (secondsSinceManagerStarted < 0) {
            return NO;
        }
    }

    // The newLocation is good to use
    return YES;
}

- (BOOL)locationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

- (void)start {
    self.startDate = [[NSDate alloc] init];
}

- (void)startUpdatingLocation {
    DDLogInfo(@"startUpdatingLocation");
    if ([self locationServicesEnabled]) {
        [self start];
        [self.manager startUpdatingLocation];
    }
}

- (void)startMonitoringSignificantLocationChanges {
    DDLogInfo(@"startMonitoringSignificantLocationChanges");
    if ([self locationServicesEnabled] && [CLLocationManager significantLocationChangeMonitoringAvailable]) {
        [self start];
        [self.manager startMonitoringSignificantLocationChanges];
    }
}

- (void)stopUpdatingLocation {
    DDLogInfo(@"stopUpdatingLocation");
    [self.manager stopUpdatingLocation];
}

- (void)stopMonitoringSignificantLocationChanges {
    DDLogInfo(@"stopMonitoringSignificantLocationChanges");
    [self.manager stopMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self handleNewLocation:[locations lastObject]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self handleNewLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DDLogInfo(@"didFailWithError: %@", error);

    if ([error.domain isEqualToString:kCLErrorDomain] && error.code == kCLErrorDenied) {
        DDLogInfo(@"Location services denied");
        //user denied location services so stop updating manager
        [manager stopUpdatingLocation];
        [manager stopMonitoringSignificantLocationChanges];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:EXLocationManagerDidFailWithErrorNotification object:nil userInfo:@{
            @"error": error
    }];
}

- (void)handleNewLocation:(CLLocation *)newLocation {
    DDLogInfo(@"handleNewLocation: %@", newLocation);
    if ([self isValidLocation:newLocation]) {
        /* if location hasn't change, lets omit it */
        if (self.shouldRejectRepeatedLocations && self.currentLocation != nil && [self.currentLocation distanceFromLocation:newLocation] == 0) {
            return;
        }

        self.currentLocation = newLocation;
        [[NSNotificationCenter defaultCenter] postNotificationName:EXLocationManagerDidUpdateToLocationNotification object:nil userInfo:@{
                @"location": newLocation
        }];
    }
}

@end