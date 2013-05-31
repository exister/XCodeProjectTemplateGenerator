//
// Created by strelok on 23.05.13.
// Copyright (c) 2013 adwz. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SBSegmentedViewControllerControlPosition) {
    SBSegmentedViewControllerControlPositionNavigationBar,
    SBSegmentedViewControllerControlPositionToolbar
};


@interface __CLASS__PREFIX__SegmentedViewController : UIViewController

@property (nonatomic, readonly, strong) UISegmentedControl *segmentedControl;
@property (nonatomic) SBSegmentedViewControllerControlPosition position;

// NSArray of UIViewController subclasses
- (id)initWithViewControllers:(NSArray *)viewControllers;

// Takes segmented control item titles separately from the view controllers
- (id)initWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;

- (void)setupWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;
@end