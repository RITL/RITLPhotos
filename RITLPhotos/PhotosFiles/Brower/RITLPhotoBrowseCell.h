//
//  RITLPhotoBrowerCell.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RITLPhotoBrowseCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

/// 单击执行的block
@property (nonatomic, copy, nullable)void(^ritl_PhotoBrowerSimpleTapHandleBlock)(id);


@end

NS_ASSUME_NONNULL_END
