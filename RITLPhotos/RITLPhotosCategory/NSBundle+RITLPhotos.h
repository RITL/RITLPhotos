//
//  NSBundle+RITLPhotos.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/6/26.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*** 2018-06-26 避免直接使用路径获取image导致的nil ***/
@interface NSBundle (RITLPhotos)

/// 确保使用自己的bundle
@property (nonatomic, strong, readonly, class)NSBundle *ritl_bundle;

/*Group*/
@property (nonatomic, strong, readonly, class)UIImage *ritl_placeholder;
@property (nonatomic, strong, readonly, class)UIImage *ritl_arrow_right;

/*Collection*/
@property (nonatomic, strong, readonly, class)UIImage *ritl_deselect;

/*Horiscroll --  Browse*/
@property (nonatomic, strong, readonly, class)UIImage *ritl_brower_selected;
@property (nonatomic, strong, readonly ,class)UIImage *ritl_browse_back;
@property (nonatomic, strong, readonly ,class)UIImage *ritl_bottomSelected;
@property (nonatomic, strong, readonly ,class)UIImage *ritl_bottomUnselected;
@property (nonatomic, strong, readonly ,class)UIImage *ritl_video_play;

@end

NS_ASSUME_NONNULL_END
