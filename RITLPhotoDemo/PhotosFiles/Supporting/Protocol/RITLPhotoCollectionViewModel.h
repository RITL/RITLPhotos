//
//  RITLCollectionViewModel.h
//  CityBao
//
//  Created by YueWen on 2016/11/16.
//  Copyright © 2017年 wangpj. All rights reserved.
//

#import "RITLPhotoScrollViewModel.h"
#import "RITLCollectionCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RITLPhotoCollectionViewModel <NSObject,RITLPhotoScrollViewModel,RITLCollectionCellViewModel>

@optional


#pragma mark - CollectionView DataSource



/**
 collection的组数

 @return section的数目
 */
- (NSUInteger)numberOfSection;


/**
 CollectionView 每组item的个数
 
 @param section 组section
 @return 当前section的个数
 */
- (NSUInteger)numberOfItemsInSection:(NSInteger)section;



#pragma mark - Collection FlowLayout



/**
 CollectionView 当前位置的大小
 
 @param indexPath 位置indexPath
 @param collection 执行方法的collection
 @return 当前indexPath的item大小
 */
- (CGSize)sizeForItemAtIndexPath:(nullable NSIndexPath *)indexPath inCollection:(UICollectionView *)collection;




/**
 CollectionView 的footerView的大小

 @param section 当前footerView的section
 @param collectionView 执行方法的collectionView
 @return 当前section的footerView的大小
 */
- (CGSize)referenceSizeForFooterInSection:(NSUInteger)section inCollection:(UICollectionView *)collectionView;



/**
 CollectionView 每组section的最小间隔
 
 @param section 当前section
 @return 当前section的间隔
 */
- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section;



/**
 CollectionView section中item的最小间隔
 
 @param section 当前section
 @return 当前section中item的最小间隔
 */
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;




/**
 CollectionView 当前该位置的Cell能否点击
 
 @param indexPath 当前位置
 @return true表示可以点击，false反之
 */
- (BOOL)shouldSelectItemAtIndexPath:(nullable NSIndexPath *)indexPath;



/**
 CollectionView 当前位置的Cell点击执行的操作
 
 @param indexPath 当前位置
 */
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;





/**
 当前位置的cell显示完毕执行的回调操作

 @param indexPath 当前位置
 */
- (void)didEndDisplayingCellForItemAtIndexPath:(NSIndexPath *)indexPath;





/**
 预备处理

 @param indexPaths 
 */
- (void)prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0);



/**
 取消预备处理

 @param indexPaths 
 */
- (void)cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0);

@end

NS_ASSUME_NONNULL_END
