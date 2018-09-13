//
//  RITLPhotosBrowseDataSource.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/18.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosBrowseDataSource.h"
#import "PHAsset+RITLPhotos.h"
#import "UICollectionViewCell+RITLPhotosAsset.h"

@interface RITLPhotosBrowseDataSource()

///进行资源化的Manager
@property (nonatomic, strong, readwrite) PHCachingImageManager* imageManager;

@end

@implementation RITLPhotosBrowseDataSource

- (instancetype)init
{
    if (self = [super init]) {
        
        self.imageManager = PHCachingImageManager.new;
    }
    return self;
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //获得当前的对象
    PHAsset *asset = self.assets[indexPath.item];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:asset.ritl_type forIndexPath:indexPath];
    
    [cell updateAssets:asset atIndexPath:indexPath imageManager:self.imageManager];//即将显示，进行填充
    
    return cell;
}



#pragma mark - <RITLPhotosHorBrowseDataSource>

- (PHAsset *)assetAtIndexPath:(NSIndexPath *)indexPath
{
    return self.assets[indexPath.item];
}

- (NSIndexPath *)defaultItemIndexPath
{
    return [NSIndexPath indexPathForItem:0 inSection:0];
}


- (void)dealloc
{
    NSLog(@"[%@] is dealloc",NSStringFromClass(self.class));
}


@end
