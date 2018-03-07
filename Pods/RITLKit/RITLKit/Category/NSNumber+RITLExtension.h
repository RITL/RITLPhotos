//
//  NSNumber+RITLExtension.h
//  EattaClient
//
//  Created by YueWen on 2017/11/20.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (RITLExtension)

/// 字符串
@property (nonatomic, copy, readonly) NSString *ritl_string;

@end

NS_ASSUME_NONNULL_END
