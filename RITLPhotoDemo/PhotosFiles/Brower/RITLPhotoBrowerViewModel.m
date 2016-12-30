//
//  RITLPhotoBrowerViewModel.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPhotoBrowerViewModel.h"

#import "PHAsset+RITLPhotoRepresentation.h"

#import <objc/runtime.h>

@implementation RITLPhotoBrowerViewModel


-(void)dealloc
{
    NSLog(@"Dealloc %@",NSStringFromClass([self class]));
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
    //获得当前的collectionview
    UICollectionView * collectionView = (UICollectionView *)scrollView;
    
    //获得当前显示的真正索引，消除浮点型对visibleCells.count的干扰
    NSUInteger currentIndex = collectionView.contentOffset.x / collectionView.width;
    
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
    [self imageForIndexPath:indexPath collection:collectionView isThumb:false complete:^(UIImage * _Nonnull image, PHAsset * _Nonnull asset) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        //进行回调
        if (strongSelf.ritl_BrowerCellShouldRefreshBlock)
        {
            strongSelf.ritl_BrowerCellShouldRefreshBlock(image,asset,indexPath);
        }

    }];
    
    
    //分页完毕
    printf("分页完毕! count   contentOffSetX = %f currentIndex = %ld \n",scrollView.contentOffset.x,currentIndex);

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



@end
