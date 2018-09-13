//
//  RITLPhotosConfiguration.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/17.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 配置
@interface RITLPhotosConfiguration : NSObject

/// 配置请使用该参数进行配置
+ (instancetype)defaultConfiguration;

/// 支持的最大选择数，默认为9
@property (nonatomic, assign)NSInteger maxCount;
/// 是否支持视频,默认为true
@property (nonatomic, assign)BOOL containVideo;
/// 是否隐藏没有图片的分组，默认为false
@property (nonatomic, assign)BOOL hiddenGroupWhenNoPhotos;

@end

NS_ASSUME_NONNULL_END
