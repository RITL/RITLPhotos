//
//  YPPhotoBottomReusableView.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPPhotoBottomReusableView : UICollectionReusableView

/// @brief simple method to set the number of asset in the assCountlabel
@property (nonatomic, assign)NSUInteger numberOfAsset;

/// @brief the custom title in the assetCountLabel
@property (nullable ,nonatomic, copy)NSString * customText;

/// @brief show the title with the number if asset,default text is 共有375张照片
@property (weak, nonatomic) IBOutlet UILabel * assetCountLabel;

@end

NS_ASSUME_NONNULL_END
