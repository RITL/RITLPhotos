//
//  RITLPhotosTransitionDriver.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/6/22.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosTransitionDriver.h"
#import "RITLPhotosAssetTransitioning.h"
#import <RITLKit/RITLKit.h>


@interface RITLPhotosTransitionDriver ()

@property (nonatomic, assign)UINavigationControllerOperation operation;
@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong)UIViewPropertyAnimator * itemFrameAnimator;
@property (nonatomic, strong)NSMutableArray <RITLPhotosAssetTransitionItem *> *items;

@end

@implementation RITLPhotosTransitionDriver


- (instancetype)initWithOperation:(UINavigationControllerOperation)operation context:(id<UIViewControllerContextTransitioning>)context panGestureRecognizer:(UIPanGestureRecognizer *)panGesture
{
    if (self = [super init]) {
     
        self.transitionContext = context;
        self.operation = operation;
        self.panGestureRecognizer = panGesture;
        
        [self buildTransitionContext];//当转场动画开始的时候初始化所有的东西
    }
    
    return self;
}



- (void)buildTransitionContext
{
    // 创建转场获得到的所有相关视图
    UIViewController *fromViewController = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    id <RITLPhotosAssetTransitioning> fromAssetTransitioning = (id <RITLPhotosAssetTransitioning>)fromViewController;
    id <RITLPhotosAssetTransitioning> toAssetTransitioning = ( id <RITLPhotosAssetTransitioning>)toViewController;
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    UIView *containerView = self.transitionContext.containerView;
    
    // 追加手势
    [self.panGestureRecognizer addTarget:self action:@selector(updateInteraction:)];
    
    // 确定toView当前的大小以及位置
    toView.frame = [self.transitionContext finalFrameForViewController:toViewController];
    
    // 创建模糊视图
    UIVisualEffect *effect = self.operation == UINavigationControllerOperationPop ? [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight] : nil;//pop模糊模板
    UIVisualEffect *targetEffect = self.operation == UINavigationControllerOperationPop ? nil : [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];//push 模糊模板
    
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    visualEffectView.frame = containerView.bounds;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [containerView addSubview:visualEffectView];
    
    // 插入toViewController's view 到转场视图
    UIView *topView;
    CGFloat topViewTargetAlpha = 0.0;
    
    if (self.operation == UINavigationControllerOperationPush) {
        
        topView = toView;
        topViewTargetAlpha = 1.0;
        topView.alpha = 0.0;
        [containerView addSubview:toView];
        
    }else {
        
        topView = fromView;
        topViewTargetAlpha = 0.0;
        [containerView insertSubview:toView atIndex:0];
    }
    
    //感觉每个item追加存在手势的imageView
    self.items = [NSMutableArray arrayWithArray:[[fromAssetTransitioning itemsForTransitionWithContext:self.transitionContext] ritl_filter:^BOOL(RITLPhotosAssetTransitionItem * _Nonnull item) {
       
        if (![toAssetTransitioning respondsToSelector:@selector(targetFrameWithTransitionItem:)]) {
            return false;
        }
        
        CGRect targetFrame = [toAssetTransitioning targetFrameWithTransitionItem:item];
        item.targetFrame = [containerView convertRect:targetFrame toView:toView];
        item.imageView = ({
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:[containerView convertRect:item.initialFrame fromView:nil]];
            imageView.clipsToBounds = true;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = true;
            imageView.image = item.image;
            
            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(press:)];
            longPressGestureRecognizer.minimumPressDuration = 0.0;
            [imageView addGestureRecognizer:longPressGestureRecognizer];
            
            [containerView addSubview:imageView];
            imageView;
        });
        
        return true;
    
    }]];
    
    //执行回调
    [fromAssetTransitioning willTransitionFromController:fromViewController toController:toViewController items:self.items];
    [toAssetTransitioning willTransitionFromController:fromViewController toController:toViewController items:self.items];
    
    //追加动画和完成转场的动画
    [self setupTransitionAnimatorWithTransitionAnimations:^{
        
        //时长
        NSTimeInterval transitionDuration = RITLPhotosTransitionDriver.animationDuration;
        
    } transitionCompletion:^(UIViewAnimatingPosition position) {
        ;
    }];
}


- (void)press:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
}


- (BOOL)isInteractive
{
    return self.transitionContext.isInteractive;
}


#pragma mark - 创建 UIViewPropertyAnimator

- (void)setupTransitionAnimatorWithTransitionAnimations:(void(^)(void))transitionAnimaions transitionCompletion:(void(^)(UIViewAnimatingPosition))transitionCompletion
{
    
}


+ (NSTimeInterval)animationDuration
{
    return [RITLPhotosTransitionDriver propertyAnimatorWithInitialVelocity:CGVectorMake(0, 0)].duration;
}


+ (UIViewPropertyAnimator *)propertyAnimatorWithInitialVelocity:(CGVector)velocity 
{
    UISpringTimingParameters *paramters = [[UISpringTimingParameters alloc]initWithMass:4.5 stiffness:1300 damping:95 initialVelocity:velocity];
    
    return [[UIViewPropertyAnimator alloc]initWithDuration:0.8 timingParameters:paramters];
}

#pragma mark - GestureRecognizer

- (void)updateInteraction:(UIPanGestureRecognizer *)recognizer
{
    
}



@end
