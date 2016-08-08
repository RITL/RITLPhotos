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

/** 获取photos提供的所有的智能分类相册组，与config属性无关 */
- (void)fetchPhotosGroup:(void(^)(NSArray <PHAssetCollection *> *)) groups;


/** 
 *  根据photos提供的智能分类相册组
 *  根据config中的groupNamesConfig属性进行筛别
 */
- (void)fetchDefaultPhotosGroup:(void(^)(NSArray <PHAssetCollection *> *)) groups;


/** 
 *  根据photos提供的智能分类相册组
 *  根据config中的groupNamesConfig属性进行筛别 并添加上其他在手机中创建的相册 
 */
- (void)fetchDefaultAllPhotosGroup:(void(^)(NSArray <PHAssetCollection *> * , PHFetchResult *)) groups;


#pragma mark - 处理相册的方法

/** 获取某个相册的所有照片的简便方法 */
- (PHFetchResult *)fetchPhotos:(PHAssetCollection *)group;


#pragma mark - 发生变化的Block

/// @brief 相册发生变化进行的回调block
@property (nullable, nonatomic, copy)void(^photoStoreHasChanged)(PHChange * changeInstance);

@end



NS_CLASS_AVAILABLE_IOS(8_0) @interface YPPhotoStoreHandleClass : NSObject

/// 根据size以及图片状态获取资源转化后的图片对象数组
+ (void)imagesWithAssets:(NSArray <PHAsset *> *)assets status:(NSArray <NSNumber *> *)status Size:(CGSize)size complete:(void (^)(NSArray <UIImage *> *))imagesBlock;

@end


NS_ASSUME_NONNULL_END
