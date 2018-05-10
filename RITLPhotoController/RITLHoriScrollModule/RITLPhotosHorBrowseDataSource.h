//
//  RITLPhotosHorBrowseDataSource.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/10.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RITLPhotosHorBrowseDataSource <UICollectionViewDataSource>

/// 请求图片的对象
@property (nonatomic, strong, readonly) PHCachingImageManager* imageManager;
/// 当前位置的资源对象
- (PHAsset *)assetAtIndexPath:(NSIndexPath *)indexPath;

@optional

/// 默认的第一次进入显示的item
- (NSIndexPath *)defaultItemIndexPath;

@end

NS_ASSUME_NONNULL_END
