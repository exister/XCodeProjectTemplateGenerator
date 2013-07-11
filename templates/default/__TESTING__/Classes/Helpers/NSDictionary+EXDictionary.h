//
// Created by strelok on 21.06.13.
// Copyright (c) 2013 adwz. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSDictionary (EXDictionary)
- (id)valueForKey:(NSString *)key ifKindOf:(Class)class defaultValue:(id)defaultValue;

- (NSDictionary *)dictionaryByReplacingNullsWithStrings;
@end