//
//  YPPhotoGroupController.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


NS_AVAILABLE_IOS(8_0) @interface YPPhotoGroupController : UITableViewController

@property (nullable, nonatomic, copy) YPPhotoDidSelectedBlockAsset photosDidSelectBlock;

@end

NS_ASSUME_NONNULL_END
