//
// Created by strelok on 21.06.13.
// Copyright (c) 2013 adwz. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSDictionary+EXDictionary.h"


@implementation NSDictionary (EXDictionary)

- (id)valueForKey:(NSString *)key ifKindOf:(Class)class defaultValue:(id)defaultValue
{
    id obj = [self objectForKey:key];
    return [obj isKindOfClass:class] ? obj : defaultValue;
}

- (NSDictionary *)dictionaryByReplacingNullsWithStrings {
    const NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
    const id nul = [NSNull null];
    const NSString *blank = @"";

    for (NSString *key in self) {
        const id object = [self objectForKey: key];
        if (object == nul) {
            [replaced setObject: blank forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [(NSDictionary *)object dictionaryByReplacingNullsWithStrings] forKey: key];
        }
    }
    return [NSDictionary dictionaryWithDictionary: replaced];
}

@end