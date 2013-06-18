//
// Created by yizhuolin on 12-9-19.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define UIColorFromRGBHex(hexValue) [UIColor \
    colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

@interface UIColor (Hex)

+ (UIColor *)colorWithARGBHex:(NSInteger)hexValue;

+ (UIColor *)colorWithRGBHex:(NSInteger)hexValue;

+ (UIColor *)whiteColorWithAlpha:(CGFloat)alphaValue;

+ (UIColor *)blackColorWithAlpha:(CGFloat)alphaValue;

+ (UIColor *)colorWithRGBHex:(NSInteger)hexValue alpha:(CGFloat)alpha;

@end