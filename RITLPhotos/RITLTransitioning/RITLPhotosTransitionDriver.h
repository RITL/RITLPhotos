//
//  RITLPhotosTransitionDriver.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/6/22.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(10_0) @interface RITLPhotosTransitionDriver : NSObject

/// 是否交互
@property (nonatomic, assign, readonly)BOOL isInteractive;
/// 转场环境
@property (nonatomic, strong)id<UIViewControllerContextTransitioning> transitionContext;
/// 转场动画
@property (nonatomic, strong) UIViewPropertyAnimator *transitionAnimator;


/// 初始化方法
- (instancetype)initWithOperation:(UINavigationControllerOperation)operation
                          context:(id<UIViewControllerContextTransitioning>)context
             panGestureRecognizer:(UIPanGestureRecognizer *)panGesture;

@end

NS_ASSUME_NONNULL_END
