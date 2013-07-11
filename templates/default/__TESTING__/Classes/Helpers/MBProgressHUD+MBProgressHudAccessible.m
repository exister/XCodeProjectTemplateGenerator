//
//  MBProgressHUD+MBProgressHudAccessible.m
//  Spasibo
//
//  Created by strelok on 28.06.13.
//  Copyright (c) 2013 adwz. All rights reserved.
//

#import "MBProgressHUD+MBProgressHudAccessible.h"

@implementation MBProgressHUD (MBProgressHudAccessible)

- (NSString *)accessibilityValue {
    if(self.mode == MBProgressHUDModeAnnularDeterminate || self.mode == MBProgressHUDModeDeterminate) {
        return [NSString stringWithFormat:@"%.0f%%", self.progress * 100];
    }
    return nil;
}

- (NSString *)accessibilityLabel {
//    NSMutableString *buffer = [[NSMutableString alloc] init];
//    if(self.labelText) {
//        [buffer appendString:self.labelText];
//    }
//    if(self.detailsLabelText) {
//        [buffer appendFormat:@",%@", self.detailsLabelText, nil];
//    }
//
//    return [NSString stringWithString:buffer];
    return @"Загрузка...";
}

- (BOOL) isAccessibilityElement {
    return YES;
}

- (UIAccessibilityTraits) accessibilityTraits {
    return UIAccessibilityTraitUpdatesFrequently;
}

- (CGRect) accessibilityFrame {
    return self.frame;
}

@end
