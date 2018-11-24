//
//  RITLUnility.m
//  RITLKitDemo
//
//  Created by YueWen on 2017/11/30.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLUtility.h"

@implementation RITLUtility


+ (UIFont *)checkWhetherExistFontWithName:(NSString *)fontName AndSize:(CGFloat)size
{
    UIFont *checkFont = [UIFont fontWithName:fontName size:size];
    if (checkFont == nil) {
        if ([fontName containsString:@"Bold"]) {
            checkFont = [UIFont boldSystemFontOfSize:size];
        } else {
            checkFont = [UIFont systemFontOfSize:size];
        }
    }
    return checkFont;
}


//检测字符串是否是纯数字
+ (BOOL)isStringAllNumber:(NSString *)num
{
    NSString *number = @"0123456789";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:number] invertedSet];
    NSString *filtered = [[num componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [num isEqualToString:filtered];
    return basic;
}

//检测字符串是否是数字或字母组成
+ (BOOL)isStringNumberOrLetter:(NSString *)num
{
    NSString *numberOrLetter = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:numberOrLetter] invertedSet];
    NSString *filtered = [[num componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [num isEqualToString:filtered];
    return basic;
}


//检测是否是手机号码
+ (BOOL)isStringMobileNumber:(NSString *)mobileNum
{
    NSString * mobile = @"^1[34578]\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES) {
        return YES;
    }else {
        return NO;
    }
}


@end

void RITLCall(NSString *telephoneNumber)
{
    //拨打电话
    NSMutableString *tel = [[NSMutableString alloc]initWithFormat:@"tel:%@",telephoneNumber];
    
    UIApplication *application = [UIApplication sharedApplication];
    
    
    if ([application canOpenURL:[NSURL URLWithString:tel]]) {
        
        //#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 100000
        if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0 && [application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            
            if (@available(iOS 10.0, *)) {
                [application openURL:[NSURL URLWithString:tel] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(false)}completionHandler:^(BOOL success) {}];
                
            } else {
                // Fallback on earlier versions
            }
        }else {
            
            [application openURL:[NSURL URLWithString:tel]];
            
        }
        
        //#else
        
        
        //#endif
    }
}


UIFont *RITLUtilityFont(NSString *fontName,CGFloat size)
{
    return [RITLUtility checkWhetherExistFontWithName:fontName AndSize:size];
}

UIFont *RITLRegularFont(CGFloat size)
{
    return RITLUtilityFont(RITLFontPingFangSC_Regular, size);
}

UIFont *RITLMediumFont(CGFloat size)
{
    return RITLUtilityFont(RITLFontPingFangSC_Medium, size);
}

UIFont *RITLBoldFont(CGFloat size)
{
    return RITLUtilityFont(RITLFontPingFangSC_Bold, size);
}

