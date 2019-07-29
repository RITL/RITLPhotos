//
//  UIView+RITLExtension.h
//  TaoKeClient
//
//  Created by YueWen on 2017/10/25.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (RITLExtension)

/// 四周追加阴影效果，padding为扩散范围
- (void)ritl_addShadowLayerAllaroundViewPadding:(CGFloat)padding;

@end


NS_ASSUME_NONNULL_END
