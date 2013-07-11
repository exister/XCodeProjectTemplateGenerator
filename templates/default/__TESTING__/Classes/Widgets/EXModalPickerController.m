//
//  EXModalPickerControllerViewController.m
//  Spasibo
//
//  Created by strelok on 07.06.13.
//  Copyright (c) 2013 adwz. All rights reserved.
//

#import "EXModalPickerController.h"

@interface EXModalPickerController ()

@end

@implementation EXModalPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.coverView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	self.coverView.backgroundColor = UIColor.blackColor;
	self.coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.picker.delegate = [self.delegate pickerDelegate];
    self.picker.dataSource = [self.delegate pickerDataSource];

	for (UIView *subview in self.picker.subviews) {
		subview.frame = self.picker.bounds;
	}
}

- (void)viewDidUnload {
	self.coverView = nil;
    self.picker = nil;
	self.delegate = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (IBAction)onEditCancelClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(pickerCancel:)]) {
        [self.delegate pickerCancel:self];
    }
}

- (IBAction)onEditSaveClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(pickerSetValue:)]) {
        [self.delegate pickerSetValue:self];
    }
}

@end
