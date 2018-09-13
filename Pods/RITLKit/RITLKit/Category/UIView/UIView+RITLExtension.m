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




//
//@implementation UIView (RITLBadge)
//
//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//        [self ritl_swizzledInstanceSelector:@selector(layoutSubviews) swizzled:@selector(ritl_layoutSubviews)];
//    });
//}
//
//
//- (void)ritl_layoutSubviews
//{
//    [self ritl_layoutSubviews];
//
//    if(objc_getAssociatedObject(self, @selector(ritl_badgeLabel))) { return; }
//
//    if (self.ritl_badgeLabel.hidden) { return; }
//
//    //进行布局
//    self.ritl_badgeLabel.ritl_height = self.ritl_badgeSize.height;
//    self.ritl_badgeLabel.ritl_width = self.ritl_badgeSize.width;
//    self.ritl_badgeLabel.ritl_originY = self.ritl_badgeInset.top;
//    self.ritl_badgeLabel.ritl_originX = self.ritl_width - self.ritl_badgeLabel.ritl_width / 2.0 - self.ritl_badgeInset.right;
//
//    self.ritl_badgeLabel.layer.cornerRadius = MIN(self.ritl_badgeLabel.ritl_height, self.ritl_badgeLabel.ritl_width) / 2.0;
//}
//
//
//#pragma mark - ritl_badgeSize
//
//- (CGSize)ritl_badgeSize
//{
//    NSValue *size = objc_getAssociatedObject(self, _cmd);
//
//    return  size ? size.CGSizeValue : CGSizeMake(20, 15);
//}
//
//
//- (void)setRitl_badgeSize:(CGSize)ritl_badgeSize
//{
//    objc_setAssociatedObject(self, @selector(ritl_badgeSize),[NSValue valueWithCGSize:ritl_badgeSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//    [self setNeedsLayout];
//}
//
//#pragma mark - ritl_badgeValue
//
//- (NSString *)ritl_badgeValue
//{
//    NSString *badgeValue = objc_getAssociatedObject(self, _cmd);
//
//    return badgeValue;
//}
//
//
//- (void)setRitl_badgeValue:(NSString *)ritl_badgeValue
//{
//    if (!ritl_badgeValue || ritl_badgeValue.integerValue <= 0) {
//
//        //label隐藏
//        self.ritl_badgeLabel.hidden = true; return;
//    }
//
//    //进行判定
//    objc_setAssociatedObject(self, @selector(ritl_badgeValue), ritl_badgeValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
//
//    self.ritl_badgeLabel.hidden = false;
//
//    if (ritl_badgeValue.integerValue > 99) {
//
//        self.ritl_badgeLabel.text = @"99+";
//        self.ritl_badgeLabel.font = self.ritl_badgeMaxTextFont;
//
//    }else {
//
//        self.ritl_badgeLabel.text = ritl_badgeValue;
//        self.ritl_badgeLabel.font = self.ritl_badgeTextFont;
//    }
//
//    if (![self.ritl_badgeLabel isDescendantOfView:self]) {
//
//        [self addSubview:self.ritl_badgeLabel];
//    }
//
//    [self setNeedsLayout];
//}
//
//
//#pragma mark - ritl_badgeBarTintColor
//
//- (UIColor *)ritl_badgeBarTintColor
//{
//    return ritl_default(objc_getAssociatedObject(self, _cmd),RITLColorFromIntRBG(255,85,85));
//}
//
//- (void)setRitl_badgeBarTintColor:(UIColor *)ritl_badgeBarTintColor
//{
//    objc_setAssociatedObject(self, @selector(ritl_badgeBarTintColor), ritl_badgeBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//    //设置背景色
//    self.ritl_badgeLabel.backgroundColor = ritl_badgeBarTintColor;
//}
//
//#pragma mark - ritl_badgeTextColor
//
//- (UIColor *)ritl_badgeTextColor
//{
//    return ritl_default(objc_getAssociatedObject(self, _cmd),UIColor.whiteColor);
//}
//
//- (void)setRitl_badgeTextColor:(UIColor *)ritl_badgeTextColor
//{
//    objc_setAssociatedObject(self, @selector(ritl_badgeTextColor), ritl_badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//    //设置文字颜色
//    self.ritl_badgeLabel.textColor = ritl_badgeTextColor;
//}
//
//#pragma mark - ritl_badgeTextFont
//
//- (UIFont *)ritl_badgeTextFont
//{
//    return ritl_default(objc_getAssociatedObject(self, _cmd),[UIFont systemFontOfSize:10]);
//}
//
//
//- (void)setRitl_badgeTextFont:(UIFont *)ritl_badgeTextFont
//{
//    objc_setAssociatedObject(self, @selector(ritl_badgeTextFont), ritl_badgeTextFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//    //设置文字颜色
//    self.ritl_badgeLabel.font = ritl_badgeTextFont;
//}
//
//
//#pragma mark - ritl_badgeMaxTextFont
//
//- (UIFont *)ritl_badgeMaxTextFont
//{
//    return ritl_default(objc_getAssociatedObject(self, _cmd),self.ritl_badgeTextFont);
//}
//
//- (void)setRitl_badgeMaxTextFont:(UIFont *)ritl_badgeMaxTextFont
//{
//    objc_setAssociatedObject(self, @selector(ritl_badgeMaxTextFont), ritl_badgeMaxTextFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//#pragma mark - ritl_badgeInset
//
//
//- (UIEdgeInsets)ritl_badgeInset
//{
//    NSValue *inset = objc_getAssociatedObject(self, _cmd);
//
//    return  inset ? inset.UIEdgeInsetsValue : UIEdgeInsetsMake(2, 0, 0, 2);
//}
//
//
//- (void)setRitl_badgeInset:(UIEdgeInsets)ritl_badgeInset
//{
//    objc_setAssociatedObject(self, @selector(ritl_badgeInset), [NSValue valueWithUIEdgeInsets:ritl_badgeInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//    [self setNeedsLayout];
//}
//
//
//#pragma mark - badge Label
//
//- (UILabel *)ritl_badgeLabel
//{
//    UILabel *badgeLabel = objc_getAssociatedObject(self, _cmd);
//
//    if (!badgeLabel) {
//
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.ritl_badgeSize.width, self.ritl_badgeSize.height)];
//        label.textColor = self.ritl_badgeTextColor;
//        label.font = self.ritl_badgeTextFont;
//        label.layer.masksToBounds = true;
//        label.textAlignment = NSTextAlignmentCenter;
//        label.hidden = true;
//
//
//        badgeLabel = label;
//        objc_setAssociatedObject(self, _cmd, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//
//    return badgeLabel;
//}
//

//@end
