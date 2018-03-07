//
//  UIButton+RITLExtension.h
//  RITLKitDemo
//
//  Created by YueWen on 2018/1/12.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RITLSetterButton <NSObject>

@optional //只是为了消除警告,实际为`@required`

///title
@property (nonatomic, copy)NSString *ritl_normalTitle;
@property (nonatomic, copy)NSString *ritl_highlightedTitle;
@property (nonatomic, copy)NSString *ritl_disabledTitle;
@property (nonatomic, copy)NSString *ritl_selectedTitle;
@property (nonatomic, copy)NSString *ritl_focusedlTitle NS_AVAILABLE_IOS(9_0);
@property (nonatomic, copy)NSString *ritl_applicationTitle;
@property (nonatomic, copy)NSString *ritl_reservedTitle;

/// attributedTitle
@property (nonatomic, copy)NSString *ritl_normalAttributedTitle;
@property (nonatomic, copy)NSString *ritl_highlightedAttributedTitle;
@property (nonatomic, copy)NSString *ritl_disabledAttributedTitle;
@property (nonatomic, copy)NSString *ritl_selectedAttributedTitle;
@property (nonatomic, copy)NSString *ritl_focusedlAttributedTitle NS_AVAILABLE_IOS(9_0);
@property (nonatomic, copy)NSString *ritl_applicationAttributedTitle;
@property (nonatomic, copy)NSString *ritl_reservedAttributedTitle;

/// color
@property (nonatomic, strong)UIColor *ritl_normalTitleColor;
@property (nonatomic, strong)UIColor *ritl_highlightedTitleColor;
@property (nonatomic, strong)UIColor *ritl_disabledTitleColor;
@property (nonatomic, strong)UIColor *ritl_selectedTitleColor;
@property (nonatomic, strong)UIColor *ritl_focusedlTitleColor NS_AVAILABLE_IOS(9_0);
@property (nonatomic, strong)UIColor *ritl_applicationTitleColor;
@property (nonatomic, strong)UIColor *ritl_reservedTitleColor;

/// titleShadowColor
@property (nonatomic, strong)UIColor *ritl_normalTitleShadowColor;
@property (nonatomic, strong)UIColor *ritl_highlightedTitleShadowColor;
@property (nonatomic, strong)UIColor *ritl_disabledTitleShadowColor;
@property (nonatomic, strong)UIColor *ritl_selectedTitleShadowColor;
@property (nonatomic, strong)UIColor *ritl_focusedlTitleShadowColor NS_AVAILABLE_IOS(9_0);
@property (nonatomic, strong)UIColor *ritl_applicationTitleShadowColor;
@property (nonatomic, strong)UIColor *ritl_reservedTitleShadowColor;

/// image
@property (nonatomic, strong)UIImage *ritl_normalImage;
@property (nonatomic, strong)UIImage *ritl_highlightedImage;
@property (nonatomic, strong)UIImage *ritl_disabledImage;
@property (nonatomic, strong)UIImage *ritl_selectedImage;
@property (nonatomic, strong)UIImage *ritl_focusedlImage NS_AVAILABLE_IOS(9_0);
@property (nonatomic, strong)UIImage *ritl_applicationImage;
@property (nonatomic, strong)UIImage *ritl_reservedImage;


/// backgroundImage
@property (nonatomic, strong)UIImage *ritl_normalBackgroundImage;
@property (nonatomic, strong)UIImage *ritl_highlightedBackgroundImage;
@property (nonatomic, strong)UIImage *ritl_disabledBackgroundImage;
@property (nonatomic, strong)UIImage *ritl_selectedBackgroundImage;
@property (nonatomic, strong)UIImage *ritl_focusedlBackgroundImage NS_AVAILABLE_IOS(9_0);
@property (nonatomic, strong)UIImage *ritl_applicationBackgroundImage;
@property (nonatomic, strong)UIImage *ritl_reservedBackgroundImage;

@end


@interface UIButton (RITLKit)<RITLSetterButton>

@end

NS_ASSUME_NONNULL_END
