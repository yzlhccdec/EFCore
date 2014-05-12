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

- (UIColor *)blackOrWhiteContrastingColor
{
    UIColor *black = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    UIColor *white = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];

    float blackDiff = [self luminosityDifference:black];
    float whiteDiff = [self luminosityDifference:white];

    return (blackDiff > whiteDiff) ? black : white;
}

- (CGFloat)luminosity
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;

    BOOL success = [self getRed:&red green:&green blue:&blue alpha:&alpha];

    if (success) {
        return 0.2126 * pow(red, 2.2f) + 0.7152 * pow(green, 2.2f) + 0.0722 * pow(blue, 2.2f);
    }

    CGFloat white;

    success = [self getWhite:&white alpha:&alpha];
    if (success) {
        return pow(white, 2.2f);
    }

    return -1;
}

- (CGFloat)luminosityDifference:(UIColor *)otherColor
{
    CGFloat l1 = [self luminosity];
    CGFloat l2 = [otherColor luminosity];

    if (l1 >= 0 && l2 >= 0) {
        if (l1 > l2) {
            return (l1 + 0.05f) / (l2 + 0.05f);
        } else {
            return (l2 + 0.05f) / (l1 + 0.05f);
        }
    }

    return 0.0f;
}
@end