//
//  TKOrderListProxy.m
//  EattaClient
//
//  Created by YueWen on 2017/9/20.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "RITLDictionaryProxy.h"
#import <Foundation/Foundation.h>


@interface NSDictionary (TKDictionaryProxy)

- (NSDictionary *)proxy_real_enity;

@end


@implementation NSDictionary(TKDictionaryProxy)

- (NSDictionary *)proxy_real_enity
{
    return  self.mutableCopy;
}

@end




/// 使用字典模拟进行的去Model化
@interface RITLDictionaryProxy : NSProxy

- (instancetype)initWithData:(NSDictionary *)data;

@end



@interface RITLDictionaryProxy ()

@property (nonatomic, strong)NSMutableDictionary *innerDictionary;

@end

@implementation RITLDictionaryProxy


-(instancetype)initWithData:(NSDictionary *)data
{
    if (!data) {
        
        return nil;
    }
    
    if ([data isKindOfClass:NSDictionary.class]) {
       
        self.innerDictionary = [NSMutableDictionary dictionaryWithDictionary:data];
    }

    return self;
}



- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    SEL changedSelector = sel;
    
    //如果读取自身实体
    if ([NSStringFromSelector(sel) isEqualToString:@"proxy_real_enity"]) {
        
        sel = @selector(proxy_real_enity);
    }
    
    else if ([self propertyNameScanFromGetterSelector:sel])
    {
        changedSelector = @selector(objectForKey:);
    }
    
    else if ([self propertyNameScanFromSetterSelector:sel])
    {
        changedSelector = @selector(setObject:forKey:);
    }
    
    return [[self.innerDictionary class] instanceMethodSignatureForSelector:changedSelector];
}




- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *propertyName = nil;
  
    ///copy
    propertyName = NSStringFromSelector(invocation.selector);
    
    if ([propertyName isEqualToString:@"proxy_real_enity"]) {
        
        invocation.selector = @selector(proxy_real_enity);
        [invocation invokeWithTarget:self.innerDictionary];
        return;
    }
    
    
    // getter
    propertyName = [self propertyNameScanFromGetterSelector:invocation.selector];
    
    if (propertyName)
    {
        invocation.selector = @selector(objectForKey:);
        [invocation setArgument:&propertyName atIndex:2]; // self, _cmd, key
        [invocation invokeWithTarget:self.innerDictionary];
        return;
    }
    
    
    // setter
    propertyName = [self propertyNameScanFromSetterSelector:invocation.selector];
    
    if (propertyName)
    {
        invocation.selector = @selector(setObject:forKey:);
        [invocation setArgument:&propertyName atIndex:3]; // self, _cmd, obj, key
        [invocation invokeWithTarget:self.innerDictionary];
        return;
    }
    

    
    [super forwardInvocation:invocation];
}




- (NSString *)propertyNameScanFromGetterSelector:(SEL)selector
{
    NSString *selectorName = NSStringFromSelector(selector);
    
    NSUInteger parameterCount = [[selectorName componentsSeparatedByString:@":"] count] - 1;
    
    if (parameterCount == 0)
    {
        return selectorName;
    }
    
    return nil;
}



- (NSString *)propertyNameScanFromSetterSelector:(SEL)selector
{
    NSString *selectorName = NSStringFromSelector(selector);
    NSUInteger parameterCount = [[selectorName componentsSeparatedByString:@":"] count] - 1;
    
    if ([selectorName hasPrefix:@"set"] && parameterCount == 1)
    {
        NSUInteger firstColonLocation = [selectorName rangeOfString:@":"].location;
        return [selectorName substringWithRange:NSMakeRange(3, firstColonLocation - 3)].lowercaseString;
    }
    
    return nil;
}

- (NSString *)debugDescription
{
    return [self.innerDictionary debugDescription];
}

@end



id RITLEnityCreateWithData(NSDictionary *data)
{
    return [[RITLDictionaryProxy alloc]initWithData:data];
}



 
