//
//  TKWebScriptMessageHandler.m
//  EattaClient
//
//  Created by YueWen on 2017/8/30.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "RITLWebScriptMessageHandler.h"

@implementation RITLWebScriptMessageHandler

- (NSString *)name
{
    if (!_name) {
        
        _name = @"onJsCallBack";
    }
    
    return _name;
}



- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //获得body体
//    NSDictionary *body = message.body;
    
//    NSLog(@"JS call back = %@",body);

}



@end
