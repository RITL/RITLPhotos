//
//  RITLPhotosTransitionController.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/6/22.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RITLPhotosTransitionDriver.h"

NS_ASSUME_NONNULL_BEGIN

/// 转场动画
@interface RITLPhotosTransitionController : NSObject

/// 持有的导航栏
@property (nonatomic, weak, nullable)UINavigationController *navigationController;
/// 导航栏滑动的方向
@property (nonatomic, assign)UINavigationControllerOperation operation;
/// 动画驱动者
@property (nonatomic, strong, nullable)RITLPhotosTransitionDriver *transitionDriver;
/// 创建交互手势
@property (nonatomic, assign)BOOL initiallyInteractive;
/// 滑动手势
@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;

/// 初始化对象
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end

NS_ASSUME_NONNULL_END
