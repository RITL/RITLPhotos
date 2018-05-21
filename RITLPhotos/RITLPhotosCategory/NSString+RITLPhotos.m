//
//  NSString+RITLPhotos.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/8.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "NSString+RITLPhotos.h"

@implementation NSString (RITLPhotos)

+ (NSString *)timeStringWithTimeDuration:(NSTimeInterval)timeInterval
{
    NSUInteger time = (NSUInteger)timeInterval;
    
    //大于1小时
    if (time >= 60 * 60)
    {
        NSUInteger hour = time / 60 / 60;
        NSUInteger minute = time % 3600 / 60;
        NSUInteger second = time % (3600 * 60);
        
        return [NSString stringWithFormat:@"%.2lu:%.2lu:%.2lu",(unsigned long)hour,(unsigned long)minute,(unsigned long)second];
    }
    
    
    if (time >= 60)
    {
        NSUInteger mintue = time / 60;
        NSUInteger second = time % 60;
        
        return [NSString stringWithFormat:@"%.2lu:%.2lu",(unsigned long)mintue,(unsigned long)second];
    }
    
    return [NSString stringWithFormat:@"00:%.2lu",(unsigned long)time];
}

@end
