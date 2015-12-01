//
// Created by yizhuolin on 12-9-29.
// Add more methods by Chachi on Nov.01,15
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface UIImage (Edit)

- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

- (UIColor *)averageColor;

- (UIColor *)averageColorForRect:(CGRect)rect;

- (UIImage *)croppedImage:(CGRect)bounds;

- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)scaleToAspectFillSize:(CGSize)size;

- (UIImage *)scaleToFillWidth:(CGFloat)width;

- (UIImage *)scaleWithRatio:(CGFloat)ratio;
@end