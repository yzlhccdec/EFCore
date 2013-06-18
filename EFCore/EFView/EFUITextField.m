//
// Created by yizhuolin on 12-11-5.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EFUITextField.h"


@implementation EFUITextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + _horizontalPadding,
            bounds.origin.y + _verticalPadding,
            bounds.size.width - _horizontalPadding*2 - CGRectGetWidth([self clearButtonRectForBounds:self.bounds]),
            bounds.size.height - _verticalPadding*2);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}


@end