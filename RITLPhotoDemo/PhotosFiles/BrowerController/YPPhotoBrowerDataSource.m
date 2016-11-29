//
//  YPPhotoBrowerDataSource.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/8/4.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotoBrowerCell.h"
#import "PHObject+SupportCategory.h"
#import "YPPhotoBrowerController.h"
#import "YPPhotoBrowerCDelegate.h"

@implementation YPPhotoBrowerDataSource

-(instancetype)initWithCurrentAsset:(PHAsset *)currentAsset BrowerAssets:(NSArray<PHAsset *> *)browerAssets selectAssets:(NSMutableArray<PHAsset *> *)selectAssets status:(NSMutableArray <NSNumber *> *)didSelectAssetStatus browerViewController:(YPPhotoBrowerController *)viewController
{
    if (self = [super init])
    {
        _currentAsset = currentAsset;
        _browerAssets = browerAssets;
        _didSelectAssets = selectAssets;
        _didSelectAssetStatus = didSelectAssetStatus;
        _viewController = viewController;
    }
    
    return self;
}


+(instancetype)browerDataSourceWithCurrentAsset:(PHAsset *)currentAsset BrowerAssets:(NSArray<PHAsset *> *)browerAssets selectAssets:(NSMutableArray<PHAsset *> *)selectAssets status:(NSMutableArray <NSNumber *> *)didSelectAssetStatus browerViewController:(YPPhotoBrowerController *)viewController
{
    return [[self alloc] initWithCurrentAsset:currentAsset BrowerAssets:browerAssets selectAssets:selectAssets status:didSelectAssetStatus browerViewController:viewController];
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _browerAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPPhotoBrowerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YPPhotoBrowerCell class]) forIndexPath:indexPath];
    
    //config the cell
    [_browerAssets[indexPath.item] representationImageWithSize:CGSizeMake(60, 60) complete:^(UIImage * _Nullable image, PHAsset * _Nonnull asset) {
        
        cell.imageView.image = image;
        
    }];
    
    
    //更新标志位
    if ([_didSelectAssets containsObject:_browerAssets[indexPath.item]]) [_viewController buttonDidSelect];
    
    else [_viewController buttonDidDeselect];
    
    return cell;
}

-(void)dealloc
{
    NSLog(@"%@ Dealloc",NSStringFromClass([self class]));
}


@end
