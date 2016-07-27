//
//  YPPhotoGroupCell.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPPhotoGroupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/// @brief 种类类别的ImageView
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;

@end

NS_ASSUME_NONNULL_END
