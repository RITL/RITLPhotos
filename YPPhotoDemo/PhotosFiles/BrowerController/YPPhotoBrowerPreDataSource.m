//
//  YPPhotoBrowerPreDataSource.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/9/20.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotoBrowerPreDataSource.h"
#import "YPPhotoBrowerController.h"

@implementation YPPhotoBrowerPreDataSource


-(instancetype)initWithLinkViewController:(YPPhotoBrowerController *)viewController
{
    if (self = [super init])
    {
        _viewController = viewController;
    }
    
    return self;
}


+ (instancetype)borwerPreDataSourceWithLinkViewController:(YPPhotoBrowerController *)viewController
{
    return [[self alloc] initWithLinkViewController:viewController];
}


-(void)dealloc
{
    NSLog(@"%@ Dealloc",NSStringFromClass([self class]));
}



#pragma mark - <UICollectionViewDataSourcePrefetching>

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    //what happened???????
}

- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    //what happened???????
}




@end
