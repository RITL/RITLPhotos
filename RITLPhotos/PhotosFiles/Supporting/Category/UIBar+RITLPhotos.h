//
//  UINavigationBar+CustomColor.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/8/4.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (YPPhotoDemo)

/// 设置 背景色
- (void)setViewColor:(UIColor * _Nonnull)color;

/// 设置透明度
- (void)setViewAlpha:(CGFloat)alpha;

/// 清除图层,视图消失时需要调用该方法，不然会影响其他页面的效果
- (void)relieveCover;

@end


@interface UITabBar (YPPhotoDemo)

/// 设置 背景色
- (void)setViewColor:(UIColor * _Nonnull)color;

/// 设置透明度
- (void)setViewAlpha:(CGFloat)alpha;

/// 清除图层,视图消失时需要调用该方法，不然会影响其他页面的效果
- (void)relieveCover;

@end


NS_ASSUME_NONNULL_END
