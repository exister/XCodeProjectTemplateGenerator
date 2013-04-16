//
// Created by strelok on 23.01.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "__CLASS__PREFIX__ValidatableObject.h"


@implementation __CLASS__PREFIX__ValidatableObject {

}
@synthesize value = _value;

- (id)initWithValue:(NSString *)value {
    self = [super init];
    if (self) {
        _value = value;
    }

    return self;
}

+ (id)objectWithValue:(NSString *)value {
    return [[__CLASS__PREFIX__ValidatableObject alloc] initWithValue:value];
}


- (id <US2ValidatorProtocol>)validator {
    return nil;
}

- (NSString *)validatableText {
    return self.value;
}

@end