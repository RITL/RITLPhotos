//
//  YPPhotoStore.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class YPPhotoStoreConfiguraion;

NS_ASSUME_NONNULL_BEGIN

NS_AVAILABLE_IOS(8_0) @interface YPPhotoStore : NSObject<PHPhotoLibraryChangeObserver>

/// @brief 配置类，用来设置相册的类
@property (nonatomic, strong, readonly)YPPhotoStoreConfiguraion * config;

//构造方法
- (instancetype)initWithConfiguration:(YPPhotoStoreConfiguraion *)configuration;
+ (instancetype)storeWithConfiguration:(YPPhotoStoreConfiguraion *)configuration;


#pragma mark - 相册组
/** 获取所有的智能分类相册组 */
- (void)fetchPhotosGroup:(void(^)(NSArray <PHAssetCollection *> *)) groups;

/** 获取默认的智能分类相册组 */
- (void)fetchDefaultPhotosGroup:(void(^)(NSArray <PHAssetCollection *> *)) groups;

/** 获取默认的所有相册组 */
- (void)fetchDefaultAllPhotosGroup:(void(^)(NSArray <PHAssetCollection *> *)) groups;

#pragma mark - 处理相册的方法
/** 对存放PHAssetCollection对象的PHFetchResult进行相册名的筛选 */
- (void)preparationWithFetchResult:(PHFetchResult <PHAssetCollection *> *)fetchResult complete:(void(^)(NSArray <PHAssetCollection *> *)) groups;

/** 获取某个相册的所有照片 */
- (PHFetchResult *)fetchPhotos:(PHAssetCollection *)group;

@end

NS_ASSUME_NONNULL_END
