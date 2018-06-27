//
//  RITLPhotosBrowseAllDataSource.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/10.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosHorBrowseDataSource.h"

NS_ASSUME_NONNULL_BEGIN

/// 游览所有数据的数据源
@interface RITLPhotosBrowseAllDataSource : NSObject <RITLPhotosHorBrowseDataSource>

///当前预览组的对象
@property (nonatomic, strong)PHAssetCollection *collection;
///当前点击进入的资源对象
@property (nonatomic, strong)PHAsset *asset;
///存储资源的对象
@property (nonatomic, strong, readonly) PHFetchResult<PHAsset *> *assetResult;
///进行资源化的Manager
@property (nonatomic, strong, readonly) PHCachingImageManager* imageManager;

@end

NS_ASSUME_NONNULL_END
