//
//  RITLPhotoBrowerCell.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 普通图片的cell
@interface RITLPhotosBrowseImageCell : UICollectionViewCell

/// 显示图片的imageView
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

/// 底部负责滚动的滚动视图
@property (strong, nonatomic, readonly) IBOutlet UIScrollView *bottomScrollView;

@end

NS_ASSUME_NONNULL_END
