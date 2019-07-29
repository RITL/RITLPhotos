//
//  UIButton+RITLBlockButton.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIControl (RITLBlockButton)


/**
 用来替代目标动作回调的方法

 @param controlEvents 响应事件
 @param eventHandleBlock 处理事件的block
 */
- (void)controlEvents:(UIControlEvents)controlEvents handle:(nullable void(^)(__kindof UIControl *sender)) eventHandleBlock;


@end


@interface UIGestureRecognizer (RITLBlockRecognizer)

/**
 用于替代目标动作回调的方法

 @param eventHandleBlock 执行的block
 */
- (void)gestureRecognizerHandle:(nullable void(^)(UIGestureRecognizer * sender)) eventHandleBlock;

@end



@interface UIView (RITLBlockRecognizer)

/**
 UIView添加轻击手势

 缺陷---- 影响外界手势的滑动,如果numberOfTap = 1建议使用addUIControlHandler:
 
 @param numberOfTap 响应数
 @param actionHandler 处理的回调
 @return 添加的轻击手势
 */
- (UITapGestureRecognizer *)addTapGestureRecognizerNumberOfTap:(NSUInteger)numberOfTap Handler:(nullable void(^)(UIView *view)) actionHandler ;


/**
 UIView添加UIControl相应对象

 @param actionHandler 处理的回调
 @return 添加的响应Control
 */
- (UIControl *)addUIControlHandler:(nullable void(^)(UIView *view)) actionHandler;


/// 使用target action添加
- (UIControl *)addUIControlHandlerTarget:(__weak id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
