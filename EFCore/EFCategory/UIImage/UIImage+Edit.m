//
// Created by yizhuolin on 12-9-29.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIImage+Edit.h"

@implementation UIImage (Edit)

- (UIImage *)scaleToSize:(CGSize)size scaleMode:(CCImageScaleMode)scaleMode
{
    CALayer *layer = [[CALayer alloc] init];
    layer.contentsScale = self.scale;
    layer.contents      = (id) self.CGImage;

    CGFloat width  = ceilf(size.width >= 1.f ? size.width : size.width == 0 ? size.height * self.size.width / self.size.height : self.size.width * size.width);
    CGFloat height = ceilf(size.height >= 1.f ? size.height : size.height == 0 ? size.width * self.size.height / self.size.width : self.size.height * size.height);
    layer.frame = CGRectMake(0, 0, width, height);

    switch (scaleMode) {
        case CCImageScaleModeSize: {
            layer.contentsGravity = kCAGravityResize;
            break;
        }
        case CCImageScaleModeAspectFill: {
            layer.contentsGravity = kCAGravityResizeAspectFill;
            break;
        }
        case CCImageScaleModeAspectFit: {
            layer.contentsGravity = kCAGravityResizeAspect;
            break;
        }
    }

    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return screenShot;
}

//截取部分图像
- (UIImage *)croppedImage:(CGRect)bounds
{
    CALayer *layer = [[CALayer alloc] init];
    layer.frame           = bounds;
    layer.contentsScale   = self.scale;
    layer.contents        = (id) self.CGImage;
    layer.contentsGravity = kCAGravityCenter;

    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-bounds.origin.x, -bounds.origin.y));
    [layer renderInContext:context];

    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return screenShot;
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);

    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

- (UIColor *)averageColor
{
    return [self averageColorForRect:(CGRect) {CGPointZero, self.size}];
}

- (UIColor *)averageColorForRect:(CGRect)rect
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char   rgba[4];
    CGContextRef    context    = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGImageRef image = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), image);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(image);

    if (rgba[3] > 0) {
        CGFloat alpha      = ((CGFloat) rgba[3]) / 255.0;
        CGFloat multiplier = alpha / 255.0;
        return [UIColor colorWithRed:((CGFloat) rgba[0]) * multiplier
                               green:((CGFloat) rgba[1]) * multiplier
                                blue:((CGFloat) rgba[2]) * multiplier
                               alpha:alpha];
    }
    else {
        return [UIColor colorWithRed:((CGFloat) rgba[0]) / 255.0
                               green:((CGFloat) rgba[1]) / 255.0
                                blue:((CGFloat) rgba[2]) / 255.0
                               alpha:((CGFloat) rgba[3]) / 255.0];
    }
}
@end