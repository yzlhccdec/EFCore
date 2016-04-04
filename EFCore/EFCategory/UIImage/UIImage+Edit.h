//
// Created by yizhuolin on 12-9-29.
// Add more methods by Chachi on Nov.01,15
//
// To change the template use AppCode | Preferences | File Templates.
//

typedef NS_ENUM(NSInteger, CCImageScaleMode) {
    //按比例缩放或者大小缩放
    //当size.width或者height小于1时代表比例; 大于等于1时代表逻辑像素; 0代表不指定.
            CCImageScaleModeSize,
    //限定短边，长边自适应缩放，超出指定矩形会被居中裁剪
            CCImageScaleModeAspectFill,
    //限定长边，短边自适应缩放，将目标图片限制在指定宽高矩形内
            CCImageScaleModeAspectFit,
};

@interface UIImage (Edit)

- (UIImage *)scaleToSize:(CGSize)size scaleMode:(CCImageScaleMode)scaleMode;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

- (UIColor *)averageColor;

- (UIColor *)averageColorForRect:(CGRect)rect;

- (UIImage *)croppedImage:(CGRect)bounds;

@end