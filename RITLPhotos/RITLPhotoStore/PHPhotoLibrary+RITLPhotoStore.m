//
//  PHPhotoLibrary+RITLPhotoStore.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "PHPhotoLibrary+RITLPhotoStore.h"
#import "PHFetchResult+RITLPhotos.h"
#import "NSArray+RITLPhotos.h"
#import <RITLKit/RITLKit.h>

@implementation PHPhotoLibrary (RITLPhotoStore)


- (void)fetchAlbumRegularGroupsByUserLibrary:(void (^)(NSArray<PHAssetCollection *> * _Nonnull))complete
{
    [self fetchAlbumRegularGroups:^(NSArray<PHAssetCollection *> * _Nonnull collections) {
        
        //进行排序
        NSArray <PHAssetCollection *> *sortCollections = collections.sortRegularAblumsWithUserLibraryFirst.copy;
        
        complete([sortCollections ritl_filter:^BOOL(PHAssetCollection * _Nonnull item) {
            
            PHAssetCollectionSubtype subType = item.assetCollectionSubtype;
            
            //取出不需要的数据
            return !(subType == PHAssetCollectionSubtypeSmartAlbumAllHidden || [item.localizedTitle isEqualToString:NSLocalizedString(@"Recently Deleted", @"")]);
        }]);
    }];
}



- (void)fetchAlbumRegularGroups:(void (^)(NSArray<PHAssetCollection *> * _Nonnull))complete
{
    [self fetchAssetAlbumRegularCollection:^(PHFetchResult * _Nullable albumRegular) {
        
        [albumRegular transToArrayComplete:^(NSArray<id> * _Nonnull group, PHFetchResult * _Nonnull result) {
            
            complete(group);
        }];
    }];
}



/// 获得SmartAlbum
- (void)fetchAssetAlbumRegularCollection:(void(^)(PHFetchResult * _Nullable albumRegular))albumRegular
{
    [self.class handlerWithAuthorizationAllow:^{
        
        PHFetchOptions *fetchOptions = PHFetchOptions.new;
        
        albumRegular([PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchOptions]);
    }];
}

#pragma mark - 进行权限检测后的操作

///
+ (void)handlerWithAuthorizationAllow:(void(^)(void))hander
{
    [self authorizationStatusAllow:^{
        
        hander();
        
    } denied:^{}];
}

#pragma mark - 权限检测
+ (void)authorizationStatusAllow:(void(^)(void))allowHander denied:(void(^)(void))deniedHander
{
    switch (PHPhotoLibrary.authorizationStatus)
    {
            //准许
        case PHAuthorizationStatusAuthorized: allowHander(); break;
            
            //待获取
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (status == PHAuthorizationStatusAuthorized) { allowHander(); }//允许，进行回调
                    else { deniedHander(); }
                });
            }];
        } break;
            
            //不允许,进行无权限回调
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted: deniedHander(); break;
    }
}


- (void)fetchAblumRegularAndTopLevelUserResults:(void (^)(PHFetchResult<PHAssetCollection *> * _Nonnull,
                                                     PHFetchResult<PHCollection *> *))complete
{
    [self.class handlerWithAuthorizationAllow:^{
        
        /// 智能相册
        PHFetchResult<PHAssetCollection *> *smartAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];

        /// 个人相册
        PHFetchResult <PHCollection *> *topLevelUser = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        
        complete(smartAlbum,topLevelUser);
    }];
}

@end

