//
//  RITLPhotosViewModel.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/11/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RITLCollectionCellViewModel.h"
#import "RITLCollectionViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 选择图片的一级界面控制器的viewModel
@interface RITLPhotosViewModel : NSObject <RITLCollectionViewModel>

/// 当前显示的导航标题
@property (nonatomic, copy) NSString * navigationTitle;

/// 当前显示的组对象
@property (nonatomic, strong) PHAssetCollection * assetCollection;

/// 存储该组所有的asset对象的集合
@property (nonatomic, strong, readonly) PHFetchResult * assetResult;


@end

NS_ASSUME_NONNULL_END
