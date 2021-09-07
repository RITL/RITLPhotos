//
//  RITLGIFImageCollectionViewCell.h
//  rabbit
//
//  Created by iOSzhang Inc on 20/8/12.
//  Copyright © 2020 jixiultd. All rights reserved.
//

#import "RITLPhotosCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface RITLGIFImageCollectionViewCell : UICollectionViewCell

/// 显示图片的imageView
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
/// 用于标示GIF
@property (nonatomic, strong) UILabel *gifLabel;
/// 底部负责滚动的滚动视图
@property (strong, nonatomic, readonly) IBOutlet UIScrollView *bottomScrollView;

@end

NS_ASSUME_NONNULL_END
