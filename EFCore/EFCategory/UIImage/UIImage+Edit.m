//
// Created by yizhuolin on 12-9-29.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIImage+Edit.h"

@implementation UIImage (Edit)

- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height
{
    CGFloat destW = width;
    CGFloat destH = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;

    CGImageRef imageRef = self.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
            destW,
            destH,
            CGImageGetBitsPerComponent(imageRef),
            4 * ((int)destW),
            CGImageGetColorSpace(imageRef),
            (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));

    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);

    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);

    return result;
}
@end