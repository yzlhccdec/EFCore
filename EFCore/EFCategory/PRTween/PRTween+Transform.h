//
// Created by yizhuolin on 12-12-3.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PRTween.h"

@interface PRTween (Transform)
+ (void)shake:(UIView *)itemView radius:(CGFloat)radius duration:(CGFloat)duration;


@end

@interface PRTweenCGAffineTransformLerp : NSObject
+ (PRTweenOperation *)lerp:(id)object property:(NSString*)property from:(CGAffineTransform)from to:(CGAffineTransform)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector;
+ (PRTweenOperation *)lerp:(id)object property:(NSString*)property from:(CGAffineTransform)from to:(CGAffineTransform)to duration:(CGFloat)duration delay:(CGFloat)delay timingFunction:(PRTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector;
+ (PRTweenOperation *)lerp:(id)object property:(NSString*)property from:(CGAffineTransform)from to:(CGAffineTransform)to duration:(CGFloat)duration;
#if NS_BLOCKS_AVAILABLE
+ (PRTweenOperation *)lerp:(id)object property:(NSString*)property from:(CGAffineTransform)from to:(CGAffineTransform)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction updateBlock:(PRTweenUpdateBlock)updateBlock completeBlock:(PRTweenCompleteBlock)completeBlock;
+ (PRTweenOperation *)lerp:(id)object property:(NSString *)property from:(CGAffineTransform)from to:(CGAffineTransform)to duration:(CGFloat)duration delay:(CGFloat)delay timingFunction:(PRTweenTimingFunction)timingFunction updateBlock:(PRTweenUpdateBlock)updateBlock completeBlock:(PRTweenCompleteBlock)completeBlock;
#endif
@end

@interface PRTweenCGAffineTransformLerpPeriod : PRTweenLerpPeriod <PRTweenLerpPeriod>
+ (id)periodWithStartCGAffineTransform:(CGAffineTransform)aStartCGAffineTransform endCGAffineTransform:(CGAffineTransform)anEndCGAffineTransform duration:(CGFloat)duration;
- (CGAffineTransform)startCGAffineTransform;
- (CGAffineTransform)tweenedCGAffineTransform;
- (CGAffineTransform)endCGAffineTransform;
@end

