//
//  YPPhotoBrowerCDelegate.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/8/4.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotoBrowerCell.h"
#import "YPPhotoBrowerController.h"
#import "PHObject+SupportCategory.h"

@interface YPPhotoBrowerCDelegate ()
{
    //标志第一次进入
    NSUInteger index;
}

@end


@implementation YPPhotoBrowerCDelegate


-(instancetype)initWithLinkViewController:(YPPhotoBrowerController *)viewController
{
    if (self = [super init])
    {
        _viewController = viewController;
    }
    
    return self;
}


+(instancetype)borwerDelegateWithLinkViewController:(YPPhotoBrowerController *)viewController
{
    return [[self alloc] initWithLinkViewController:viewController];
}


-(void)dealloc
{
    NSLog(@"%@ Dealloc",NSStringFromClass([self class]));
}



#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    return CGSizeMake(screenBounds.size.width + 10, screenBounds.size.height);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

-(void)scrollViewEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}



#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UICollectionView * collectionView = (UICollectionView *)scrollView;
    
    //获得偏移量
    CGFloat contentOffSet = collectionView.contentOffset.x;
    
    //计算偏移量的倍数
    NSUInteger indexSet = contentOffSet / (collectionView.bounds.size.width);
    
    //获取当前资源
    PHAsset * asset = _viewController.browerDatasource.browerAssets[indexSet];
    
    //获得当前Cell
    YPPhotoBrowerCell * cell = (YPPhotoBrowerCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexSet inSection:0]];
    
    if (![_viewController.browerDatasource.currentAsset isEqual:asset] || index == 0)
    {
        //设置当前asset
        _viewController.browerDatasource.currentAsset = asset;
        
        //设置图片
        [_viewController.browerDatasource.currentAsset representationImageWithSize:cell.frame.size complete:^(UIImage * _Nullable image, PHAsset * _Nonnull asset) {
            
                cell.imageView.image = image;

        }];
    
        //清除显示的大小
        _viewController.photoSizeLabel.text = @"";
        
        //重新加载信息
        [_viewController showHighQualityData];
        
        index++;
    }
}

#pragma mark - Action
- (void)controlAction:(UIControl *)sender
{
    //获得viewController的数据源对象
    YPPhotoBrowerDataSource * dataSource = _viewController.browerDatasource;
    
    dataSource.isHighQuality = !dataSource.isHighQuality;
    
    if (dataSource.isHighQuality)//是高清
    {
        [_viewController changeHightQualityStatus];
        [_viewController showHighQualityData];
        
        //如果含有此时的照片
        if ([dataSource.didSelectAssets containsObject:dataSource.currentAsset])//标志位进行替换
        {
            [dataSource.didSelectAssetStatus replaceObjectAtIndex:[dataSource.didSelectAssets indexOfObject:dataSource.currentAsset] withObject:[NSNumber numberWithUnsignedInteger:2]];//更新标志位
        }
        
        else//如果不含有此照片
        {
            if (!(dataSource.didSelectAssets.count >= dataSource.maxNumberOfSelectImages.unsignedIntegerValue))//没有达到选择上限
            {
                //进行添加
                [dataSource.didSelectAssets addObject:dataSource.currentAsset];
                [dataSource.didSelectAssetStatus addObject:[NSNumber numberWithUnsignedInteger:2]];
                //修改UI
                [_viewController buttonDidSelect];//选中
                [_viewController setNumbersForSelectAssets];
            }
        }
    }
    
    else//变成不是高清图
    {
        [_viewController changeDehightQualityStatus];
        //如果含有照片
        if ([dataSource.didSelectAssets containsObject:dataSource.currentAsset])
        {
            //替换标志位
            [dataSource.didSelectAssetStatus replaceObjectAtIndex:[dataSource.didSelectAssets indexOfObject:dataSource.currentAsset] withObject:[NSNumber numberWithUnsignedInteger:0]];
        }
    }
}


- (IBAction)selectButtonDidTap:(id)sender
{
    //获得数据源对象
    YPPhotoBrowerDataSource * dataSource = _viewController.browerDatasource;
    
    if ([dataSource.didSelectAssets containsObject:dataSource.currentAsset])//表示已经选过,应该取消
    {
        //移除标志位
        [dataSource.didSelectAssetStatus removeObjectAtIndex:[dataSource.didSelectAssets indexOfObject:dataSource.currentAsset]];
        //移除数据
        [dataSource.didSelectAssets removeObject:dataSource.currentAsset];
        //更新UI
        [_viewController buttonDidDeselect];
    }
    
    else//表示选择
    {
        if (dataSource.didSelectAssets.count >= dataSource.maxNumberOfSelectImages.unsignedIntegerValue)
        {
            [self alertControllerShouldPresent:dataSource.maxNumberOfSelectImages];
        }
        
        else{
            
            [dataSource.didSelectAssets addObject:dataSource.currentAsset];
            
            //如果是高清图模式
            if (dataSource.isHighQuality) [dataSource.didSelectAssetStatus addObject:[NSNumber numberWithUnsignedInteger:2]];
            else [dataSource.didSelectAssetStatus addObject:[NSNumber numberWithUnsignedInteger:0]];
            
            //updateUI
            [_viewController buttonDidSelect];
        }
        
    }
    
    [_viewController setNumbersForSelectAssets];
}


#pragma mark - UIAlertController
- (void)alertControllerShouldPresent:(NSNumber *)maxNumber
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"你最多只能选择%@张照片",@(maxNumber.unsignedIntegerValue)] message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
    
    [_viewController presentViewController:alertController animated:true completion:nil];
}





@end
