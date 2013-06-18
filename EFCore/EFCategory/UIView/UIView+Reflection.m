//
// Created by yizhuolin on 12-11-15.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "UIView+Reflection.h"

CGContextRef MyCreateBmpContext(size_t pixelsWide, size_t pixelsHigh) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    // create the bitmap context
    CGContextRef bitmapContext = CGBitmapContextCreate(nil, pixelsWide, pixelsHigh, 8,
            0, colorSpace,
            // this will give us an optimal BGRA format for the device:
            (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    CGColorSpaceRelease(colorSpace);

    return bitmapContext;
}

@implementation UIView (Reflection)

- (void)addReflectionOfViewWithPercent:(CGFloat)percent andOffset:(CGFloat)offset
{
    self.clipsToBounds = NO;
    UIImage *image = [self reflectionOfViewWithPercent:percent];

    CALayer *layer = [[CALayer alloc] init];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * percent);
    layer.contents = (id)image.CGImage;
    CATransform3D stransform = CATransform3DMakeScale(1.0f,-1.0f,1.0f);
    CATransform3D transform = CATransform3DTranslate(stransform,0.0f,-(offset + self.frame.size.height - 1),0.0f);
    layer.transform = transform;
    layer.sublayerTransform = layer.transform;
    layer.opacity = .3;

    [self.layer addSublayer:layer];
}

//核心函数，cookbook版
- (UIImage *)reflectionOfViewWithPercent:(CGFloat)percent // percent这个参数用于设置阴影显示多少
{

    // Retain the width but shrink the height
    CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height * percent);

    // 制作镜像
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat height_left = self.bounds.size.height - size.height;
    CGContextTranslateCTM(context, 0, -height_left);
    [self.layer renderInContext:context];
    UIImage *partialimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // 添加灰蒙渐变效果
    CGImageRef mask = [self createGradientImage:size];
    CGImageRef ref = CGImageCreateWithMask(partialimg.CGImage, mask);
    UIImage *theImage = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    CGImageRelease(mask);

    return theImage;
}

- (CGImageRef)createGradientImage:(CGSize)size       //蒙化处理函数
{
    CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};

    // Create gradient in gray device color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    CGColorSpaceRelease(colorSpace);

    // Draw the linear gradient
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointMake(0, size.height);
    CGContextDrawLinearGradient(context, gradient, p2, p1, kCGGradientDrawsAfterEndLocation);

    // Return the CGImage
    CGImageRef theCGImage = CGBitmapContextCreateImage(context);
    CFRelease(gradient);
    CGContextRelease(context);
    return theCGImage;
}

@end