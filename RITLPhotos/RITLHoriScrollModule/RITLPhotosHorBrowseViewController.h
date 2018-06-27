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


typedef void(^RITLPhotosHorBrowseWillBack)(void);

@interface RITLPhotosHorBrowseViewController : UIViewController

/// 返回的block
@property (nonatomic, copy) RITLPhotosHorBrowseWillBack backHandler;

/// 数据源
@property (nonatomic, strong) id<RITLPhotosHorBrowseDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
