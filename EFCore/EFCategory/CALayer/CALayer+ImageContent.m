//
// Created by yizhuolin on 13-6-26.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import "CALayer+ImageContent.h"


@implementation CALayer (ImageContent)

+ (CALayer *)layerWithImage:(UIImage *)image scale:(CGFloat)scale {
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = (CGRect) {{0, 0}, image.size};
    layer.contents = (id)image.CGImage;
    layer.contentsScale = scale == 0 ? image.scale : scale;
    layer.contentsGravity = kCAGravityCenter;
    return layer;
}

- (void)setContentImage:(UIImage *)image scale:(CGFloat)scale {
    self.contents = (id)image.CGImage;
    self.contentsScale = scale == 0 ? image.scale : scale;
    self.contentsGravity = kCAGravityCenter;
}

@end