//
//  TKWebScriptMessageHandler.h
//  EattaClient
//
//  Created by YueWen on 2017/8/30.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RITLWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@import WebKit;

/// 默认的ScriptMessageHandler
@interface RITLWebScriptMessageHandler : NSObject <WKScriptMessageHandler,RITLScriptMessageHandler>
/// 注册的名字
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
