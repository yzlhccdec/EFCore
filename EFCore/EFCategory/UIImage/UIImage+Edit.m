//
// Created by yizhuolin on 12-9-29.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIImage+Edit.h"

@implementation UIImage (Edit)

//截取部分图像
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, bounds);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));

    UIGraphicsBeginImageContextWithOptions(smallBounds.size,NO,0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();

    CGImageRelease(subImageRef);
    return smallImage;
}

//等比例缩放(长宽按最小比例缩放)
- (UIImage *)scaleToSize:(CGSize)size {
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);

    float verticalRadio = size.height * 1.0 / height;
    float horizontalRadio = size.width * 1.0 / width;

    float radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;

    width = width * radio;
    height = height * radio;

    int xPos = (size.width - width) / 2;
    int yPos = (size.height - height) / 2;

    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size,NO,0);

    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];

    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    // 使当前的context出堆栈
    UIGraphicsEndImageContext();

    // 返回新的改变大小后的图片
    return scaledImage;
}

//裁剪成矩形后缩放
- (UIImage *)scaleToAspectFillSize:(CGSize)size {
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);

    float verticalRadio = size.height * 1.0 / height;
    float horizontalRadio = size.width * 1.0 / width;

    float radio = verticalRadio < horizontalRadio ? horizontalRadio : verticalRadio;

    float subWidth = width * radio;
    float subHeight = height * radio;

    int xPos = (subWidth - size.width) / radio / 2;
    int yPos = (subHeight - size.height) / radio / 2;
    //先裁剪
    UIImage *img = [self croppedImage:CGRectMake(xPos, yPos, width, height)];

    UIGraphicsBeginImageContextWithOptions(size,NO,0);
    //再scale
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *targetImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return targetImage;

}

//按宽度等比例缩放
- (UIImage *)scaleToFillWidth:(CGFloat)width {
    float imageWidth = self.size.width;
    float imageHeight = self.size.height;

    float widthScale = imageWidth / width;

    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, imageHeight / widthScale),NO,0);

    [self drawInRect:CGRectMake(0, 0, width, imageHeight / widthScale)];

    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();

    return newImage;
}

//等比例缩放
- (UIImage *)scaleWithRatio:(CGFloat)ratio {
    float imageWidth = self.size.width * ratio;
    float imageHeight = self.size.height * ratio;

    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHeight),NO,0);

    [self drawInRect:CGRectMake(0, 0, imageWidth, imageHeight)];

    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();

    return newImage;
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
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

- (UIColor *)averageColor {
    return [self averageColorForRect:(CGRect) {CGPointZero, self.size}];
}

- (UIColor *)averageColorForRect:(CGRect)rect {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGImageRef image = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), image);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(image);

    if (rgba[3] > 0) {
        CGFloat alpha = ((CGFloat) rgba[3]) / 255.0;
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