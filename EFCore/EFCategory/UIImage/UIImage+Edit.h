//
// Created by yizhuolin on 12-9-29.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface UIImage (Edit)

- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

- (UIColor *)averageColor;

- (UIColor *)averageColorForRect:(CGRect)rect;
@end