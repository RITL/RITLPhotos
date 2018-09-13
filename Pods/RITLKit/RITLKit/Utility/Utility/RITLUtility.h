//
//  RITLUnility.h
//  RITLKitDemo
//
//  Created by YueWen on 2017/11/30.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define RITLEXTERN extern

#define RITL_SCREEN_WIDTH_SCALE ([UIScreen mainScreen].bounds.size.width/320.0f)
#define RITL_SCREEN_HEIGHT_SCALE ([UIScreen mainScreen].bounds.size.height/568.0f)
#define RITL_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define RITL_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#define RITL_IS_IPHONEX ((RITL_SCREEN_WIDTH == 375) && (RITL_SCREEN_HEIGHT == 812))
#define RITL_IS_IPHONEXR ((RITL_SCREEN_WIDTH == 414) && (RITL_SCREEN_HEIGHT == 896))
#define RITL_IS_IPHONEXS ((RITL_SCREEN_WIDTH == 375) && (RITL_SCREEN_HEIGHT == 812))
#define RITL_IS_IPHONEXS_MAX ((RITL_SCREEN_WIDTH == 414) && (RITL_SCREEN_HEIGHT == 896))
#define RITL_HAVE_PHONE_HEADER (RITL_IS_IPHONEX || RITL_IS_IPHONEXR || RITL_IS_IPHONEXS || RITL_IS_IPHONEXS_MAX)
#define RITL_iPhoneX RITL_HAVE_PHONE_HEADER //为了适配之前的，建议进行判定使用上面方法

#define RITL_NormalNavigationBarHeight (64)
#define RITL_iPhoneXNavigationBarHeight (88)
#define RITL_iPhoneXNavigationBarSafeDistance (88 - 44)
#define RITL_iPhoneXNavigationBarDistance (RITL_iPhoneX ? RITL_iPhoneXNavigationBarSafeDistance : 0)
#define RITL_DefaultNaviBarHeight (RITL_iPhoneX ? RITL_iPhoneXNavigationBarHeight : RITL_NormalNavigationBarHeight)

#define RITL_NormalTabBarHeight (49)
#define RITL_iPhoneXTabBarHeight (83)
#define RITL_iPhoneXTabBarSafeDistance (34)
#define RITL_iPhoneXDistance (RITL_iPhoneXTabBarHeight - RITL_NormalTabBarHeight)
#define RITL_DefaultTabBarHeight (RITL_iPhoneX ? RITL_iPhoneXTabBarHeight : RITL_NormalTabBarHeight)


#define RITL_dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}


#define RITL_dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#define RITLSafeString(x) (x ? x : @"")
#define RITL_iOS_Version_GreaterThanOrEqualTo(x) (UIDevice.currentDevice.systemVersion.floatValue >= x)


#pragma mark - color

// 颜色转换
#define RITLRGBACOLOR(r,g,b,a)\
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]



// RGB颜色转换（16进制->10进制）
#define RITLColorFromRGB(rgbValue)\
RITLRGBACOLOR(((float)((rgbValue & 0xFF0000) >> 16)),((float)((rgbValue & 0xFF00) >> 8)),((float)(rgbValue & 0xFF)),1.0)


// RGB颜色转换
#define RITLColorFromIntRBG(RED, GREEN, BLUE) RITLRGBACOLOR(RED,GREEN,BLUE,1.0)
#define RITLSimpleColorFromIntRBG(x) (RITLColorFromIntRBG(x,x,x))
#define RITLColorSimpleFromIntRBG(x) (RITLSimpleColorFromIntRBG(x))


/// font
static NSString *const RITLFontPingFangSC_Regular = @"PingFangSC-Regular";
static NSString *const RITLFontPingFangSC_Medium = @"PingFangSC-Medium";
static NSString *const RITLFontPingFangSC_Bold = @"PingFangSC-Bold";


/**
 检测字符串属性是否符合上传标准,放置字符串因为空格占位而出现空白
 
 @param property 字符串
 @return true表示符合上传要求，false表示不符合上传要求
 */
static inline BOOL ritl_checkStringProperty(NSString * property)
{
    if (!property || [property isEqualToString:@""]) {  return false; }
    
    NSMutableString * propertyHandler = [property mutableCopy];
    
    //去掉所有的空格
    [propertyHandler replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [propertyHandler length])];
    
    //不为nil并且不为空格
    return ![propertyHandler isEqualToString:@""];
}


#define RITLStandard (1024.0)

static inline NSString * ritl_sizeWithLength(NSUInteger length)
{
    //转换成Btye
    NSUInteger btye = length;
    
    //如果达到MB
    if (btye > RITLStandard * RITLStandard){
        return [NSString stringWithFormat:@"%.1fMB",btye / RITLStandard / RITLStandard];
    }
    
    else if (btye > RITLStandard){
        return [NSString stringWithFormat:@"%.0fKB",btye / RITLStandard];
    }
    
    else{
        return [NSString stringWithFormat:@"%@B",@(btye)];
    }
}


/// object ? object : subObject
static inline id ritl_default(id object,id subObject)
{
    return object ? object : subObject;
}


/// 打电话
extern void RITLCall(NSString *telephoneNumber);


@interface RITLUtility : NSObject

//检测是否是手机号码
+ (BOOL)isStringMobileNumber:(NSString *)mobileNum;

//检测字符串是否是数字或字母组成
+ (BOOL)isStringNumberOrLetter:(NSString *)num;

//检测字符串是否是纯数字
+ (BOOL)isStringAllNumber:(NSString *)num;

/// 使用字体进行检测，放置出现nil
+ (UIFont *)checkWhetherExistFontWithName:(NSString *)fontName AndSize:(CGFloat)size;

@end

RITLEXTERN UIFont *RITLUtilityFont(NSString *fontName,CGFloat size);
RITLEXTERN UIFont *RITLRegularFont(CGFloat size);
RITLEXTERN UIFont *RITLMediumFont(CGFloat size);
RITLEXTERN UIFont *RITLBoldFont(CGFloat size);

NS_ASSUME_NONNULL_END
