//
//  RITLPhotosBrowseAllDataSource.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/10.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosBrowseAllDataSource.h"
#import "PHAsset+RITLPhotos.h"
#import "UICollectionViewCell+RITLPhotosAsset.h"

@interface RITLPhotosBrowseAllDataSource ()

///存储资源的对象
@property (nonatomic, strong, readwrite) PHFetchResult<PHAsset *> *assetResult;
///进行资源化的Manager
@property (nonatomic, strong, readwrite) PHCachingImageManager* imageManager;

@end

@implementation RITLPhotosBrowseAllDataSource

- (instancetype)init
{
    if (self = [super init]) {
        
        self.imageManager = PHCachingImageManager.new;
    }
    return self;
}

- (void)setCollection:(PHAssetCollection *)collection
{
    _collection = collection;
    self.assetResult = [PHAsset fetchAssetsInAssetCollection:self.collection options:nil];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //获得当前的对象
    PHAsset *asset = [self.assetResult objectAtIndex:indexPath.item];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:asset.ritl_type forIndexPath:indexPath];
    
    [cell updateAssets:asset atIndexPath:indexPath imageManager:self.imageManager];//即将显示，进行填充
    
    return cell;
}

#pragma mark - <RITLPhotosHorBrowseDataSource>

- (PHAsset *)assetAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.assetResult objectAtIndex:indexPath.item];
}

- (NSIndexPath *)defaultItemIndexPath
{
    return [NSIndexPath indexPathForItem:[self.assetResult indexOfObject:self.asset] inSection:0];
}


- (void)dealloc
{
    NSLog(@"[%@] is dealloc",NSStringFromClass(self.class));
}

@end
