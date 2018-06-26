//
//  RITLPhotosTransitionDriver.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/6/22.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosTransitionDriver.h"

@interface RITLPhotosTransitionDriver ()

@property (nonatomic, assign)UINavigationControllerOperation operation;
@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong)UIViewPropertyAnimator * itemFrameAnimator;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation RITLPhotosTransitionDriver




- (BOOL)isInteractive
{
    return self.transitionContext.isInteractive;
}

@end
