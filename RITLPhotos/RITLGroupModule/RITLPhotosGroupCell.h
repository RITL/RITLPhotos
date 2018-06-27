//
//  YPPhotoGroupCell.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 组的自定义cell
@interface RITLPhotosGroupCell : UITableViewCell

/// 显示图片的imageView
@property (strong, nonatomic) IBOutlet UIImageView * imageView;

/// 分组的名称
@property (strong, nonatomic) IBOutlet UILabel * titleLabel;

/// 
@property (strong, nonatomic) IBOutlet UIImageView * arrowImageView;

@end

NS_ASSUME_NONNULL_END
