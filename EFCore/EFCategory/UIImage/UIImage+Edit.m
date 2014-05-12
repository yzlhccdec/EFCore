//
// Created by yizhuolin on 12-9-29.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIImage+Edit.h"

@implementation UIImage (Edit)

- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height
{
    CGFloat destW   = width;
    CGFloat destH   = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;

    CGImageRef   imageRef = self.CGImage;
    CGContextRef bitmap   = CGBitmapContextCreate(NULL,
            destW,
            destH,
            CGImageGetBitsPerComponent(imageRef),
            4 * ((int) destW),
            CGImageGetColorSpace(imageRef),
            (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));

    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);

    CGImageRef ref     = CGBitmapContextCreateImage(bitmap);
    UIImage    *result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);

    return result;
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