//
//  RITLPhotoCacheManager.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPhotoCacheManager.h"


@implementation RITLPhotoCacheManager


-(instancetype)init
{
    if (self = [super init])
    {
        _numberOfSelectedPhoto = 0;
        _maxNumberOfSelectedPhoto = NSUIntegerMax;
    }
    
    return self;
}


+(instancetype)sharedInstace
{
    static RITLPhotoCacheManager * cacheManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        cacheManager = [self new];
        
    });
    
    return cacheManager;
}



-(void)dealloc
{
    [self freeAllSignal];
}



-(void)freeAllSignal
{
    if (self.assetIsPictureSignal)
    {
        free(self.assetIsPictureSignal);
        NSLog(@"signal dealloc1");
    }
    
    
    if (self.assetIsSelectedSignal)
    {
        free(self.assetIsSelectedSignal);
        NSLog(@"signal dealloc2");
    }
    
    
//    if (self.assetIsSelectedInBrowerSignal)
//    {
//        free(self.assetIsSelectedInBrowerSignal);
//        NSLog(@"signal dealloc3");
//    }
}


//void resetSignal(BOOL ** signal,NSUInteger count, BOOL value)
//{
//    if (*signal)
//    {
//        free(*signal);
//        NSLog(@"signal dealloc");
//    }
//    
//    BOOL * signalreSet = new BOOL[count];
//    
//    memset(signalreSet, value, count * sizeof(BOOL));
//    
//    signal = &signalreSet;
//}
//
//
//-(void)negation:(BOOL *)value
//{
//    //取值
//    BOOL originValue = * value;
//    
//    BOOL negationValue = !originValue;
//    
//    value = &negationValue;
//
//}

@end
