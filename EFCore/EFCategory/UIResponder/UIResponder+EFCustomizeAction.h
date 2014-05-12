//
// Created by yizhuolin on 14-5-12.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol EFCustomizeActionDelegate <NSObject>

@optional
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender;

@end

@interface UIResponder (EFCustomizeAction)

@property(nonatomic, weak) id <EFCustomizeActionDelegate> actionDelegate;
@property(nonatomic, assign) BOOL                         shouldDisableActions;


@end