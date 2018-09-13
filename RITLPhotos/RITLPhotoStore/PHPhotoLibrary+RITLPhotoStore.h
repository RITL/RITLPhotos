//
//  PHPhotoLibrary+RITLPhotoStore.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

/// 
@interface PHPhotoLibrary (RITLPhotoStore)

- (void)fetchAlbumRegularGroups:(void(^)(NSArray <PHAssetCollection *> *))complete;
/// 获取的将'胶卷相册'放在第一位
- (void)fetchAlbumRegularGroupsByUserLibrary:(void(^)(NSArray <PHAssetCollection *> *))complete;


/// 权限检测
+ (void)authorizationStatusAllow:(void(^)(void))allowHander denied:(void(^)(void))deniedHander;
/// 权限通过进行的handler
+ (void)handlerWithAuthorizationAllow:(void(^)(void))hander;



#pragma mark - 用于替代废除数组作为数据源的方法

/// 获取photos提供的所有的分类智能相册组和相关相册组
- (void)fetchAblumRegularAndTopLevelUserResults:(void(^)(PHFetchResult<PHAssetCollection *>* regular,
                                                    PHFetchResult<PHCollection *>* topUser))complete;

@end



NS_ASSUME_NONNULL_END
