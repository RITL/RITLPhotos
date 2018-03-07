//
//  NSNumber+RITLExtension.m
//  EattaClient
//
//  Created by YueWen on 2017/11/20.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "NSNumber+RITLExtension.h"

@implementation NSNumber (RITLExtension)

- (NSString *)ritl_string
{
    return [NSString stringWithFormat:@"%@",self];
}

@end
