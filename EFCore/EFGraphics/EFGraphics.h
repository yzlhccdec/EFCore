//
// Created by yizhuolin on 12-11-8.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

typedef void (^DrawBlock)();

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor,
        CGColorRef endColor);

void inDrawContext(CGContextRef context, DrawBlock block);

CGRect rectFor1PxStroke(CGRect rect);

void drawLine(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color, CGFloat width);

UIImage* radialGradientImage(CGSize size, CGFloat start, CGFloat end, CGPoint center, CGFloat radius);

@interface EFGraphics : NSObject
@end