//
//  NSDate+RITLExtension.h
//  TaoKeClient
//
//  Created by YueWen on 2017/10/24.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (RITLExtension)

/// 字符戳字符串
@property (nonatomic, copy, readonly, nullable, class)NSString *ritl_timeIntervalSince1970;
/// yyyyMMddHHmmss格式下的时间
@property (nonatomic, copy, readonly, nullable, class)NSString *ritl_uploadTime;

@end

NS_ASSUME_NONNULL_END
