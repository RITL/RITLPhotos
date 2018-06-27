//
//  UIButton+RITLExtension.h
//  RITLKitDemo
//
//  Created by YueWen on 2018/1/12.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 目前存在bug,崩溃的代码已经注释

@protocol RITLSetterButton <NSObject>

@optional //只是为了消除警告,实际为`@required`

///title
@property (nonatomic, copy, nullable)NSString *ritl_normalTitle;
@property (nonatomic, copy, nullable)NSString *ritl_highlightedTitle;
@property (nonatomic, copy, nullable)NSString *ritl_disabledTitle;
@property (nonatomic, copy, nullable)NSString *ritl_selectedTitle;
@property (nonatomic, copy, nullable)NSString *ritl_focusedlTitle NS_AVAILABLE_IOS(9_0);
@property (nonatomic, copy, nullable)NSString *ritl_applicationTitle;
@property (nonatomic, copy, nullable)NSString *ritl_reservedTitle;

/// attributedTitle
@property (nonatomic, copy, nullable)NSAttributedString *ritl_normalAttributedTitle;
@property (nonatomic, copy, nullable)NSAttributedString *ritl_highlightedAttributedTitle;
@property (nonatomic, copy, nullable)NSAttributedString *ritl_disabledAttributedTitle;
@property (nonatomic, copy, nullable)NSAttributedString *ritl_selectedAttributedTitle;
@property (nonatomic, copy, nullable)NSAttributedString *ritl_focusedlAttributedTitle NS_AVAILABLE_IOS(9_0);
@property (nonatomic, copy, nullable)NSAttributedString *ritl_applicationAttributedTitle;
@property (nonatomic, copy, nullable)NSAttributedString *ritl_reservedAttributedTitle;

/// color
@property (nonatomic, strong, nullable)UIColor *ritl_normalTitleColor;
@property (nonatomic, strong, nullable)UIColor *ritl_highlightedTitleColor;
@property (nonatomic, strong, nullable)UIColor *ritl_disabledTitleColor;
@property (nonatomic, strong, nullable)UIColor *ritl_selectedTitleColor;
@property (nonatomic, strong, nullable)UIColor *ritl_focusedlTitleColor NS_AVAILABLE_IOS(9_0);
@property (nonatomic, strong, nullable)UIColor *ritl_applicationTitleColor;
@property (nonatomic, strong, nullable)UIColor *ritl_reservedTitleColor;

/// titleShadowColor
@property (nonatomic, strong, nullable)UIColor *ritl_normalTitleShadowColor;
@property (nonatomic, strong, nullable)UIColor *ritl_highlightedTitleShadowColor;
@property (nonatomic, strong, nullable)UIColor *ritl_disabledTitleShadowColor;
@property (nonatomic, strong, nullable)UIColor *ritl_selectedTitleShadowColor;
@property (nonatomic, strong, nullable)UIColor *ritl_focusedlTitleShadowColor NS_AVAILABLE_IOS(9_0);
@property (nonatomic, strong, nullable)UIColor *ritl_applicationTitleShadowColor;
@property (nonatomic, strong, nullable)UIColor *ritl_reservedTitleShadowColor;

///// image
//@property (nonatomic, strong, nullable)UIImage *ritl_normalImage;
//@property (nonatomic, strong, nullable)UIImage *ritl_highlightedImage;
//@property (nonatomic, strong, nullable)UIImage *ritl_disabledImage;
//@property (nonatomic, strong, nullable)UIImage *ritl_selectedImage;
//@property (nonatomic, strong, nullable)UIImage *ritl_focusedlImage NS_AVAILABLE_IOS(9_0);
//@property (nonatomic, strong, nullable)UIImage *ritl_applicationImage;
//@property (nonatomic, strong, nullable)UIImage *ritl_reservedImage;
//

/// backgroundImage
//@property (nonatomic, strong, nullable)UIImage *ritl_normalBackgroundImage;
//@property (nonatomic, strong, nullable)UIImage *ritl_highlightedBackgroundImage;
//@property (nonatomic, strong, nullable)UIImage *ritl_disabledBackgroundImage;
//@property (nonatomic, strong, nullable)UIImage *ritl_selectedBackgroundImage;
//@property (nonatomic, strong, nullable)UIImage *ritl_focusedlBackgroundImage NS_AVAILABLE_IOS(9_0);
//@property (nonatomic, strong, nullable)UIImage *ritl_applicationBackgroundImage;
//@property (nonatomic, strong, nullable)UIImage *ritl_reservedBackgroundImage;

@end


@interface UIButton (RITLKit)<RITLSetterButton>

@end

NS_ASSUME_NONNULL_END
