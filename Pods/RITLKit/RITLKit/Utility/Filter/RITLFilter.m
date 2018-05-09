//
//  RITLFilter.m
//  NongWanCloud
//
//  Created by YueWen on 2018/2/5.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLFilter.h"


@implementation NSString (RITLFilter)

- (BOOL)ritl_predicatedMatches:(NSString *)predicated
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predicated];
    
    return [predicate evaluateWithObject:self];
}

@end

@implementation RITLFilter


+ (RITLFilterHandler)none
{
    return ^BOOL(NSString *text){
        
        return true;
        
    };
}


+ (RITLFilterHandler)phone
{
    return ^BOOL(NSString *text){
      
        return [text ritl_predicatedMatches:@"0?(13|14|15|17|18|19)[0-9]{9}"];
    };
}


+ (RITLFilterHandler)mail
{
    return ^BOOL(NSString *text){
        
        return [text ritl_predicatedMatches:@"\\w[-\\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\\.)+[A-Za-z]{2,14}"];
        
    };
}


+ (RITLFilterHandler)lengthFilterWithMax:(NSInteger)maxLength
{
    return ^BOOL(NSString *text){
      
        return text.length <= maxLength;
    };
}


+ (RITLFilterHandler)lengthFilterWithMin:(NSInteger)minLength
{
    return ^BOOL(NSString *text){
        
        return text.length >= minLength;
    };
}


+ (RITLFilterHandler)lengthFilterWithMin:(NSInteger)minLength Max:(NSInteger)maxLength
{
    return ^BOOL(NSString *text){
        
        return text.length >= minLength && text.length <= maxLength;
    };
}


@end
