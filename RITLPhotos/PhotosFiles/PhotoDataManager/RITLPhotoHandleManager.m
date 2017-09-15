//
//  RITLPhotoHandleManager.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoHandleManager.h"

@implementation RITLPhotoHandleManager

+(NSArray<PHAsset *> *)assetForAssets:(NSArray<PHAsset *> *)assets status:(BOOL *)status
{
    NSMutableArray <PHAsset *> * assetsHandle = [NSMutableArray arrayWithCapacity:assets.count];
    
    for (NSUInteger i = 0; i < assets.count; i++)
    {
        //获得当前的状态
        BOOL currentStatus = status[i];
        
        if (currentStatus)
        {
            [assetsHandle addObject:assets[i]];
        }
    }
    
    return [assetsHandle copy];
}

@end

@implementation RITLPhotoHandleManager (RITLDurationTime)

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
