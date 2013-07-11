//
// Created by strelok on 14.06.13.
// Copyright (c) 2013 adwz. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface UIViewController (EXInfiniteLoading)
- (void)handleNextUrl:(id)responseObject table:(UITableView *)tableView;

- (void)setNextUrl:(NSString *)url;

- (NSString *)nextUrl;

- (NSString *)nextPage;
@end