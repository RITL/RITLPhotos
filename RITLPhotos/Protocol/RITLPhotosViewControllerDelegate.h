//
//  RITLPhotosViewControllerDelegate.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/18.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;

static NSString *const PhotosControllerDidDismissNotificationName = @"PhotosControllerDidDismissNotification";


@protocol RITLPhotosViewControllerDelegate <NSObject>

@optional

/**
 即将消失的回调

 @param viewController RITLPhotosViewController
 */
- (void)photosViewControllerWillDismiss:(UIViewController *)viewController;


/**
 选中图片以及视频等资源的本地identifer
 可用于设置默认选好的资源

 @param viewController RITLPhotosViewController
 @param identifiers 选中资源的本地标志位
 */
- (void)photosViewController:(UIViewController *)viewController
            assetIdentifiers:(NSArray <NSString *> *)identifiers;


/**
 选中图片以及视频等资源的默认缩略图
 根据thumbnailSize设置所得，如果thumbnailSize为.Zero,则不进行回调
 与是否原图无关
 
 @param viewController RITLPhotosViewController
 @param thumbnailImages 选中资源的缩略图
 @param infos 选中图片的缩略图信息
 */
- (void)photosViewController:(UIViewController *)viewController
             thumbnailImages:(NSArray <UIImage *> *)thumbnailImages
                       infos:(NSArray <NSDictionary *> *)infos;


/**
 选中图片以及视频等资源的原比例图片
 适用于不使用缩略图，或者展示高清图片
 与是否原图无关

 @param viewController RITLPhotosViewController
 @param images 选中资源的原比例图
 @param infos 选中图片的原比例图信息
 */
- (void)photosViewController:(UIViewController *)viewController
                      images:(NSArray <UIImage *> *)images
                       infos:(NSArray <NSDictionary *> *)infos;

/**
 选中图片以及视频等资源的数据
 根据是否选中原图所得
 如果为原图，则返回原图大小的数据
 如果不是原图，则返回原始比例的数据
 注: 不会返回thumbnailImages的数据大小
 
 @param viewController RITLPhotosViewController
 @param datas 选中资源的数据
 */
- (void)photosViewController:(UIViewController *)viewController
             datas:(NSArray <NSData *> *)datas;

/**
 选中图片以及视频等资源的源资源对象
 如果需要使用源资源对象进行相关操作，请实现该方法
 
 @param viewController RITLPhotosViewController
 @param assets 选中的源资源
 */
- (void)photosViewController:(UIViewController *)viewController
                       assets:(NSArray <PHAsset *> *)assets;




#pragma mark - Deprecated


/**
 选中图片以及视频等资源的原比例图片
 适用于不使用缩略图，或者展示高清图片
 与是否原图无关
 
 @param viewController RITLPhotosViewController
 @param images 选中资源的原比例图
 */
- (void)photosViewController:(UIViewController *)viewController
                      images:(NSArray <UIImage *> *)images __deprecated_msg("Use photosViewController:images:infos instead.");



/**
 选中图片以及视频等资源的默认缩略图
 根据thumbnailSize设置所得，如果thumbnailSize为.Zero,则不进行回调
 与是否原图无关
 
 @param viewController RITLPhotosViewController
 @param thumbnailImages 选中资源的缩略图
 */
- (void)photosViewController:(UIViewController *)viewController
             thumbnailImages:(NSArray <UIImage *> *)thumbnailImages __deprecated_msg("Use photosViewController:thumbnailImages:infos instead.");



@end

NS_ASSUME_NONNULL_END
