//
//  UINavigationBar+CustomColor.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/8/4.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "UIBar+RITLPhotos.h"
#import "UIView+RITLFrameChanged.h"
#import <objc/runtime.h>

static NSString * key;

@implementation UINavigationBar (CustomColor)


- (void)setCoverView:(UIView *)newView
{
    objc_setAssociatedObject(self, &key, newView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)coverView
{
    return objc_getAssociatedObject(self, &key);
}



-(void)setViewColor:(UIColor *)color
{
    //如果覆盖图层为nil
    if(self.coverView == nil)
    {
        self.coverView = [self createBackgroudView];
        //将图层添加到导航Bar的底层
        [self insertSubview:self.coverView atIndex:0];
        
    }
    self.coverView.backgroundColor = color;
}


-(void)setViewAlpha:(CGFloat)alpha
{
    if (self.coverView == nil) return;
    
    self.coverView.backgroundColor = [self.coverView.backgroundColor colorWithAlphaComponent:alpha];

}

-(void)relieveCover
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.coverView removeFromSuperview];
    self.coverView = nil;
}


#pragma mark - private

- (UIView *)createBackgroudView
{
    //设置背景色图片以及量度
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去除自定义背景图后形成的下端黑色横线
    [self setShadowImage:[UIImage new]];
    
    //设置图层的frame
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].ritl_width, CGRectGetHeight(self.frame))];
    
    //人机不交互
    view.userInteractionEnabled = false;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    return view;
    
}

@end

static NSString * tabkey;

@implementation UITabBar (YPPhotoDemo)

- (void)setCoverView:(UIView *)newView
{
    objc_setAssociatedObject(self, &tabkey, newView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)coverView
{
    return objc_getAssociatedObject(self, &tabkey);
}



-(void)setViewColor:(UIColor *)color
{
    //如果覆盖图层为nil
    if(self.coverView == nil)
    {
        self.coverView = [self createBackgroudView];
        //将图层添加到导航Bar的底层
        [self insertSubview:self.coverView atIndex:0];
        
    }
    self.coverView.backgroundColor = color;
}


-(void)setViewAlpha:(CGFloat)alpha
{
    if (self.coverView == nil) return;
    
    self.coverView.backgroundColor = [self.coverView.backgroundColor colorWithAlphaComponent:alpha];
    
}

-(void)relieveCover
{
   [self setBackgroundImage:[UIImage new]];
    [self.coverView removeFromSuperview];
    self.coverView = nil;
}


#pragma mark - private

- (UIView *)createBackgroudView
{
    //设置背景色图片以及量度
    [self setBackgroundImage:[UIImage new]];
    //去除自定义背景图后形成的下端黑色横线
    [self setShadowImage:[UIImage new]];
    
    //设置图层的frame
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].ritl_width, CGRectGetHeight(self.frame))];
    
    //人机不交互
    view.userInteractionEnabled = false;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    return view;
    
}

@end
