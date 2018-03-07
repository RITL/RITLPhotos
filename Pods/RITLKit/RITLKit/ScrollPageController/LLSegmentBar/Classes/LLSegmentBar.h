//
//  LLSegmentBar.h
//  LLSegmentBar
//
//  Created by liushaohua on 2017/6/3.
//  Copyright © 2017年 416997919@qq.com. All rights reserved.
//
//  对原有的类进行的扩充
//  源码地址:https://github.com/liuniuliuniu/LLSegmentBar

#import <UIKit/UIKit.h>
#import "LLSegmentBarConfig.h"

@class LLSegmentBar;

@protocol LLSegmentBarDelegate <NSObject>

/**
  通知外界内部的点击数据

 @param segmentBar segmentBar
 @param toIndex 选中的索引从0 开始
 @param fromIndex 上一个索引
 */
- (void)segmentBar:(LLSegmentBar *)segmentBar didSelectIndex: (NSInteger)toIndex fromIndex: (NSInteger)fromIndex;

@end

/// 默认的边距宽度
extern CGFloat LLSegmentBarButtonsMarginDefault;
/// 默认的文本高度
extern CGFloat LLSegmentBarButtonsHeightDefault;

@interface LLSegmentBar : UIView

/**
 快速创建一个选项卡控件

 @param frame frame
 @return segment
 */
+ (instancetype)segmentBarWithFrame: (CGRect)frame;
/**代理*/
@property (nonatomic,weak) id<LLSegmentBarDelegate> delegate;
/**数据源*/
@property (nonatomic, strong)NSArray<NSString *> *items;
/**当前选中的索引，双向设置*/
@property (nonatomic,assign) NSInteger selectIndex;

- (void)updateWithConfig:(void(^)(LLSegmentBarConfig *config))configBlock;


#pragma mark - 对LLSegmentBar进行的扩充

/** 指示器 */
@property (nonatomic, weak, readonly) UIImageView *indicatorView;

/// 当前位置的button
- (UIButton*)buttonWithIndex:(NSInteger)index;

#pragma mark - 功能扩充

/// 是否进行重复点击同一个button的阻隔信号，默认为true
@property (nonatomic, assign,getter=useRepetPrevent) BOOL repetPrevent;

#pragma mark - UI扩充

/// 仅仅改变UI,不执行回调
- (void)changedSelectedOnlyWithIndex:(NSInteger)index;
- (void)changedSelectedOnlyWithIndex:(NSInteger)index actionDelegate:(BOOL)action;

#pragma mark - 基础设置扩充

/// 单屏不滑动,默认为false
@property (nonatomic, assign, getter=isSimpleView) BOOL simpleView;

/// 指示条是否自动根据 item 的 title 的宽度自适应,默认为 true
@property (nonatomic, assign, getter=isIndicatorFitTitle) BOOL indicatorFitTitle;

#pragma mark - 布局扩充

/**
 left: 第一个文本距离左边界的位置
 right : 当simpleView:true时响应，决定最右侧文本距离右边界的位置
 top : 所有的距离上边界的边距
 
 默认为 UIEdgeInsetsMake(2, 0, 0, 0)
  */
@property (nonatomic, assign) UIEdgeInsets borderMarginInset;

/**
 固定的宽度，indicatorFitTitle:false时响应
 默认为14pt
 */
@property (nonatomic, assign) CGFloat indicatorConstWidth;

/**
 指示器偏移底部的偏移量
 默认为0
 */
@property (nonatomic, assign) CGFloat indicatorMarginFromBottom;

/**
 由于文字自适应，如果需要自适应完毕拓展一下宽度，使用该属性
 默认为0
 */
@property (nonatomic, assign) CGFloat buttonAddctionWidth;

/**
 button间的边距，如果进行设置，那么各个文本的间距将会按照该固定数值
 默认为LLSegmentBarButtonsMarginDefault
 */
@property (nonatomic, assign) CGFloat buttonsMargin;

/**
 button的高度，如果进行设置，那么各个button的高度将会按照该固定数值
 默认为LLSegmentBarButtonsHeightDefault
 */
@property (nonatomic, assign)CGFloat buttonsHeight;


@end
