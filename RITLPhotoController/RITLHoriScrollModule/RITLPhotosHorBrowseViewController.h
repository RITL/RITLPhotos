//
//  RITLPhotoHorBrowerViewController.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/4/27.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

/// 
@interface RITLPhotosHorBrowseViewController : UIViewController

///当前预览组的对象
@property (nonatomic, strong)PHAssetCollection *collection;
///当前点击进入的资源对象
@property (nonatomic, strong)PHAsset *asset;

@end

NS_ASSUME_NONNULL_END
