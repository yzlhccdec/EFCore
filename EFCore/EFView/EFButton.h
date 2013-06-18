//
// Created by yizhuolin on 12-11-9.
//
// Copyright yizhuolin. All rights reserved.
//


#import <Foundation/Foundation.h>

// 用于@property groupName的key
#define kGroupNameKey   @"__groupName__"
#define kTitleKey       @"__title__"

@class EFButton;

typedef void (^DrawingBlock)(EFButton *button, CGContextRef drawingContext, CGRect rect);
typedef void (^StateChangeBlock)(EFButton *button, UIControlState state);

@interface EFButton : UIControl

// 按钮的可点击区域,未加入对drag系列事件的支持
@property (nonatomic) CGRect hitArea;
// 按钮需要被显示时调用的绘画代码块
@property (nonatomic, copy) DrawingBlock drawingBlock;
// 按钮状态即将改变时调用的代码块
@property (nonatomic, copy) StateChangeBlock controlWillChangeToStateBlock;
// 按钮状态已经改变时调用的代码块
@property (nonatomic, copy) StateChangeBlock controlDidChangeToStateBlock;

@property (nonatomic) BOOL isRadioButton;
@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, readonly) UILabel *titleLabel;

// 存放自定义数据的方法
- (void)pushItem:(id)item withIdentifier:(id)identifier;

// 取出自定义数据的方法
- (id)pollItemWithIdentifier:(id)identifier;

@end