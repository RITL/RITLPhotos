//
//  NSString+RITLPhotos.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/8.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (RITLPhotos)

/**
 将时间戳转换为当前的总时间，格式为00:00:00
 
 @param timeInterval 转换的时间戳
 @return 转换后的格式化字符串
 */
+ (NSString *)timeStringWithTimeDuration:(NSTimeInterval)timeInterval;

@end

NS_ASSUME_NONNULL_END
