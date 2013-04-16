//
// Created by strelok on 23.01.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "US2Validatable.h"


@interface __CLASS__PREFIX__ValidatableObject : NSObject <US2Validatable>

@property (nonatomic, strong) NSString *value;

- (id)initWithValue:(NSString *)value;

+ (id)objectWithValue:(NSString *)value;


@end