//
//  RITLPhotosBottomView.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/9.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RITLPhotosBottomView : UIView

///
@property (nonatomic, strong) UIView *contentView;
/// 预览按钮
@property (nonatomic, strong) UIButton *previewButton;
/// 原图按钮
@property (nonatomic, strong) UIButton *fullImageButton;
/// 发送按钮
@property (nonatomic, strong) UIButton *sendButton;


@end

NS_ASSUME_NONNULL_END
