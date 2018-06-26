//
//  RITLPhotosTransitionController.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/6/22.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosTransitionController.h"

@interface RITLPhotosTransitionController(Nav)<UINavigationControllerDelegate>
@end

@interface RITLPhotosTransitionController(Pan)<UIGestureRecognizerDelegate>
@end

@interface RITLPhotosTransitionController(Inter)<UIViewControllerInteractiveTransitioning>
@end

@interface RITLPhotosTransitionController(Animated)<UIViewControllerAnimatedTransitioning>
@end


@implementation RITLPhotosTransitionController

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    if (self = [super init]) {
        
        self.navigationController = navigationController;
        navigationController.delegate = self;
        self.panGestureRecognizer = UIPanGestureRecognizer.new;
        [self configurePanGestureRecognizer];
    }
    return self;
}


/// 配置滑动手势
- (void)configurePanGestureRecognizer
{
    self.panGestureRecognizer.delegate = self;
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.panGestureRecognizer addTarget:self action:@selector(initiateTransitionInteractively:)];
    
    if (!self.navigationController.interactivePopGestureRecognizer) { return; }
    
    [self.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}


/// 初始化交互手势
- (void)initiateTransitionInteractively:(UIPanGestureRecognizer *)panGesture
{
    //如果是开始并且启动者不存在
    if (panGesture.state == UIGestureRecognizerStateBegan && self.transitionDriver == nil) {
        self.initiallyInteractive = true;//已经开启了交互手势
        [self.navigationController popViewControllerAnimated:true];
    }
}

@end


@implementation RITLPhotosTransitionController(Nav)

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    //记录方向
    self.operation = operation;
    
    return self;
}


- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self;
}

@end


@implementation RITLPhotosTransitionController(Pan)

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.transitionDriver) {
        
        // 获得响应的点
        CGPoint translation = [self.panGestureRecognizer translationInView:self.panGestureRecognizer.view];
        
        // 判断是否为垂直滑动
        BOOL translationIsVertical = (translation.y > 0) && (ABS(translation.y) > ABS(translation.x));
        
        NSInteger count = self.navigationController ? self.navigationController.viewControllers.count : 0;
        
        return translationIsVertical && count > 1;//垂直并且能够返回
    }
    
    return self.transitionDriver.isInteractive;
}

@end



@implementation RITLPhotosTransitionController(Inter)

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //初始化转场驱动
    self.transitionDriver = [[RITLPhotosTransitionDriver alloc]initWithOperation:self.operation context:transitionContext panGestureRecognizer:self.panGestureRecognizer];
}

- (BOOL)wantsInteractiveStart
{
    return self.initiallyInteractive;
}

@end


@implementation RITLPhotosTransitionController(Animated)

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    // 还原所有的属性
    self.transitionDriver = nil;
    self.initiallyInteractive = false;
    self.operation = UINavigationControllerOperationNone;
}

- (id<UIViewImplicitlyAnimating>)interruptibleAnimatorForTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.transitionDriver.transitionAnimator;
}

@end


