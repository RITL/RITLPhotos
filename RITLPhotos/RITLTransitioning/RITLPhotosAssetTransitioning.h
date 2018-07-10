//
//  RITLPhotosAssetTransitioning.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/6/29.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RITLPhotosAssetTransitionItem : NSObject

@property (nonatomic, assign)CGRect initialFrame;//初始化frame
@property (nonatomic, assign)CGRect targetFrame;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong, nullable) UIImageView *imageView;

@end



@protocol RITLPhotosAssetTransitioning <NSObject>


- (NSArray <RITLPhotosAssetTransitionItem *>*)itemsForTransitionWithContext:(id<UIViewControllerContextTransitioning>)context;


- (CGRect)targetFrameWithTransitionItem:(RITLPhotosAssetTransitionItem *)item;


- (void)willTransitionFromController:(UIViewController *)fromController
                        toController:(UIViewController *)toController
                               items:(NSArray <RITLPhotosAssetTransitionItem *>*)items;


- (void)didTransitionFromController:(UIViewController *)fromController
                        toController:(UIViewController *)toController
                               items:(NSArray <RITLPhotosAssetTransitionItem *>*)items;

@end

NS_ASSUME_NONNULL_END
