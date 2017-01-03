//
//  UIViewController+Frame.h
//  YOpenFiles
//
//  Created by YueWen on 16/6/17.
//  Copyright © 2017年 YueWen. All rights reserved.
//  控制器获得frame的便利方法

#import <UIKit/UIKit.h>

@interface UIViewController (Frame)

#pragma mark - *************** View宽高
@property (nonatomic, assign, readonly)NSUInteger width;
@property (nonatomic, assign, readonly)NSUInteger height;



#pragma mark - *************** View起始点
@property (nonatomic, assign, readonly)CGFloat originX;
@property (nonatomic, assign, readonly)CGFloat originY;


#pragma mark - *************** View中心
@property (nonatomic, assign, readonly)CGPoint center;

//---------------新增centerX 以及 centerY - Yue - 2016-08-05
@property (nonatomic, readonly, assign)CGFloat centerX;
@property (nonatomic, readonly, assign)CGFloat centerY;

#pragma mark - *************** View的bounds
@property (nonatomic, assign, readonly)CGRect bounds;


@end

@interface UIScreen (Frame)

#pragma mark - *************** Screen宽高
@property (nonatomic, assign, readonly)NSUInteger width;
@property (nonatomic, assign, readonly)NSUInteger height;


@end


