//
//  CAGradientLayer+RITLGradientLayer.h
//  EattaClient
//
//  Created by YueWen on 2017/6/23.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/// 渐变色
@interface CAGradientLayer (RITL)

/// 默认渐变色
+ (instancetype)ritl_GradientLayer:(CGRect)bounds;
///通用渐变色设置
+(instancetype)ritl_GradientLayer:(CGRect)bounds FirstColor:(UIColor *)firstColor SecondColor:(UIColor *)secondColor;


@end

@interface NSArray (CAGradientLayer)

/// 获得CGColors的数组
@property (nonatomic, copy, readonly)NSArray* gradientColors;

@end


@interface UINavigationController (RITLNavigationBarCAGradientLayer)

/// 当前navigationBar上的所有渐变layer
@property (nonatomic, copy, readonly, nullable)NSArray < CAGradientLayer *> *ritl_gradinentLayers;
/// 默认的第一个
@property (nonatomic, strong, readonly, nullable)CAGradientLayer *ritl_firstGradientLayer;

@end

NS_ASSUME_NONNULL_END
