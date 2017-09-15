//
//  YPPhotoStoreConfiguraion.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RITLPhotoConfig.h"

NS_ASSUME_NONNULL_BEGIN

/// @brief 相机胶卷
RITL_PHOTO_EXTERN NSString * ConfigurationCameraRoll;
/// @brief 所有照片
RITL_PHOTO_EXTERN NSString * ConfigurationAllPhotos;
/// @brief 隐藏
RITL_PHOTO_EXTERN NSString * ConfigurationHidden;
/// @brief 慢动作
RITL_PHOTO_EXTERN NSString * ConfigurationSlo_mo;
/// @brief 屏幕快照
RITL_PHOTO_EXTERN NSString * ConfigurationScreenshots;
/// @brief 视频
RITL_PHOTO_EXTERN NSString * ConfigurationVideos;
/// @brief 全景照片
RITL_PHOTO_EXTERN NSString * ConfigurationPanoramas;
/// @brief 定时拍照
RITL_PHOTO_EXTERN NSString * ConfigurationTime_lapse;
/// @brief 最近添加
RITL_PHOTO_EXTERN NSString * ConfigurationRecentlyAdded;
/// @brief 最近删除
RITL_PHOTO_EXTERN NSString * ConfigurationRecentlyDeleted;
/// @brief 快拍连照
RITL_PHOTO_EXTERN NSString * ConfigurationBursts;
/// @brief 喜欢
RITL_PHOTO_EXTERN NSString * ConfigurationFavorite;
/// @brief 自拍
RITL_PHOTO_EXTERN NSString * ConfigurationSelfies;


@interface RITLPhotoStoreConfiguraion : NSObject


@property (nonatomic, strong, readonly)NSArray * groupNamesConfig;


//初始化方法
- (instancetype)initWithGroupNames:(NSArray <NSString *> *) groupNames;
+ (instancetype)storeConfigWithGroupNames:(NSArray <NSString *> *)groupNames;


/** 设置获取的相册名 */
- (void)setGroupNames:(NSArray <NSString *> *)newGroupNames;

@end

NS_ASSUME_NONNULL_END
