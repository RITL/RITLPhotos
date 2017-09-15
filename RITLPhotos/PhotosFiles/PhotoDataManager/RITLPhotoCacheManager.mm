//
//  RITLPhotoCacheManager.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoCacheManager.h"

@interface RITLPhotoCacheManager ()

/// 是否选择的长度
@property (nonatomic, assign)unsigned long numberOfAssetIsSelectedSignal;

@end

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



-(void)allocInitAssetIsSelectedSignal:(NSUInteger)count
{
//    if (self.assetIsSelectedSignal)
//    {
//        free(self.assetIsSelectedSignal);
//    }
    
    self.numberOfAssetIsSelectedSignal = count;

    //初始化
    self.assetIsSelectedSignal = new BOOL[count];
    
    memset(self.assetIsSelectedSignal,false,count * sizeof(BOOL));
}


-(void)allocInitAssetIsPictureSignal:(NSUInteger)count
{
//    if (self.assetIsPictureSignal)
//    {
//        free(self.assetIsPictureSignal);
//    }
    
    self.assetIsPictureSignal = new BOOL[count];
    
    memset(self.assetIsPictureSignal,false,count * sizeof(BOOL));
}



-(BOOL)changeAssetIsSelectedSignal:(NSUInteger)index
{
    if (index > self.numberOfAssetIsSelectedSignal)
    {
        return false;
    }
    
    self.assetIsSelectedSignal[index] = !self.assetIsSelectedSignal[index];
    
    printf("选中状态:%d\n",self.assetIsSelectedSignal[index]);
    
    return true;
}



-(void)dealloc
{

}



-(void)freeAllSignal
{
    NSAssert(false, @"方法不安全，禁止使用");
    
//    if (self.assetIsPictureSignal)
//    {
//        free(self.assetIsPictureSignal);
//    }
//    
//    if (self.assetIsSelectedSignal)
//    {
//        free(self.assetIsSelectedSignal);
//    }
//    
//    _numberOfSelectedPhoto = 0;
//    [self freeSignalIngnoreMax];
   //    _numberOfAssetIsSelectedSignal = 0;
//    _isHightQuarity = false;
}

-(void)resetMaxSelectedCount
{
    _maxNumberOfSelectedPhoto = NSUIntegerMax;
}


- (void)freeSignalIngnoreMax
{
    if (self.assetIsPictureSignal)
    {
        free(self.assetIsPictureSignal);
    }
    
    if (self.assetIsSelectedSignal)
    {
        free(self.assetIsSelectedSignal);
    }
    
    _numberOfSelectedPhoto = 0;
    _numberOfAssetIsSelectedSignal = 0;
    _isHightQuarity = false;
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
