//
// Created by yizhuolin on 12-12-12.
//
// To change the template use AppCode | Preferences | File Templates.
//


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
        _contentLayer.zPosition = -2;
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

- (void)setContentMode:(UIViewContentMode)contentMode {
    [super setContentMode:contentMode];
    switch (contentMode) {
        case UIViewContentModeBottom:{
            _contentLayer.contentsGravity = kCAGravityBottom;
            _highlightedLayer.contentsGravity = kCAGravityBottom;
            break;
        }
        case UIViewContentModeBottomLeft:{
            _contentLayer.contentsGravity = kCAGravityBottomLeft;
            _highlightedLayer.contentsGravity = kCAGravityBottomLeft;
            break;
        }
        case UIViewContentModeBottomRight:{
            _contentLayer.contentsGravity = kCAGravityBottomRight;
            _highlightedLayer.contentsGravity = kCAGravityBottomRight;
            break;
        }
        case UIViewContentModeCenter:{
            _contentLayer.contentsGravity = kCAGravityCenter;
            _highlightedLayer.contentsGravity = kCAGravityCenter;
            break;
        }
        case UIViewContentModeLeft:{
            _contentLayer.contentsGravity = kCAGravityLeft;
            _highlightedLayer.contentsGravity = kCAGravityLeft;
            break;
        }
        case UIViewContentModeRedraw:{
            break;
        }
        case UIViewContentModeRight:{
            _contentLayer.contentsGravity = kCAGravityRight;
            _highlightedLayer.contentsGravity = kCAGravityRight;
            break;
        }
        case UIViewContentModeScaleAspectFill:{
            _contentLayer.contentsGravity = kCAGravityResizeAspectFill;
            _highlightedLayer.contentsGravity = kCAGravityResizeAspectFill;
            break;
        }
        case UIViewContentModeScaleAspectFit:{
            _contentLayer.contentsGravity = kCAGravityResizeAspect;
            _highlightedLayer.contentsGravity = kCAGravityResizeAspect;
            break;
        }
        case UIViewContentModeScaleToFill:{
            _contentLayer.contentsGravity = kCAGravityResize;
            _highlightedLayer.contentsGravity = kCAGravityResize;
            break;
        }
        case UIViewContentModeTop:{
            _contentLayer.contentsGravity = kCAGravityTop;
            _highlightedLayer.contentsGravity = kCAGravityTop;
            break;
        }
        case UIViewContentModeTopLeft:{
            _contentLayer.contentsGravity = kCAGravityTopLeft;
            _highlightedLayer.contentsGravity = kCAGravityTopLeft;
            break;
        }
        case UIViewContentModeTopRight:{
            _contentLayer.contentsGravity = kCAGravityTopRight;
            _highlightedLayer.contentsGravity = kCAGravityTopRight;
            break;
        }
    }
}

- (void)updateLayerState {
    [CATransaction begin];
    {
        if (!_shouldAnimateStateChange) {
            [CATransaction setDisableActions:YES];
        }

        UIImage *image = [self pollItemWithIdentifier:[NSString stringWithFormat:kImageKey, self.state]];

        if (_shouldHighlightedStateOverlayOthers && image != nil) {
            _contentLayer.contents = (id)image.CGImage;
        } else {
            if ((self.state & UIControlStateHighlighted) == UIControlStateHighlighted) {
                if (image == nil) {
                    image = [self pollItemWithIdentifier:[NSString stringWithFormat:kImageKey, self.state & (~UIControlStateHighlighted)]];
                    if (image != nil) {
                        _contentLayer.contents = (id)image.CGImage;
                    }
                } else {
                    if (_highlightedLayer == nil) {
                        _highlightedLayer = [[CALayer alloc] init];
                        _highlightedLayer.frame = self.bounds;
                        _highlightedLayer.contentsGravity = kCAGravityCenter;
                        _highlightedLayer.contentsScale = _contentLayer.contentsScale;
                        _highlightedLayer.zPosition = -1;
                        [self.layer addSublayer:_highlightedLayer];
                    }
                    self.contentMode = self.contentMode;
                    _highlightedLayer.contents = (id)image.CGImage;
                    _highlightedLayer.hidden = NO;
                }
            } else {
                _highlightedLayer.hidden = YES;
                _contentLayer.contents = (id)image.CGImage;
            }
        }
    }
    [CATransaction commit];
}

@end