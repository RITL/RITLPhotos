//
//  YPPhotoStoreConfiguraion.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPPhotoDefines.h"

NS_ASSUME_NONNULL_BEGIN

/// @brief 相机胶卷
YPPHOTO_EXTERN NSString * ConfigurationCameraRoll;
/// @brief 隐藏
YPPHOTO_EXTERN NSString * ConfigurationHidden;
/// @brief 慢动作
YPPHOTO_EXTERN NSString * ConfigurationSlo_mo;
/// @brief 屏幕快照
YPPHOTO_EXTERN NSString * ConfigurationScreenshots;
/// @brief 视频
YPPHOTO_EXTERN NSString * ConfigurationVideos;
/// @brief 全景照片
YPPHOTO_EXTERN NSString * ConfigurationPanoramas;
/// @brief 定时拍照
YPPHOTO_EXTERN NSString * ConfigurationTime_lapse;
/// @brief 最近添加
YPPHOTO_EXTERN NSString * ConfigurationRecentlyAdded;
/// @brief 最近删除
YPPHOTO_EXTERN NSString * ConfigurationRecentlyDeleted;
/// @brief 快拍连照
YPPHOTO_EXTERN NSString * ConfigurationBursts;
/// @brief 喜欢
YPPHOTO_EXTERN NSString * ConfigurationFavorite;
/// @brief 自拍
YPPHOTO_EXTERN NSString * ConfigurationSelfies;





NS_AVAILABLE_IOS(8_0) @interface YPPhotoStoreConfiguraion : NSObject

@property (nonatomic, strong, readonly)NSArray * groupNamesConfig;

/** 设置获取的相册名 */
- (void)setGroupNames:(NSArray <NSString *> *)newGroupNames;

@end

NS_ASSUME_NONNULL_END
