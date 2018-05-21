//
//  RITLPhotosBrowseDataSource.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/18.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosHorBrowseDataSource.h"

NS_ASSUME_NONNULL_BEGIN

/// 游览所有数据的数据源
@interface RITLPhotosBrowseDataSource : NSObject <RITLPhotosHorBrowseDataSource>
/// 资源对象
@property (nonatomic, copy)NSArray <PHAsset *>*assets;
///进行资源化的Manager
@property (nonatomic, strong, readonly)PHCachingImageManager* imageManager;

@end

NS_ASSUME_NONNULL_END
