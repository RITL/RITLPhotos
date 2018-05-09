//
//  UICollectionViewCell+RITLPhotosAsset.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/9.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "UICollectionViewCell+RITLPhotosAsset.h"
#import "RITLPhotosBrowseImageCell.h"
#import "RITLPhotosBrowseLiveCell.h"
#import "RITLPhotosBrowseVideoCell.h"
#import <objc/runtime.h>
#import <RITLKit.h>

@implementation UICollectionViewCell (RITLPhotosAsset)


- (NSString *)representedAssetIdentifier
{
    return objc_getAssociatedObject(self, _cmd);
}


- (void)setRepresentedAssetIdentifier:(NSString *)representedAssetIdentifier
{
    objc_setAssociatedObject(self, @selector(representedAssetIdentifier), representedAssetIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PHAsset *)currentAsset
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCurrentAsset:(PHAsset *)currentAsset
{
    objc_setAssociatedObject(self, @selector(currentAsset), currentAsset, OBJC_ASSOCIATION_ASSIGN);
}

/// 默认不做任何事情
- (void)updateAssets:(PHAsset *)asset
         atIndexPath:(nonnull NSIndexPath *)indexPath
        imageManager:(PHCachingImageManager *)cacheManager
{
    self.representedAssetIdentifier = asset.localIdentifier;
    self.currentAsset = asset;
    
    [cacheManager requestImageForAsset:asset targetSize:@[@(asset.pixelWidth),@(asset.pixelHeight)].ritl_size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {

        //如果标志位一样
        if ([self.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {//进行赋值操作
            
            [self updateViews:result info:info];
        }
    }];
}


- (void)updateViews:(UIImage *)image info:(NSDictionary *)info { }

@end

@implementation RITLPhotosBrowseImageCell (RITLPhotosAsset)

- (void)updateViews:(UIImage *)image info:(NSDictionary *)info
{
    NSLog(@"我是普通图片");
    self.imageView.image = image;
}

@end


@implementation RITLPhotosBrowseLiveCell (RITLPhotosAsset)

- (void)updateViews:(UIImage *)image info:(NSDictionary *)info
{
    NSLog(@"我是Live图片");
    self.imageView.image = image;
}

@end

@implementation RITLPhotosBrowseVideoCell (RITLPhotosAsset)

- (void)updateViews:(UIImage *)image info:(NSDictionary *)info
{
    NSLog(@"我是视频");
    self.imageView.image = image;
}
@end
