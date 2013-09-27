//
// Created by strelok on 27.09.13.
// Copyright (c) 2013 __COMPANY__NAME__. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class EXAppDelegateLocationManager;


@interface EXBaseAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) EXAppDelegateLocationManager *locationManager;

@property (nonatomic, strong) UIView *splashScreenView;

@property (nonatomic) int splashScreenJobsNumber;

- (void)initManagers;

- (void)initLoggers;

- (void)initPush;

- (void)initLocation;

- (void)initNetwork;

- (void)initDB;

- (void)initAuth;

- (void)initServices;

- (void)initAppearance;

- (void)handleLaunchOptions:(NSDictionary *)launchOptions;

- (void)runTests;

- (void)presentMainScreen;

- (void)handleRemoteNotification:(NSDictionary *)data;

- (void)handleLocalNotification:(UILocalNotification *)notification;

- (void)showNotification:(NSString *)message;

- (void)onDeviceRegistered:(NSNotification *)notification;

- (void)registerPushId;

- (void)showSplashScreen;

- (void)hideSplashScreen;

- (void)runSplashScreenJobs;

- (void)onSplashScreenJobDone:(NSNotification *)notification;

- (void)onSplashScreenAllJobsDone:(NSNotification *)notification;
@end