//
//  NSDate+RITLExtension.m
//  TaoKeClient
//
//  Created by YueWen on 2017/10/24.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "NSDate+RITLExtension.h"

@implementation NSDate (RITLExtension)

+ (NSString *)ritl_timeIntervalSince1970
{
    NSDate *date = [NSDate new];
    
    return [NSString stringWithFormat:@"%@",@(date.timeIntervalSince1970)];
}


+ (NSString *)ritl_uploadTime
{
    NSDate * timeDate = [NSDate date];
    
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *  locationString =[dateformatter stringFromDate:timeDate];
    
    return locationString;
}

@end
