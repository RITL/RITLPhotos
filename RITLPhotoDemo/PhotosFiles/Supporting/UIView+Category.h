//
//  UIView+Category.h
//  CityBao
//
//  Created by YueWen on 16/7/5.
//  Copyright © 2016年 wangpj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Bounds)

@property (nonatomic, assign, readonly)CGFloat width;
@property (nonatomic, assign, readonly)CGFloat height;


@property (nonatomic, assign, readonly)CGFloat originX;
@property (nonatomic, assign, readonly)CGFloat originY;


@property (nonatomic, assign, readonly)CGFloat maxX;
@property (nonatomic, assign, readonly)CGFloat maxY;

@end

@interface UIView (Convenice)

+ (instancetype)viewWithFrame:(CGRect)frame;

@end

@interface UIView (RemoveSubviews)

- (void)removeAllSubviews;

@end

@interface UIView (ChangeFrame)


/** 修改frame的便利方法，后面为变化的长度变化量，减少为负数 */
- (void)changeLength:(CGFloat)dLength;//变化量

/** 修改frame的便利方法，后面为变化后的长度，不能为负数*/
- (void)changeLengthWithChangedLength:(CGFloat)length;


- (void)changeOriginY:(CGFloat)dOriginY;
- (void)changeOriginYWithChangedOriginY:(CGFloat)originY;


@end




