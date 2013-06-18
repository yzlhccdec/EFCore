//
// Created by yizhuolin on 12-11-9.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "EFButton.h"


@implementation EFButton {
    NSMutableDictionary *_items;
    NSMutableSet        *_eventsShouldIgnore;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        _items = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)dealloc {
    self.drawingBlock                  = nil;
    self.controlDidChangeToStateBlock  = nil;
    self.controlWillChangeToStateBlock = nil;
}

- (void)pushItem:(id)item withIdentifier:(id)identifier {
    [_items setObject:item forKey:identifier];
}

- (id)pollItemWithIdentifier:(id)identifier {
    return [_items objectForKey:identifier];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint p = [self convertPoint:point toView:self.superview];
    return CGRectEqualToRect(_hitArea, CGRectZero) ?
           [super pointInside:point withEvent:event] : CGRectContainsPoint(_hitArea, p);
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (event && [_eventsShouldIgnore containsObject:event]) {
        [_eventsShouldIgnore removeObject:event];
    }
    else {
        [super sendAction:action to:target forEvent:event];
    }
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (!CGRectEqualToRect(_hitArea, CGRectZero)) {
        CGPoint location = [touch locationInView:self];

        if ([self pointInside:location withEvent:event]) {
            [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
        }

        if (_eventsShouldIgnore == nil) {
            _eventsShouldIgnore = [[NSMutableSet alloc] init];
        }

        [_eventsShouldIgnore addObject:event];
    }
}

- (void)displayLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    _drawingBlock(self, context, self.bounds);

    UIGraphicsEndImageContext();
    self.layer.contents = (id) UIGraphicsGetImageFromCurrentImageContext().CGImage;
}

- (void)setDrawingBlock:(DrawingBlock)drawingBlock {
    if (drawingBlock != NULL) {
        _drawingBlock = drawingBlock;
        [self.layer setNeedsDisplay];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    UIControlState state = highlighted ? self.state | UIControlStateHighlighted : self.state & (~UIControlStateHighlighted);

    if (state == self.state) {
        return;
    }

    if (self.controlWillChangeToStateBlock) {
        self.controlWillChangeToStateBlock(self, state);
    }

    [super setHighlighted:highlighted];

    if (self.controlDidChangeToStateBlock) {
        self.controlDidChangeToStateBlock(self, state);
    }
}

- (void)setEnabled:(BOOL)enabled {
    UIControlState state = enabled ? self.state & (~UIControlStateDisabled) : self.state | UIControlStateDisabled;

    if (state == self.state) {
        return;
    }

    if (self.controlWillChangeToStateBlock) {
        self.controlWillChangeToStateBlock(self, state);
    }

    [super setEnabled:enabled];

    if (self.controlDidChangeToStateBlock) {
        self.controlDidChangeToStateBlock(self, state);
    }
}

- (void)setSelected:(BOOL)selected {
    UIControlState state = selected ? self.state | UIControlStateSelected : self.state & (~UIControlStateSelected);

    if (state == self.state) {
        return;
    }

    if (self.controlWillChangeToStateBlock) {
        self.controlWillChangeToStateBlock(self, state);
    }

    [super setSelected:selected];

    if (self.controlDidChangeToStateBlock) {
        self.controlDidChangeToStateBlock(self, state);
    }

    if (selected && _isRadioButton) {
        for (UIView *subView in self.superview.subviews) {
            if (subView != self && [subView isKindOfClass:[EFButton class]]) {
                EFButton *button = (EFButton *) subView;
                if (button.isRadioButton && ((self.groupName == nil && button.groupName == nil) ||
                        [self.groupName isEqualToString:button.groupName])) {
                    [button setSelected:NO];
                }
            }
        }
    }
}

- (void)setGroupName:(NSString *)groupName {
    [self pushItem:groupName withIdentifier:kGroupNameKey];
}

- (NSString *)groupName {
    return [self pollItemWithIdentifier:kGroupNameKey];
}

- (void)setTitle:(NSString *)title {
    [self pushItem:title withIdentifier:kTitleKey];

    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment   = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }

    _titleLabel.text = title;
}

- (NSString *)title {
    return [self pollItemWithIdentifier:kTitleKey];
}

@end