//
// Created by yizhuolin on 12-11-5.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EFTextField.h"


@implementation EFTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + _horizontalPadding,
            bounds.origin.y + _verticalPadding,
            bounds.size.width - _horizontalPadding*2,
            bounds.size.height - _verticalPadding*2);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    return _showsCursor ? [super caretRectForPosition:position] : CGRectZero;
}
@end