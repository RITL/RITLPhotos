//
//  UIView+RITLExtension.m
//  TaoKeClient
//
//  Created by YueWen on 2017/10/25.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "UIView+RITLExtension.h"
#import "RITLUtility.h"
#import <RITLViewFrame/UIView+RITLFrameChanged.h>
#import "RITLRuntimeTool.h"
#import <objc/runtime.h>

@implementation UIView (RITLExtension)

- (void)ritl_addShadowLayerAllaroundViewPadding:(CGFloat)padding
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(-1 * padding, -1 * padding)];
    //添加直线
    [path addLineToPoint:CGPointMake(self.bounds.size.width + padding, -1 * padding)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width + padding, self.bounds.size.height + padding)];
    [path addLineToPoint:CGPointMake(-1 * padding, self.bounds.size.height + padding)];
    [path addLineToPoint:CGPointMake(-1 * padding, -1 * padding)];
    
    //设置阴影路径
    self.layer.shadowPath = path.CGPath;

}

@end
