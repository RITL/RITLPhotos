//
//  UIButton+RITLBlockButton.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "UIControl+RITLBlockButton.h"
#import <objc/runtime.h>

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif



@implementation UIControl (RITLBlockButton)


-(void)controlEvents:(UIControlEvents)controlEvents handle:(void (^)(__kindof UIControl * _Nonnull))eventHandleBlock
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
    
    if (block) {
        
        block(self);//执行方法
    }
    
//    //执行block
//    block(self);
}



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


@end



@implementation UIView (RITLBlockRecognizer)


-(UITapGestureRecognizer *)addTapGestureRecognizerNumberOfTap:(NSUInteger)numberOfTap
                                                      Handler:(void (^)(UIView * _Nonnull))actionHandler
{
    self.userInteractionEnabled = true;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
    
    tapGestureRecognizer.numberOfTapsRequired = numberOfTap;
    
    __weak typeof(self) weakSelf = self;
    
    //进行响应
    [tapGestureRecognizer gestureRecognizerHandle:^(UIGestureRecognizer * _Nonnull sender) {
       
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        actionHandler(strongSelf);
        
    }];
    
    [self addGestureRecognizer:tapGestureRecognizer];
    
    return tapGestureRecognizer;
}




-(UIControl *)addUIControlHandler:(void (^)(UIView * _Nonnull))actionHandler
{
    UIControl *control = [UIControl new];
    control.backgroundColor = [UIColor clearColor];
    
    [self addSubview:control];
    
    //放到最底下
    [self insertSubview:control atIndex:0];
    
    if (!self.userInteractionEnabled) {
        self.userInteractionEnabled = true;
    }
    
    __weak typeof(self) weakSelf = self;
    
    //进行布局
    [control controlEvents:UIControlEventTouchUpInside handle:^(UIControl * _Nonnull sender) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        actionHandler(strongSelf);
        
    }];
    
    [control mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.top.right.and.bottom.offset(0);

    }];


    return control;
}



-(UIControl *)addUIControlHandlerTarget:(__weak id)target action:(SEL)action
{
    __weak typeof(self) weakSelf = self;
    
    return [self addUIControlHandler:^(UIView * _Nonnull view) {
       
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [target performSelector:action withObject:strongSelf afterDelay:0];
        
    }];
}

@end
