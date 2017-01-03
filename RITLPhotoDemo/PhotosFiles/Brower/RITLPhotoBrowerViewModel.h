//
//  RITLPhotoBrowerViewModel.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLBaseViewModel.h"
#import "RITLCollectionViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RITLPhotoBrowerViewModel : RITLBaseViewModel <RITLCollectionViewModel>

/// 当前图片的位置指数
@property (nonatomic, assign)NSUInteger currentIndex;

/// 存储图片选择的所有资源对象
@property (nonatomic, copy)NSArray <PHAsset *> * allAssets;

/// 所有的图片资源
@property (nonatomic, copy)NSArray <PHAsset *> * allPhotoAssets;

/// 当前位置的cell应该显示清晰图的block
@property (nonatomic, copy, nullable)void(^ritl_BrowerCellShouldRefreshBlock)(UIImage *,PHAsset *,NSIndexPath *);

/// 当前的选中按钮刷新成当前图片的block
@property (nonatomic, copy, nullable)void(^ritl_BrowerSelectedBtnShouldRefreshBlock)(UIImage *);

/// 当前控制器将要消失的block
@property (nonatomic, copy, nullable)void(^ritl_BrowerWillDisAppearBlock)(void);


/**
 点击选择按钮,触发ritl_BrowerSelectedBtnShouldRefreshBlock

 @param scrollView 当前的collectionView
 */
- (void)selectedPhotoInScrollView:(UICollectionView *)scrollView;



/**
 控制器将要消失的方法
 */
- (void)controllerViewWillDisAppear;




/**
 点击发送执行的方法

 @param collection 当前的collectionView
 */
- (void)photoDidSelectedComplete:(UICollectionView *)collection;


/**
 获得当前的位置的图片对象

 @param indexPath 当前的位置
 @param collection collectionView
 @param isThumb 是否为缩略图，如果为false，则按照图片原始比例获得
 @param completeBlock 完成后的回调
 */
- (void)imageForIndexPath:(NSIndexPath *)indexPath
               collection:(UICollectionView *)collection
                  isThumb:(BOOL)isThumb
                 complete:(void(^)(UIImage *,PHAsset *)) completeBlock;





/**
 滚动视图结束滚动的方法

 @param scrollView
 */
- (void)viewModelScrollViewDidEndDecelerating:(UIScrollView *)scrollView;


@end

NS_ASSUME_NONNULL_END
