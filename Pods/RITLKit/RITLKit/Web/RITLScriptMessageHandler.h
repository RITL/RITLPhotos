//
//  TKScriptMessageHandler.h
//  CityBao
//
//  Created by YueWen on 16/7/20.
//  Copyright © 2016年 wangpj. All rights reserved.
//  掌中宝自定义的ScriptMesssageHandle的对象


#import <Foundation/Foundation.h>

@import WebKit;

NS_ASSUME_NONNULL_BEGIN

/// 避免直接使用WKScriptMessageHandler引起内存泄露
@interface RITLScriptMessageHandler : NSObject<WKScriptMessageHandler>

/// 当前的delegate
@property (nonatomic, weak)id <WKScriptMessageHandler> delegate;
/** 创建方法 */
- (instancetype)initWithDelegate:(id <WKScriptMessageHandler>)delegate;
/** 便利构造器 */
+ (instancetype)scriptWithDelegate:(id <WKScriptMessageHandler>)delegate;;

@end

NS_ASSUME_NONNULL_END
