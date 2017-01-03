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


-(void)controlEvents:(UIControlEvents)controlEvents handle:(void (^)(UIButton * _Nonnull))eventHandleBlock
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
    void(^block)(UIButton *)  = (void(^)(UIButton *))objc_getAssociatedObject(self, &@selector(controlEvents:handle:));
    
    //执行block
    block(self);
}


-(void)dealloc
{
    objc_removeAssociatedObjects(self);
}



@end
