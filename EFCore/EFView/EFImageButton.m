//
// Created by yizhuolin on 12-12-12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "EFImageButton.h"

#define kImageKey @"state_image_%d"

@implementation EFImageButton {
    CALayer *_highlightedLayer;
    CALayer *_contentLayer;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        _shouldAnimateStateChange = NO;
        _contentLayer = [[CALayer alloc] init];
        _contentLayer.contentsGravity = kCAGravityCenter;
        _contentLayer.frame = self.bounds;
        [self.layer addSublayer:_contentLayer];
    }

    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _highlightedLayer.frame = self.bounds;
    _contentLayer.frame = self.bounds;
}

- (void)setShouldHighlightedStateOverlayOthers:(BOOL)shouldHighlightedStateOverlayOthers {
    if (_shouldHighlightedStateOverlayOthers == shouldHighlightedStateOverlayOthers) {
        return;
    }

    _shouldHighlightedStateOverlayOthers = shouldHighlightedStateOverlayOthers;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [self pushItem:image withIdentifier:[NSString stringWithFormat:kImageKey, state]];
    _contentLayer.contentsScale = image.scale;
    [self updateLayerState];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];

    if ([self pointInside:[touch locationInView:self] withEvent:event]) {
//        self.selected = !self.selected;
    }
}

- (void)setSelected:(BOOL)selected {
    if (self.selected == selected) {
        return;
    }

    [super setSelected:selected];

    [self updateLayerState];
}

- (void)setEnabled:(BOOL)enabled {
    if (self.enabled == enabled) {
        return;
    }

    [super setEnabled:enabled];
    [self updateLayerState];
}

- (void)setHighlighted:(BOOL)highlighted {
    if (self.highlighted == highlighted) {
        return;
    }

    [super setHighlighted:highlighted];

    [self updateLayerState];
}

- (UIImage *)imageForState:(UIControlState)state {
    // remove illegal state
    if ((state & UIControlStateDisabled) == UIControlStateDisabled) {
        state &= ~UIControlStateHighlighted;
    }

    UIImage *image = [self pollItemWithIdentifier:[NSString stringWithFormat:kImageKey, state]];
    if (image) {
        return image;
    }

    switch (state) {
        case UIControlStateSelected | UIControlStateHighlighted: {
            image = [self pollItemWithIdentifier:[NSString stringWithFormat:kImageKey, UIControlStateHighlighted]];
            if (image) {
                return image;
            }
            image = [self pollItemWithIdentifier:[NSString stringWithFormat:kImageKey, UIControlStateSelected]];
            if (image) {
                return image;
            }
            break;
        }
        case UIControlStateDisabled | UIControlStateSelected: {
            image = [self pollItemWithIdentifier:[NSString stringWithFormat:kImageKey, UIControlStateSelected]];
            if (image) {
                return image;
            }
            image = [self pollItemWithIdentifier:[NSString stringWithFormat:kImageKey, UIControlStateDisabled]];
            if (image) {
                return image;
            }
            break;
        }
        default: {
            break;
        }
    }
    return [self pollItemWithIdentifier:[NSString stringWithFormat:kImageKey, UIControlStateNormal]];
}

- (void)updateLayerState {
    [CATransaction begin];
    {
        if (!_shouldAnimateStateChange) {
            [CATransaction setDisableActions:YES];
        }

        if (_shouldHighlightedStateOverlayOthers) {
            _contentLayer.contents = (id)[self imageForState:self.state].CGImage;
        } else {
            if ((self.state & UIControlStateHighlighted) == UIControlStateHighlighted) {
                if (_highlightedLayer == nil) {
                    _highlightedLayer = [[CALayer alloc] init];
                    _highlightedLayer.frame = self.bounds;
                    _highlightedLayer.contentsGravity = kCAGravityCenter;
                    _highlightedLayer.contentsScale = _contentLayer.contentsScale;
                    [self.layer addSublayer:_highlightedLayer];
                }
                _highlightedLayer.contents = (id)[self imageForState:self.state].CGImage;
                _highlightedLayer.hidden = NO;
            } else {
                _highlightedLayer.hidden = YES;
                _contentLayer.contents = (id)[self imageForState:self.state].CGImage;
            }
        }
    }
    [CATransaction commit];
}

@end