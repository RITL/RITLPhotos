//
//  RITLPhotoCacheManager.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 负责缓存选择图片对象的管理者
@interface RITLPhotoCacheManager : NSObject

/// 最大允许选择的图片数目，默认为MAX
@property (nonatomic, assign) NSUInteger maxNumberOfSelectedPhoto;

/// 记录当前选择的数量
@property (nonatomic, assign) NSUInteger numberOfSelectedPhoto;

/// 资源是否为图片的标志位
@property (nonatomic, assign) BOOL * assetIsPictureSignal;

/// 资源是否被选中的标志位
@property (nonatomic, assign) BOOL * assetIsSelectedSignal;


/// 获得单例对象
+ (instancetype)sharedInstace;

/// 释放所有的信号资源
- (void)freeAllSignal;

/// 重置初始化信号标志位
//void resetSignal(BOOL ** signal,NSUInteger count, BOOL value);


/// 取反
//void negation(BOOL * value);

@end

NS_ASSUME_NONNULL_END
