//
//  UIView+RITLFrameChanged.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2017/3/27.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 边界的方法
@interface UIView (RITLFrameChanged)

@property (nonatomic, assign)CGPoint ritl_originPoint;
@property (nonatomic, assign)CGSize  ritl_size;

@property (nonatomic, assign)CGFloat ritl_originX;
@property (nonatomic, assign)CGFloat ritl_originY;

@property (nonatomic, assign)CGFloat ritl_width;
@property (nonatomic, assign)CGFloat ritl_height;

@property (nonatomic, assign)CGFloat ritl_centerX;
@property (nonatomic, assign)CGFloat ritl_centerY;

@property (nonatomic, assign, readonly)CGFloat ritl_maxX;
@property (nonatomic, assign, readonly)CGFloat ritl_maxY;

@property (nonatomic, assign, readonly)CGFloat ritl_minX;
@property (nonatomic, assign, readonly)CGFloat ritl_minY;

@property (nonatomic, assign, readonly)CGFloat ritl_midX;
@property (nonatomic, assign, readonly)CGFloat ritl_midY;

@end


@interface UIViewController (RITLFrameChanged)

@property (nonatomic, assign, readonly)CGFloat ritl_width;
@property (nonatomic, assign, readonly)CGFloat ritl_height;

@end


@interface UIScreen (RITLFrameChanged)

@property (nonatomic, assign, readonly)CGFloat ritl_width;
@property (nonatomic, assign, readonly)CGFloat ritl_height;

@end


@interface UIScrollView (RITLFrameChanged)

@property (nonatomic, assign)CGFloat ritl_contentOffSetX;
@property (nonatomic, assign)CGFloat ritl_contentOffSetY;

@property (nonatomic, assign)CGFloat ritl_contentSizeWidth;
@property (nonatomic, assign)CGFloat ritl_contentSizeHeight;

- (void)setRitl_contentOffSetX:(CGFloat)ritl_contentOffSetX animated:(BOOL)animated;
- (void)setRitl_contentOffSetY:(CGFloat)ritl_contentOffSetY animated:(BOOL)animated;

@end


NS_ASSUME_NONNULL_END
