//
//  RITLPhotoHandleManager.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2016年 YueWen. All rights reserved.
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
        
        printf("%i\n",currentStatus);
        
        if (currentStatus)
        {
            [assetsHandle addObject:assets[i]];
        }
    }
    
    return [assetsHandle copy];
}



@end
