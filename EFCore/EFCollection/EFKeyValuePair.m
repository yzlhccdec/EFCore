//
// Created by yizhuolin on 12-9-13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EFKeyValuePair.h"


@implementation EFKeyValuePair {

}
- (id)initWithKey:(id)key andValue:(id)value
{
    self = [super init];

    if (self) {
        _key = key;
        _value = value;
    }

    return self;
}

@end