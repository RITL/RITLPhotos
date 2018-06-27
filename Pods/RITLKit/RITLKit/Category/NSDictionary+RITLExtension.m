//
//  NSDictionary+RITLExtension.m
//  TaoKeClient
//
//  Created by YueWen on 2017/11/2.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "NSDictionary+RITLExtension.h"

@implementation NSDictionary (RITLExtension)

- (NSString *)ritl_version
{
    return [NSDictionary ritl_version];
}

+ (NSString *)ritl_version
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    return [info valueForKey:@"CFBundleShortVersionString"];
}

@end


@implementation NSDictionary (RITLTransToJson)

- (NSString *)ritl_json
{
    if (![NSJSONSerialization isValidJSONObject:self]) {
        
        return nil;
    }
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {  return nil; }
    
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}


- (NSString *)ritl_javascript_json
{
    if (![NSJSONSerialization isValidJSONObject:self]) {
        
        return nil;
    }
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    
    if (error) {  return nil; }
    
    NSString *infoString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return infoString;
}


@end
