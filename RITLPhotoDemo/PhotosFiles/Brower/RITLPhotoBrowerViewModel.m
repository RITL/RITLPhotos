//
//  RITLPhotoBrowerViewModel.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPhotoBrowerViewModel.h"
#import "PHAsset+RITLPhotoRepresentation.h"

#import "RITLPhotoCacheManager.h"
#import "RITLPhotoHandleManager.h"
#import "RITLPhotoBridgeManager.h"

#import <objc/runtime.h>


@implementation RITLPhotoBrowerViewModel

-(void)dealloc
{
    NSLog(@"Dealloc %@",NSStringFromClass([self class]));
}

-(void)controllerViewWillDisAppear
{
    if (self.ritl_BrowerWillDisAppearBlock)
    {
        self.ritl_BrowerWillDisAppearBlock();
    }
}


-(void)photoDidSelectedComplete:(UICollectionView *)collection
{
    //获得当前的cathce
    RITLPhotoCacheManager * cacheManager = [RITLPhotoCacheManager sharedInstace];
    
    //表示是否没有选择任何图片
    BOOL isSimplePhoto = (cacheManager.numberOfSelectedPhoto == 0);
    
    if (isSimplePhoto)
    {
        //获得当前的偏移
        NSUInteger currentIndex = [self indexOffAssetWithScrollView:collection];
        
        currentIndex = [self ritl_indexInAllAssetFormIndexInPictureAssets:currentIndex];
        
        //修改当前的变量
        [cacheManager changeAssetIsSelectedSignal:currentIndex];
    }
    
    
    //获得所有选中的图片数组
    NSArray <PHAsset *> * assets = [RITLPhotoHandleManager assetForAssets:self.allAssets status:cacheManager.assetIsSelectedSignal];
    
    //进行回调
    [[RITLPhotoBridgeManager sharedInstance]startRenderImage:assets];
    
    //弹出
    self.dismissBlock();
    
}


-(void)selectedPhotoInScrollView:(UICollectionView *)scrollView
{
    //
    NSUInteger currentIndex = [self indexOffAssetWithScrollView:scrollView];
    
    //获得当前的资源真正的位置
    currentIndex = [self ritl_indexInAllAssetFormIndexInPictureAssets:currentIndex];
    
    
    // 修改标志位
    RITLPhotoCacheManager * cacheManager = [RITLPhotoCacheManager sharedInstace];
    
    NSUInteger item = currentIndex;
    
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
        
        return;
    }
    
    //修改状态量
    [cacheManager changeAssetIsSelectedSignal:currentIndex];
    
    [self ritl_checkPhotoSendStatusChanged];
    
    //执行block
    self.ritl_BrowerSelectedBtnShouldRefreshBlock([self ritl_imageForCurrentAssetIndex:currentIndex]);
    
}


/**
 检测当前的可用
 */
- (void)ritl_checkPhotoSendStatusChanged
{
    NSUInteger temp = [RITLPhotoCacheManager sharedInstace].numberOfSelectedPhoto;
    
    BOOL enable = (temp >= 1);
    
    self.ritl_BrowerSendStatusChangedBlock(enable,temp);
}



-(void)imageForIndexPath:(NSIndexPath *)indexPath collection:(UICollectionView *)collection isThumb:(BOOL)isThumb complete:(void (^)(UIImage * _Nonnull, PHAsset * _Nonnull))completeBlock
{
    
    void(^completeBlockCopy)(UIImage * _Nonnull, PHAsset * _Nonnull) = [completeBlock copy];
    
    NSUInteger item = indexPath.item;
    
    //获得当前资源对象
    PHAsset * asset = self.allPhotoAssets[item];
    
    //获得图片比
    CGFloat scale = asset.pixelHeight * 1.0 / asset.pixelWidth;
    
    // 默认大小
    CGSize imageSize = CGSizeMake(60, 60 * scale);
    
    
    if (!isThumb)
    {
        //获得图片的高度
        CGFloat assetHeight = (collection.width - 10) * scale;
        
        //如果不是缩略图，变成原始大小
        imageSize = CGSizeMake(collection.width - 10, assetHeight);
    }
    
    
    [asset representationImageWithSize:imageSize complete:^(UIImage * _Nullable image, PHAsset * _Nonnull asset) {
        
        completeBlockCopy(image,asset);
        
    }];
}



