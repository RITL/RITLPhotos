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
#import "RITLPhotoCacheManager.h"


@interface RITLPhotosViewModel ()

/// 存储该组所有的asset对象的集合
@property (nonatomic, strong, readwrite) PHFetchResult * assetResult;

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
    
    
    [((PHAsset *)[self.assetResult objectAtIndex:item]) representationImageWithSize:[self sizeForItemAtIndexPath:indexPath inCollection:collection] complete:^(UIImage * _Nullable image, PHAsset * _Nonnull asset) {

        //判断资源是否为图片
        if (asset.mediaType == PHAssetMediaTypeImage)
        {
            [RITLPhotoCacheManager sharedInstace].assetIsPictureSignal[item] = true;
        }
        
        completeBlock(image,asset,[RITLPhotoCacheManager sharedInstace].assetIsPictureSignal[item]);
        
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
    
    return [RITLPhotoCacheManager sharedInstace].assetIsPictureSignal[item];
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
    RITLPhotoCacheManager * cacheManager = [RITLPhotoCacheManager sharedInstace];
    
    cacheManager.assetIsSelectedSignal[item] = !cacheManager.assetIsSelectedSignal[item];
    
    // 表示消失还是选中，选中为1 未选中为 -1
    NSInteger temp = cacheManager.assetIsSelectedSignal[item] ? 1 : -1;
    
    cacheManager.numberOfSelectedPhoto += temp;
    
    //获得选择的数目
    temp = cacheManager.numberOfSelectedPhoto;
    
    BOOL enable = (temp >= 1);

    //执行允许点击以及预览的block
    self.photoSendStatusChangedBlock(enable,temp);

}


-(BOOL)imageDidSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger item = indexPath.item;
    
    return [RITLPhotoCacheManager sharedInstace].assetIsSelectedSignal[item];
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
    
    
    RITLPhotoCacheManager * photoCacheManager = [RITLPhotoCacheManager sharedInstace];
    
    //释放所有的资源
//    [photoCacheManager freeAllSignal];

    
    unsigned long assetCount = self.assetResult.count;
    
    // 初始化数组
    photoCacheManager.assetIsPictureSignal = new BOOL[assetCount];
    photoCacheManager.assetIsSelectedSignal = new BOOL[assetCount];
    
    // 初始化
    memset(photoCacheManager.assetIsPictureSignal, false, assetCount * sizeof(BOOL));
    memset(photoCacheManager.assetIsSelectedSignal, false, assetCount * sizeof(BOOL));
    
    __weak typeof(self) weakSelf = self;;
    
    
    //初始化所有图片的数组
    [self.assetResult preparationWithType:PHAssetMediaTypeImage Complete:^(NSArray<PHAsset *> * _Nullable allPhotoAssets) {
       
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.photosAssetResult = allPhotoAssets;
        
    }];

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
    [[RITLPhotoCacheManager sharedInstace] freeAllSignal];
    
    NSLog(@"Dealloc %@",NSStringFromClass([self class]));
}

@end



