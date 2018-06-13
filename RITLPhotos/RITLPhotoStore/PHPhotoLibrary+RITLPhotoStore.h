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


/// 获取photos提供的所有的智能分类相册组
- (void)fetchAlbumRegularGroups:(void(^)(NSArray <PHAssetCollection *> *))complete;
/// 获取的将'胶卷相册'放在第一位
- (void)fetchAlbumRegularGroupsByUserLibrary:(void(^)(NSArray <PHAssetCollection *> *))complete;



/// 权限检测
+ (void)authorizationStatusAllow:(void(^)(void))allowHander denied:(void(^)(void))deniedHander;
/// 权限通过进行的handler
+ (void)handlerWithAuthorizationAllow:(void(^)(void))hander;

@end

NS_ASSUME_NONNULL_END
