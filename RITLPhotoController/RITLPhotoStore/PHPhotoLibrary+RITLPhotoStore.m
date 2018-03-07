//
//  PHPhotoLibrary+RITLPhotoStore.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "PHPhotoLibrary+RITLPhotoStore.h"
#import "PHFetchResult+RITLPhotos.h"

@implementation PHPhotoLibrary (RITLPhotoStore)

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
    [self handlerWithAuthorizationAllow:^{
        
        albumRegular([PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil]);
    }];
}

#pragma mark - 进行权限检测后的操作

///
- (void)handlerWithAuthorizationAllow:(void(^)(void))hander
{
    [self authorizationStatusAllow:^{
        
        hander();
        
    } denied:^{}];
}

#pragma mark - 权限检测
- (void)authorizationStatusAllow:(void(^)(void))allowHander denied:(void(^)(void))deniedHander
{
    switch (PHPhotoLibrary.authorizationStatus)
    {
            //准许
        case PHAuthorizationStatusAuthorized: allowHander(); break;
            
            //待获取
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized) { allowHander(); }//允许，进行回调
                else { deniedHander(); }
            }];
        } break;
            
            //不允许,进行无权限回调
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted: deniedHander(); break;
    }
}


@end
