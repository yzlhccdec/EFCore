//
// Created by yizhuolin on 12-11-15.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "UIImageView+Transition.h"


@implementation UIImageView (Transition)

- (void)setImageWithTransition:(UIImage *)image
{
    self.image = image;
    CATransition *transition = [[CATransition alloc] init];
    //transition.type = kCATransitionFade;
    transition.duration = .5;
    [self.layer addAnimation:transition forKey:@"animateContents"];
}

@end