-(void)viewModelScrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSUInteger currentIndex = [self indexOffAssetWithScrollView:scrollView];
    
    //获得当前的位置
    NSUInteger index = self.currentIndex;
    
    //判断是否为第一次进入
    NSNumber * shouldIgnoreCurrentIndex = (NSNumber *)objc_getAssociatedObject(self, &@selector(viewModelScrollViewDidEndDecelerating:));
    
    
    if ((shouldIgnoreCurrentIndex && !shouldIgnoreCurrentIndex.boolValue) && (index && index == currentIndex))
    {
        return;
    }

    self.currentIndex = currentIndex;
    
    //修改值
    objc_setAssociatedObject(self, &@selector(viewModelScrollViewDidEndDecelerating:), @(false), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
    
    __weak typeof(self) weakSelf = self;
    
    //请求高清图片
    [self imageForIndexPath:indexPath collection:(UICollectionView *)scrollView isThumb:false complete:^(UIImage * _Nonnull image, PHAsset * _Nonnull asset) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        //进行回调
        if (strongSelf.ritl_BrowerCellShouldRefreshBlock)
        {
            strongSelf.ritl_BrowerCellShouldRefreshBlock(image,asset,indexPath);
        }

    }];
    
    //执行判定block
    if(self.ritl_BrowerSelectedBtnShouldRefreshBlock)
    {
        self.ritl_BrowerSelectedBtnShouldRefreshBlock([self ritl_imageForCurrentAssetIndex:[self ritl_indexInAllAssetFormIndexInPictureAssets:currentIndex]]);
    }
    
    //分页完毕
//    printf("分页完毕! count   contentOffSetX = %f currentIndex = %ld \n",scrollView.contentOffset.x,currentIndex);
}


/// 根据scrollView的偏移量获得当前资源的位置
- (NSUInteger)indexOffAssetWithScrollView:(UIScrollView *)scrollView
{
    //获得当前的collectionview
    UICollectionView * collectionView = (UICollectionView *)scrollView;
    
    //获得当前显示的真正索引，消除浮点型对visibleCells.count的干扰
    NSUInteger currentIndex = collectionView.contentOffset.x / collectionView.width;
    
    
    return currentIndex;
}


#pragma mark - RITLCollectionViewModel

-(NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    return self.allPhotoAssets.count;
}


-(CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath inCollection:(UICollectionView *)collection
{
    return CGSizeMake(collection.width, collection.height);
}



-(CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.;
}


-(void)didEndDisplayingCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //获得当前位置
    NSUInteger index = indexPath.item;
    
    self.ritl_BrowerSelectedBtnShouldRefreshBlock([self ritl_imageForCurrentAssetIndex:index]);
}


#pragma mark - private



/**
 从所有的图片资源转换为所有资源的位置

 @param index 当前位置
 @return 资源对象在所有资源中的位置
 */
- (NSUInteger)ritl_indexInAllAssetFormIndexInPictureAssets:(NSUInteger)index
{
    //获得当前的资源
    PHAsset * currentAsset = self.allPhotoAssets[index];
    
    return [self.allAssets indexOfObject:currentAsset];
}


/**
 当前索引的图片是否被选中

 @param index 索引
 @return
 */
- (BOOL)ritl_currentPhotoIsSelected:(NSUInteger)index
{
    //获得当前资源的状态
    return [RITLPhotoCacheManager sharedInstace].assetIsSelectedSignal[index];
}



/**
 当前选择位置显示的图片

 @param isSelected 选择状态
 @return
 */
- (UIImage *)ritl_imageForCurrentAsset:(BOOL)isSelected
{
    return isSelected ? RITLPhotoSelectedImage : RITLPhotoDeselectedImage;
}



- (UIImage *)ritl_imageForCurrentAssetIndex:(NSUInteger)index
{
    return [self ritl_imageForCurrentAsset:[self ritl_currentPhotoIsSelected:index]];
}

@end
