//
//  RITLPhotoHandleManager.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 对选择后的图片进行筛选的管理者
@interface RITLPhotoHandleManager : NSObject

/**
 获得选择的图片数组

 @param assets 所有的图片数组
 @param status 选中状态
 @return 
 */
+ (NSArray <PHAsset *> *)assetForAssets:(NSArray <PHAsset *> *)assets status:(BOOL *)status;


@end


@interface RITLPhotoHandleManager (RITLDurationTime)


/**
 将时间戳转换为当前的总时间，格式为00:00:00

 @param timeInterval 转换的时间戳
 @return 转换后的格式化字符串
 */
+ (NSString *) timeStringWithTimeDuration:(NSTimeInterval)timeInterval;


@end

NS_ASSUME_NONNULL_END
