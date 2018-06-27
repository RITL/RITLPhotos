//
//  UICollectionView+RITLIndexPathsForElements.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/9.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "UICollectionView+RITLIndexPathsForElements.h"
#import <RITLKit/RITLKit.h>

@implementation UICollectionView (RITLIndexPathsForElements)

- (NSArray<NSIndexPath *> *)indexPathsForElementsInRect:(CGRect)rect
{
    NSArray <UICollectionViewLayoutAttributes*> *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    
    return [allLayoutAttributes ritl_map:^id _Nonnull(UICollectionViewLayoutAttributes * _Nonnull attribute) {
        
        return attribute.indexPath;
    }];
}

@end
