//
// Created by yizhuolin on 12-9-19.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIColor+Hex.h"


@implementation UIColor (Hex)

+ (UIColor *)colorWithARGBHex:(NSInteger)hexValue
{
    return [self colorWithRGBHex:hexValue alpha:((CGFloat) ((hexValue & 0xFF000000) >> 24)) / 255.0];
}

+ (UIColor *)colorWithRGBHex:(NSInteger)hexValue
{
    return [self colorWithRGBHex:hexValue alpha:1.0];
}

+ (UIColor *)whiteColorWithAlpha:(CGFloat)alphaValue
{
    return [self colorWithRGBHex:0xFFFFFF alpha:alphaValue];
}

+ (UIColor *)blackColorWithAlpha:(CGFloat)alphaValue
{
    return [self colorWithRGBHex:0x000000 alpha:alphaValue];
}

+ (UIColor *)colorWithRGBHex:(NSInteger)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((CGFloat) ((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((CGFloat) ((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((CGFloat) (hexValue & 0xFF)) / 255.0 alpha:alpha];
}


@end