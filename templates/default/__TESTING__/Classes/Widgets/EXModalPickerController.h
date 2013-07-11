//
//  EXModalPickerControllerViewController.h
//  Spasibo
//
//  Created by strelok on 07.06.13.
//  Copyright (c) 2013 adwz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EXModalPickerControllerDelegate;

@interface EXModalPickerController : UIViewController

@property (nonatomic, weak) IBOutlet id<EXModalPickerControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) UIView *coverView;

- (IBAction)onEditCancelClicked:(id)sender;
- (IBAction)onEditSaveClicked:(id)sender;

@end


@protocol EXModalPickerControllerDelegate <NSObject>
- (id<UIPickerViewDataSource>)pickerDataSource;
- (id<UIPickerViewDelegate>)pickerDelegate;
- (void)pickerSetValue:(EXModalPickerController *)viewController;
- (void)pickerCancel:(EXModalPickerController *)viewController;
@end
