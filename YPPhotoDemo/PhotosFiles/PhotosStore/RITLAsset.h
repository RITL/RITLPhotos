//
//  RITLAsset.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/22.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Photos/Photos.h>

typedef PHImageRequestOptionsDeliveryMode RITLOptionMode;

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(8_0) @interface RITLAsset : NSObject

/// @brief 默认为高清
@property (nonatomic, assign)RITLOptionMode optionMode;

@property (nonatomic, strong)PHAsset * asset;


+ (instancetype)RITLAssetWithAsset:(PHAsset *)asset OptionMode:(RITLOptionMode)optionMode;


@end

NS_ASSUME_NONNULL_END
