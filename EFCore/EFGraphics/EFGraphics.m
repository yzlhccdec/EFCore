//
// Created by yizhuolin on 12-11-8.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EFGraphics.h"

static BOOL needSaveContext = YES;

UIImage* radialGradientImage(CGSize size, CGFloat start, CGFloat end, CGPoint center, CGFloat radius)
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);

    size_t count = 2;
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {start, start, start, 1.0, end, end, end, 1.0};

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef grad = CGGradientCreateWithColorComponents (colorSpace, components, locations, count);
    CGColorSpaceRelease(colorSpace);

    CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(), grad, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    CGGradientRelease(grad);
    UIGraphicsEndImageContext();
    return image;
}


void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor,
        CGColorRef endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};

    NSArray *colors = [NSArray arrayWithObjects:(__bridge id) startColor, (__bridge id) endColor, nil];

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
            (__bridge CFArrayRef) colors, locations);

    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));

    if (needSaveContext) {
        CGContextSaveGState(context);
    }

    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);

    if (needSaveContext) {
        CGContextRestoreGState(context);
    }

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

void drawLine(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color, CGFloat width) {

    if (needSaveContext) {
        CGContextSaveGState(context);
    }

    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGColorRetain(color);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, width);
    CGContextStrokePath(context);

    if (needSaveContext) {
        CGContextRestoreGState(context);
    }

    CGColorRelease(color);
}

CGRect rectFor1PxStroke(CGRect rect) {
    return CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5,
            rect.size.width - 1, rect.size.height - 1);
}

void inDrawContext(CGContextRef context, DrawBlock block) {
    needSaveContext = NO;
    CGContextSaveGState(context);
    block();
    CGContextRestoreGState(context);
    needSaveContext = YES;
}

@implementation EFGraphics {

}

@end