//
// Created by yizhuolin on 12-12-3.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PRTween+Transform.h"


@implementation PRTween (Transform)

+ (void)shake:(UIView*)itemView radius:(CGFloat)radius duration:(CGFloat)duration
{
    [PRTweenCGAffineTransformLerp lerp:itemView property:@"transform" from:CGAffineTransformTranslate(CGAffineTransformIdentity, radius, 0) to:CGAffineTransformIdentity
                              duration:duration timingFunction:&PRTweenTimingFunctionElasticOut updateBlock:nil completeBlock:nil];
}

@end

@implementation PRTweenCGAffineTransformLerp

+ (PRTweenOperation *)lerp:(id)object property:(NSString *)property from:(CGAffineTransform)from to:(CGAffineTransform)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector {
    return [PRTween lerp:object property:property period:[PRTweenCGAffineTransformLerpPeriod periodWithStartCGAffineTransform:from endCGAffineTransform:to duration:duration] timingFunction:timingFunction target:target completeSelector:selector];
}

+ (PRTweenOperation *)lerp:(id)object property:(NSString *)property from:(CGAffineTransform)from to:(CGAffineTransform)to duration:(CGFloat)duration delay:(CGFloat)delay timingFunction:(PRTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector {
    PRTweenCGAffineTransformLerpPeriod *period = [PRTweenCGAffineTransformLerpPeriod periodWithStartCGAffineTransform:from endCGAffineTransform:to duration:duration];
    period.delay = delay;
    return [PRTween lerp:object property:property period:period timingFunction:timingFunction target:target completeSelector:selector];
}

+ (PRTweenOperation *)lerp:(id)object property:(NSString *)property from:(CGAffineTransform)from to:(CGAffineTransform)to duration:(CGFloat)duration {
    return [PRTweenCGAffineTransformLerp lerp:object property:property from:from to:to duration:duration timingFunction:NULL target:nil completeSelector:NULL];
}

#if NS_BLOCKS_AVAILABLE
+ (PRTweenOperation *)lerp:(id)object property:(NSString *)property from:(CGAffineTransform)from to:(CGAffineTransform)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction updateBlock:(PRTweenUpdateBlock)updateBlock completeBlock:(PRTweenCompleteBlock)completeBlock {
    return [PRTween lerp:object property:property period:[PRTweenCGAffineTransformLerpPeriod periodWithStartCGAffineTransform:from endCGAffineTransform:to duration:duration] timingFunction:timingFunction updateBlock:updateBlock completeBlock:completeBlock];
}

+ (PRTweenOperation *)lerp:(id)object property:(NSString *)property from:(CGAffineTransform)from to:(CGAffineTransform)to duration:(CGFloat)duration delay:(CGFloat)delay timingFunction:(PRTweenTimingFunction)timingFunction updateBlock:(PRTweenUpdateBlock)updateBlock completeBlock:(PRTweenCompleteBlock)completeBlock {

    PRTweenCGAffineTransformLerpPeriod *period = [PRTweenCGAffineTransformLerpPeriod periodWithStartCGAffineTransform:from endCGAffineTransform:to duration:duration];
    [period setDelay:delay];

    return [PRTween lerp:object property:property period:period timingFunction:timingFunction updateBlock:updateBlock completeBlock:completeBlock];
}
#endif

@end

@implementation PRTweenCGAffineTransformLerpPeriod

+ (id)periodWithStartCGAffineTransform:(CGAffineTransform)aStartCGAffineTransform endCGAffineTransform:(CGAffineTransform)anEndCGAffineTransform duration:(CGFloat)duration {
    return [PRTweenCGAffineTransformLerpPeriod periodWithStartValue:[NSValue valueWithCGAffineTransform:aStartCGAffineTransform] endValue:[NSValue valueWithCGAffineTransform:anEndCGAffineTransform] duration:duration];
}

- (CGAffineTransform)startCGAffineTransform { return [self.startLerp CGAffineTransformValue]; }
- (CGAffineTransform)tweenedCGAffineTransform { return [self.tweenedLerp CGAffineTransformValue]; }
- (CGAffineTransform)endCGAffineTransform { return [self.endLerp CGAffineTransformValue]; }

- (NSValue*)tweenedValueForProgress:(CGFloat)progress {

    CGAffineTransform startCGAffineTransform = self.startCGAffineTransform;
    CGAffineTransform endCGAffineTransform = self.endCGAffineTransform;
    CGAffineTransform distance = CGAffineTransformMake(endCGAffineTransform.a - startCGAffineTransform.a,
            endCGAffineTransform.b - startCGAffineTransform.b,
            endCGAffineTransform.c - startCGAffineTransform.c,
            endCGAffineTransform.d - startCGAffineTransform.d,
            endCGAffineTransform.tx - startCGAffineTransform.tx,
            endCGAffineTransform.ty - startCGAffineTransform.ty);
    CGAffineTransform tweenedPoint = CGAffineTransformMake(startCGAffineTransform.a + distance.a * progress,
            startCGAffineTransform.b + distance.b * progress,
            startCGAffineTransform.c + distance.c * progress,
            startCGAffineTransform.d + distance.d * progress,
            startCGAffineTransform.tx + distance.tx * progress,
            startCGAffineTransform.ty + distance.ty * progress);

    return [NSValue valueWithCGAffineTransform:tweenedPoint];
}

- (void)setProgress:(CGFloat)progress {
    self.tweenedLerp = [self tweenedValueForProgress:progress];
}

@end