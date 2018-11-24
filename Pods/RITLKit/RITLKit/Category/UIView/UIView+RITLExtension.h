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



// Use 'Pod 'RITLViewBadge'
//@protocol RITLBadge <NSObject>
//
///// badge数量，默认为nil
//@property (nonatomic, copy, nullable) NSString *ritl_badgeValue;
///// badge背景颜色，默认为(255,85,85)
//@property (nonatomic, strong) UIColor *ritl_badgeBarTintColor;
///// badge文本颜色，默认为白色
//@property (nonatomic, strong) UIColor *ritl_badgeTextColor;
///// badge文本的字体,默认为systemFontOfSize:10
//@property (nonatomic, strong) UIFont *ritl_badgeTextFont;
///// badge文本大于99（99+）时的字体，默认为 badgeTextFont
//@property (nonatomic, strong) UIFont *ritl_badgeMaxTextFont;
///// badge的大小范围，矩形，默认为(20,15)
//@property (nonatomic, assign) CGSize ritl_badgeSize;
///// badge视图的偏移，默认为(2,0,0,2)
//@property (nonatomic, assign) UIEdgeInsets ritl_badgeInset;
//
//@end
//
//
//@interface UIView (RITLBadge) <RITLBadge>
//
//@end

NS_ASSUME_NONNULL_END
