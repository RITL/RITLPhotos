//
//  RITLFilter.h
//  NongWanCloud
//
//  Created by YueWen on 2018/2/5.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (RITLFilter)

/// 是否符合该正则表达式
- (BOOL)ritl_predicatedMatches:(NSString *)predicated;

@end


typedef BOOL(^RITLFilterHandler)(NSString *text);

/// 过滤属性
@interface RITLFilter : NSObject

/// 直接返回true
@property (class, nonatomic, copy, readonly) RITLFilterHandler none;

/// 区别手机号
@property (class, nonatomic, copy, readonly) RITLFilterHandler phone;

/// 区别邮箱
@property (class, nonatomic, copy, readonly) RITLFilterHandler mail;

/// 最大长度的限制方法
+ (RITLFilterHandler)lengthFilterWithMax:(NSInteger)maxLength;

/// 最小长度的限制方法
+ (RITLFilterHandler)lengthFilterWithMin:(NSInteger)minLength;

/// 最大最小长度限制
+ (RITLFilterHandler)lengthFilterWithMin:(NSInteger)minLength Max:(NSInteger)maxLength;

@end

NS_ASSUME_NONNULL_END
