//
// Created by strelok on 14.06.13.
// Copyright (c) 2013 adwz. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIViewController+EXInfiniteLoading.h"
#import "NSString+EXUtils.h"
#import "NSURL+SSToolkitAdditions.h"
#import <objc/runtime.h>
#import <SVPullToRefresh/UIScrollView+SVInfiniteScrolling.h>

static char kSPNextUrlKey;

@implementation UIViewController (EXInfiniteLoading)

- (void)handleNextUrl:(id)responseObject table:(UITableView *)tableView {
    self.nextUrl = responseObject[@"next"];
    if ([self.nextUrl isKindOfClass:[NSNull class]] || [self.nextUrl stringIsEmpty]) {
        tableView.showsInfiniteScrolling = NO;
    }
    else {
        tableView.showsInfiniteScrolling = YES;
    }
}

- (void)setNextUrl:(NSString *)url
{
    objc_setAssociatedObject(self, &kSPNextUrlKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)nextUrl
{
    return objc_getAssociatedObject(self, &kSPNextUrlKey);
}

- (NSString *)nextPage {
    if (!([self.nextUrl isKindOfClass:[NSNull class]] || [self.nextUrl stringIsEmpty])) {
        NSString *page = [[NSURL URLWithString:self.nextUrl] queryDictionary][@"page"];
        return page;
    }
    return nil;
}

@end