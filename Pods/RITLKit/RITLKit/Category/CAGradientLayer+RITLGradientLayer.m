//
//  CAGradientLayer+RITLGradientLayer.m
//  EattaClient
//
//  Created by YueWen on 2017/6/23.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "CAGradientLayer+RITLGradientLayer.h"
#import "NSArray+RITLExtension.h"

/// 控制ritl_GradientLayer的第一个色值
#define RITLCAGradientLayerBeginColor ([UIColor.blackColor colorWithAlphaComponent:0])
/// 控制ritl_GradientLayer的第二个色值
#define RITLCAGradientLayerEndColor   ([UIColor.blackColor colorWithAlphaComponent:0.8])

@implementation CAGradientLayer (RITL)


+(instancetype)ritl_GradientLayer:(CGRect)bounds
{

    return [self ritl_GradientLayer:bounds FirstColor:RITLCAGradientLayerBeginColor SecondColor:RITLCAGradientLayerEndColor];
}

+(instancetype)ritl_GradientLayer:(CGRect)bounds FirstColor:(UIColor *)firstColor SecondColor:(UIColor *)secondColor
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = bounds;
    
    //设置渐变色
    [gradientLayer setColors:@[(id)(firstColor.CGColor),(id)(secondColor.CGColor)]];
    
    gradientLayer.anchorPoint = CGPointMake(0, 0);
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    return gradientLayer;
}

@end


@implementation NSArray (CAGradientLayer)

- (NSArray *)gradientColors
{
    return [[self ritl_filter:^BOOL(id  _Nonnull obj) {
       
        return [obj isKindOfClass:UIColor.class];
        
    }] ritl_map:^id _Nonnull(id  _Nonnull obj) {
        
        return (id)(((UIColor *)obj).CGColor);
    }];
}

@end


@implementation UINavigationController (RITLNavigationBarCAGradientLayer)


-(CAGradientLayer *)ritl_firstGradientLayer
{
    if (!self.ritl_gradinentLayers || self.ritl_gradinentLayers.count == 0) {
        
        return nil;
    }
    
    
    return self.ritl_gradinentLayers.firstObject;
}



-(NSArray<CAGradientLayer *> *)ritl_gradinentLayers
{
    return [self.navigationBar.layer.sublayers ritl_filter:^BOOL(id _Nonnull layer) {
        
        return [layer isKindOfClass:[CAGradientLayer class]];
    }];
}

@end
