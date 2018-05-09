//
//  RITLDictionaryProxy.h
//  EattaClient
//
//  Created by YueWen on 2017/9/20.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RITLEnity

/// 读出真正的数据data
@property (nonatomic, copy, nullable, readonly) NSDictionary *proxy_real_enity;

@end



/// 进行model化
extern id RITLEnityCreateWithData(NSDictionary *data);


NS_ASSUME_NONNULL_END
