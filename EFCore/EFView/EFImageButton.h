//
// Created by yizhuolin on 12-12-12.
//
// Copyright yizhuolin. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "EFButton.h"

@interface EFImageButton : EFButton

// 当按钮切换状态的时候是否用动画过渡, 默认为NO
@property (nonatomic) BOOL shouldAnimateStateChange;

// 当按钮切换到highlight的状态时，highlight图片是否覆盖原图片，默认为NO
@property (nonatomic) BOOL shouldHighlightedStateOverlayOthers;

// 为指定的按钮状态设置图片
- (void)setImage:(UIImage *)image forState:(UIControlState)state;

@end