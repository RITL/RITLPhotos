//
//  RITLPhotosViewModel.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/11/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPhotosViewModel.h"
#import "RITLPhotoStore.h"
#import "PHObject+SupportCategory.h"


@interface RITLPhotosViewModel ()


/// 存储该组所有的asset对象的集合
@property (nonatomic, strong, readwrite) PHFetchResult * assetResult;

/// 资源是否为图片的标志位
@property (nonatomic, assign) BOOL * assetIsPicture;

/// 资源是否被选中的标志位
@property (nonatomic, assign) BOOL * assetIsSelected;

/// 存放当前所有的照片对象
@property (nonatomic, copy) NSArray <PHAsset *> * photosAssetResult;


@end

@implementation RITLPhotosViewModel






#pragma mark - RITLCollectionViewModel

-(NSUInteger)numberOfSection
{
    return 1;
}

-(NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    return self.assetResult.count;
}



     
-(void)imageForIndexPath:(NSIndexPath *)indexPath collection:(UICollectionView *)collection complete:(void (^)(UIImage * _Nonnull, PHAsset * _Nonnull, BOOL isImage))completeBlock
{
    NSUInteger item = indexPath.item;
    
    __weak typeof(self) weakSelf = self;
    
    [((PHAsset *)[self.assetResult objectAtIndex:item]) representationImageWithSize:[self sizeForItemAtIndexPath:indexPath inCollection:collection] complete:^(UIImage * _Nullable image, PHAsset * _Nonnull asset) {

        //判断资源是否为图片
        if (asset.mediaType == PHAssetMediaTypeImage)
        {
            weakSelf.assetIsPicture[item] = true;
        }
        
        completeBlock(image,asset,weakSelf.assetIsPicture[item]);
        
    }];
}




-(CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath inCollection:(UICollectionView *)collection
{
    CGFloat sizeHeight = (collection.width - 3) / 4;
    
    return CGSizeMake(sizeHeight, sizeHeight);
}


-(CGSize)referenceSizeForFooterInSection:(NSUInteger)section inCollection:(UICollectionView *)collectionView
{
    return CGSizeMake(collectionView.width, 44);
}

-(CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

-(CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
}


-(BOOL)shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger item = indexPath.item;
    
    return self.assetIsPicture[item];
}

-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.photoDidTapShouldBrowerBlock)
    {
        NSUInteger item = indexPath.item;
        
        //获得当前的照片对象
        PHAsset * asset = [self.assetResult objectAtIndex:item];
        
        //获得当前对象的位置
        NSUInteger index = [self.photosAssetResult indexOfObject:asset];
        
        //进行回调
        self.photoDidTapShouldBrowerBlock(self.photosAssetResult,asset,index);
    }
}


-(void)didSelectImageAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger item = indexPath.item;
    
    // 修改标志位
    self.assetIsSelected[item] = !self.assetIsSelected[item];
}


-(BOOL)imageDidSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger item = indexPath.item;
    
    return self.assetIsSelected[item];
}


#ifdef  __IPHONE_10_0

-(void)prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    
}


-(void)cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    
}

#endif



#pragma mark - Setter

-(void)setAssetCollection:(PHAssetCollection *)assetCollection
{
    _assetCollection = assetCollection;
    
    self.assetResult = [RITLPhotoStore fetchPhotos:assetCollection];
    
    //释放所有的资源
    [self freeAllAsset];

    
    unsigned long assetCount = self.assetResult.count;
    
    // 初始化数组
    self.assetIsPicture = new BOOL[assetCount];
    self.assetIsSelected = new BOOL[assetCount];
    
    // 初始化
    memset(self.assetIsPicture, false, assetCount * sizeof(BOOL));
    memset(self.assetIsSelected, false, assetCount * sizeof(BOOL));
    
    __weak typeof(self) weakSelf = self;;
    
    
    //初始化所有图片的数组
    [self.assetResult preparationWithType:PHAssetMediaTypeImage Complete:^(NSArray<PHAsset *> * _Nullable allPhotoAssets) {
       
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.photosAssetResult = allPhotoAssets;
        
    }];

}


- (void)freeAllAsset
{
    if (self.assetIsPicture)    free(self.assetIsPicture);
    if (self.assetIsSelected)   free(self.assetIsSelected);
}



-(NSUInteger)assetCount
{
    if (!self.assetResult)
    {
        return 0;
    }
    
    return self.assetResult.count;
}




-(NSString *)title
{
    if (!_navigationTitle)
    {
        return @"";
    }
    
    return _navigationTitle;
}


-(void)dealloc
{
    if (self.assetIsPicture)
    {
        free(self.assetIsPicture);
        NSLog(@"assetIsPicture is free!");
    }
    
    NSLog(@"Dealloc %@",NSStringFromClass([self class]));
}

@end



