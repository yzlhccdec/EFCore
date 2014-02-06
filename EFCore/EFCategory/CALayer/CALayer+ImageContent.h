//
// Created by yizhuolin on 13-6-26.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface CALayer (ImageContent)


+ (CALayer *)layerWithImage:(UIImage *)image scale:(CGFloat)scale;

- (void)setContentImage:(UIImage *)image scale:(CGFloat)scale;

- (void)setContentImage:(UIImage *)image scale:(CGFloat)scale gravity:(NSString *)gravity;
@end