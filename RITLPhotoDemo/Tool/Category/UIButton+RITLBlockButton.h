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
- (void)controlEvents:(UIControlEvents)controlEvents handle:(nullable void(^)(UIControl *)) eventHandleBlock;


@end


@interface UIGestureRecognizer (RITLBlockRecognizer)

/**
 用于替代目标动作回调的方法

 @param eventHandleBlock 执行的block
 */
- (void)gestureRecognizerHandle:(nullable void(^)(UIGestureRecognizer * sender)) eventHandleBlock;

@end

NS_ASSUME_NONNULL_END
