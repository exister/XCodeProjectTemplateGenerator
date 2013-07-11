//
//  UIViewController+EXModalPickerExtension.h
//  Spasibo
//
//  Created by strelok on 07.06.13.
//  Copyright (c) 2013 adwz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXModalPickerController.h"

@interface UIViewController (EXModalPickerExtension)

@property (nonatomic, strong) EXModalPickerController *exPickerController;

- (void)showModalPicker;
- (void)hideModalPicker;

@end
