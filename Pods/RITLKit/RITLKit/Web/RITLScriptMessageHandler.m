//
//  TKScriptMessageHandler.m
//  CityBao
//
//  Created by YueWen on 16/7/20.
//  Copyright © 2016年 wangpj. All rights reserved.
//

#import "RITLScriptMessageHandler.h"

@implementation RITLScriptMessageHandler

-(instancetype)initWithDelegate:(id<WKScriptMessageHandler>)delegate
{
    if (self = [super init])
    {
        _delegate = delegate;
    }
    
    return self;
}



+(instancetype)scriptWithDelegate:(id<WKScriptMessageHandler>)delegate
{
    return [[RITLScriptMessageHandler alloc]initWithDelegate:delegate];
}




#pragma mark - <WKScriptMessageHandler>
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
}



@end
