//
//  UICollectionView+RITLIndexPathsForElements.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/9.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (RITLIndexPathsForElements)

- (NSArray<NSIndexPath *> *)indexPathsForElementsInRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
