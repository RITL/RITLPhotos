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
    self.numberOfAssetIsSelectedSignal = count;

    NSMutableArray <NSNumber *> *results = [NSMutableArray arrayWithCapacity:count];
    
    //重新初始化
    for (NSInteger i = 0; i < count; i++) {
        
        [results addObject:@(false)];
    }
    
    self.assetIsSelectedSignal = results.mutableCopy;
    
//    //初始化
//    self.assetIsSelectedSignal = new BOOL[count];
//
//    memset(self.assetIsSelectedSignal,false,count * sizeof(BOOL));
}


-(void)allocInitAssetIsPictureSignal:(NSUInteger)count
{
    
    NSMutableArray <NSNumber *> *results = [NSMutableArray arrayWithCapacity:count];
    
    //重新初始化
    for (NSInteger i = 0; i < count; i++) {
        
        [results addObject:@(false)];
    }
    
    self.assetIsPictureSignal = results.mutableCopy;

    
//    self.assetIsPictureSignal = new BOOL[count];
    
//    memset(self.assetIsPictureSignal,false,count * sizeof(BOOL));
}



-(BOOL)changeAssetIsSelectedSignal:(NSUInteger)index
{
    if (index > self.numberOfAssetIsSelectedSignal)
    {
        return false;
    }
    
    self.assetIsSelectedSignal[index] = @(!([self.assetIsSelectedSignal[index] boolValue]));
    
    printf("选中状态:%d\n",self.assetIsSelectedSignal[index].boolValue);
    
    return true;
}



-(void)dealloc
{

}



-(void)freeAllSignal
{
    NSAssert(false, @"方法不安全，禁止使用");
}

-(void)resetMaxSelectedCount
{
    _maxNumberOfSelectedPhoto = NSUIntegerMax;
}


- (void)freeSignalIngnoreMax
{
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
    [self.assetIsPictureSignal removeAllObjects];
    self.assetIsPictureSignal = nil;
    
    [self.assetIsSelectedSignal removeAllObjects];
    self.assetIsSelectedSignal = nil;
    
    _numberOfSelectedPhoto = 0;
    _numberOfAssetIsSelectedSignal = 0;
    _isHightQuarity = false;
}



@end
