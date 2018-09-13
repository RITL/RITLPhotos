//
//  NSArray+RITLPhotos.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/9/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (RITLPhotos)

/// 将相册组进行排序，并将'相册胶卷'放在第一位
@property (nonatomic, copy, readonly)NSArray <PHAssetCollection *> *sortRegularAblumsWithUserLibraryFirst;

@end

NS_ASSUME_NONNULL_END
