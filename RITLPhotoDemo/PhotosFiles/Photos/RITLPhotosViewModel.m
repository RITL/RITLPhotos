//
//  RITLPhotosViewModel.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/11/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPhotosViewModel.h"
#import "RITLPhotoStore.h"

#import "PHAsset+RITLPhotoRepresentation.h"
#import "PHFetchResult+RITLPhotoRepresentation.h"

#import "RITLPhotoCacheManager.h"
#import "RITLPhotoHandleManager.h"
#import "RITLPhotoBridgeManager.h"


@interface RITLPhotosViewModel ()

/// 存储该组所有的asset对象的集合
@property (nonatomic, strong, readwrite) PHFetchResult * assetResult;

/// 存储该组所有的asset对象的数组
@property (nonatomic, copy)NSArray <PHAsset * > * assetResults;

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



     
-(void)imageForIndexPath:(NSIndexPath *)indexPath collection:(UICollectionView *)collection complete:(void (^)(UIImage * _Nonnull, PHAsset * _Nonnull, BOOL isImage,NSTimeInterval durationTime))completeBlock
{
    NSUInteger item = indexPath.item;
    
    
    [((PHAsset *)[self.assetResult objectAtIndex:item]) representationImageWithSize:[self sizeForItemAtIndexPath:indexPath inCollection:collection] complete:^(UIImage * _Nullable image, PHAsset * _Nonnull asset) {

        //判断资源是否为图片
        if (asset.mediaType == PHAssetMediaTypeImage)
        {
            [RITLPhotoCacheManager sharedInstace].assetIsPictureSignal[item] = true;
        }
        
        completeBlock(image,asset,[RITLPhotoCacheManager sharedInstace].assetIsPictureSignal[item],asset.duration);
        
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
        
        //获得当前对象在所有图片对象的位置
        NSUInteger index = [self.photosAssetResult indexOfObject:asset];
        
        //进行回调
        self.photoDidTapShouldBrowerBlock(self.assetResult,self.assetResults,self.photosAssetResult,asset,index);
    }
}


-(BOOL)didSelectImageAtIndexPath:(NSIndexPath *)indexPath
{
    // 修改标志位
    RITLPhotoCacheManager * cacheManager = [RITLPhotoCacheManager sharedInstace];
    
    NSUInteger item = indexPath.item;
    
    // 表示消失还是选中，选中为1 未选中为 -1
    NSInteger temp = cacheManager.assetIsSelectedSignal[item] ? -1 : 1;
    
    cacheManager.numberOfSelectedPhoto += temp;
    
    //判断当前数目是否达到上限
    if (cacheManager.numberOfSelectedPhoto > cacheManager.maxNumberOfSelectedPhoto)
    {
        //退回
        cacheManager.numberOfSelectedPhoto --;
        
        //弹出提醒框
        self.warningBlock(false,cacheManager.maxNumberOfSelectedPhoto);
        
        return false;
    }
    
    // 修改数据源标志位
    cacheManager.assetIsSelectedSignal[item] = !cacheManager.assetIsSelectedSignal[item];
    
    [self ritl_checkPhotoSendStatusChanged];
    
    return true;

}



/**
 检测当前的可用
 */
- (void)ritl_checkPhotoSendStatusChanged
{
    NSUInteger temp = [RITLPhotoCacheManager sharedInstace].numberOfSelectedPhoto;
    
    BOOL enable = (temp >= 1);
    
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
    
    unsigned long assetCount = self.assetResult.count;
    
    // 初始化
    [photoCacheManager allocInitAssetIsPictureSignal:assetCount];
    [photoCacheManager allocInitAssetIsSelectedSignal:assetCount];
    
    __weak typeof(self) weakSelf = self;;
    
    //初始化所有图片的数组
    [self.assetResult preparationWithType:PHAssetMediaTypeImage Complete:^(NSArray<PHAsset *> * _Nullable allPhotoAssets) {
       
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.photosAssetResult = allPhotoAssets;
        
    }];

}



-(void)setAssetResult:(PHFetchResult *)assetResult
{
    _assetResult = assetResult;
    
    //初始化所有的数组
    [assetResult transToArrayComplete:^(NSArray<PHAsset *> * _Nonnull assets, PHFetchResult * _Nonnull result) {
       
        // 赋值
        self.assetResults = assets;
        
    }];
    
}



-(void)photoDidSelectedComplete
{
    //获得所有选中的图片数组
    NSArray <PHAsset *> * assets = [RITLPhotoHandleManager assetForAssets:self.assetResults status:[RITLPhotoCacheManager sharedInstace].assetIsSelectedSignal];
    
    //进行回调
    [[RITLPhotoBridgeManager sharedInstance]startRenderImage:assets];
    
    //弹出
    self.dismissBlock();
}



-(void)pushBrowerControllerByBrowerButtonTap
{
    //获得所有选中的图片数组
    NSArray <PHAsset *> * assets = [RITLPhotoHandleManager assetForAssets:self.assetResults status:[RITLPhotoCacheManager sharedInstace].assetIsSelectedSignal];
    
    //当前位置
    NSUInteger index = 0;
    
    //进行回调
    self.photoDidTapShouldBrowerBlock(self.assetResult,self.assetResults,assets,nil,index);
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



