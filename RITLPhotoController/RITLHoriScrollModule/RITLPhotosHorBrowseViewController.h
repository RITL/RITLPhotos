//
//  RITLPhotoHorBrowerViewController.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/4/27.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "RITLPhotosHorBrowseDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface RITLPhotosHorBrowseViewController : UIViewController

/// 数据源
@property (nonatomic, strong) id<RITLPhotosHorBrowseDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
