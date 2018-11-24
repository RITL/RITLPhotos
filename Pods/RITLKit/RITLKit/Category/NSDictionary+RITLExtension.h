//
//  NSDictionary+RITLExtension.h
//  TaoKeClient
//
//  Created by YueWen on 2017/11/2.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (RITLExtension)

/// 当前App的版本号
@property (nonatomic, copy, nullable, readonly) NSString *ritl_version;
/// 当前App的版本号
@property (nonatomic, copy, nullable, readonly, class) NSString *ritl_version;

@end


@interface NSDictionary (RITLTransToJson)

/// 获得的不带换位符json字符串
@property (nonatomic, copy, nullable, readonly) NSString *ritl_json;
/// 传递javascript的json字符串
@property (nonatomic, copy, nullable, readonly) NSString *ritl_javascript_json;

@end

NS_ASSUME_NONNULL_END
