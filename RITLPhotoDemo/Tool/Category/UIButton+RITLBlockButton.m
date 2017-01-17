//
//  UIButton+RITLBlockButton.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "UIButton+RITLBlockButton.h"

#import <objc/runtime.h>

@implementation UIControl (RITLBlockButton)


-(void)controlEvents:(UIControlEvents)controlEvents handle:(void (^)(UIControl * _Nonnull))eventHandleBlock
{
    if (!eventHandleBlock)
    {
        return;
    }
    
    //将block缓存
    objc_setAssociatedObject(self, &@selector(controlEvents:handle:), eventHandleBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    //添加目标动作回调
    [self addTarget:self action:@selector(actionFunction) forControlEvents:controlEvents];
}


- (void)actionFunction
{
    //获得block
    void(^block)(UIControl *)  = (void(^)(UIControl *))objc_getAssociatedObject(self, &@selector(controlEvents:handle:));
    
    //执行block
    block(self);
}


//-(void)dealloc
//{
//    objc_removeAssociatedObjects(self);
//}

@end


@implementation UIGestureRecognizer (RITLBlockRecognizer)

-(void)gestureRecognizerHandle:(void (^)(UIGestureRecognizer * _Nonnull))eventHandleBlock
{
    if ((!eventHandleBlock))
    {
        return;
    }
    
    //将block缓存
    objc_setAssociatedObject(self, &@selector(gestureRecognizerHandle:), eventHandleBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    //添加目标动作回调
    [self addTarget:self action:@selector(gestureActionFunction:)];
}



- (void)gestureActionFunction:(UIGestureRecognizer *)sender
{
    //获得block
    void(^block)(UIGestureRecognizer *)  = (void(^)(UIGestureRecognizer *))objc_getAssociatedObject(self, &@selector(gestureRecognizerHandle:));
    
    //执行block
    block(self);
}


//-(void)dealloc
//{
//    objc_removeAssociatedObjects(self);
//}

@end
