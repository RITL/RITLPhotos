//
//  RITLPhotosDataManager.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/16.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosDataManager.h"
#import <Photos/Photos.h>
//
//@interface RITLPhotosResult<__covariant ObjectType>: NSObject
//
///// 数量
//@property (nonatomic, assign, readonly)NSInteger count;
//
///// 存储数量的数组
//@property (nonatomic, strong) NSMutableArray <ObjectType>*results;
//
///// 支持KVO的方法
//- (void)addObject:(ObjectType)anObject;
//- (void)removeObjectAtIndex:(NSUInteger)index;
//- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
//- (void)removeAllObjects;
//
//@end
//
//@implementation RITLPhotosResult
//
//- (instancetype)init
//{
//    if (self = [super init]) {
//        self.results = [NSMutableArray arrayWithCapacity:10];
//    }
//    return self;
//}
//
//
//+ (instancetype)resultWithCapacity:(NSUInteger)numItems
//{
//    RITLPhotosResult *result = [[self alloc]init];
//    result.results = [NSMutableArray arrayWithCapacity:numItems];
//    return result;
//}
//
//
//- (NSInteger)count
//{
//    return self.results.count;
//}
//
//- (void)addObject:(id)anObject
//{
//    [self.results addObject:anObject];
//    [self didChangeValueForKey:@"count"];
//}
//
//
//- (void)removeObjectAtIndex:(NSUInteger)index
//{
//    [self.results removeObjectAtIndex:index];
//    [self didChangeValueForKey:@"count"];
//}
//
//- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2
//{
//    [self.results exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
//    [self didChangeValueForKey:@"count"];
//}
//
//- (void)removeAllObjects
//{
//    [self.results removeAllObjects];
//    [self didChangeValueForKey:@"count"];
//}
//
//@end



@interface RITLPhotosDataManager ()

/// 选择资源的数组
@property (nonatomic, strong, readwrite) NSMutableArray <PHAsset *> *phassets;
@property (nonatomic, strong, readwrite) NSMutableArray <NSString *> *phassetsIds;
@property (nonatomic, assign, readwrite) NSInteger count;

@end

@implementation RITLPhotosDataManager

- (instancetype)init
{
    if (self = [super init]) {
        
        self.phassets = [NSMutableArray arrayWithCapacity:10];
        self.phassetsIds = [NSMutableArray arrayWithCapacity:10];
        self.count = 0;
    }
    return self;
}


+ (instancetype)sharedInstance
{
    static __weak RITLPhotosDataManager *instance;
    RITLPhotosDataManager *strongInstance = instance;
    @synchronized(self){
        if (strongInstance == nil) {
            strongInstance = self.new;
            instance = strongInstance;
        }
    }
    return strongInstance;
}


- (void)addPHAsset:(PHAsset *)asset
{
    [self.phassets addObject:asset];
    [self.phassetsIds addObject:asset.localIdentifier];
    self.count = self.phassetsIds.count;
}

- (void)removePHAsset:(PHAsset *)asset
{
    [self.phassets removeObject:asset];
    [self.phassetsIds removeObject:asset.localIdentifier];
    self.count = self.phassetsIds.count;
}

- (void)removePHAssetAtIndex:(NSUInteger)index
{
    [self.phassets removeObjectAtIndex:index];
    [self.phassetsIds removeObjectAtIndex:index];
    self.count = self.phassetsIds.count;
}

- (void)exchangePHAssetAtIndex:(NSUInteger)idx1 withPHAssetAtIndex:(NSUInteger)idx2
{
    [self.phassets exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    [self.phassetsIds exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)removeAllPHAssets
{
    [self.phassets removeAllObjects];
    [self.phassetsIds removeAllObjects];
    self.count = self.phassetsIds.count;
}

- (NSNumber *)addOrRemoveAsset:(PHAsset *)asset
{
    BOOL isSelected = [self.assetIdentiers containsObject:asset.localIdentifier];
    
    if (isSelected) {//如果选中了，进行删除
        
        [self removePHAsset:asset]; return @(-1);
    }
        
    [self addPHAsset:asset];
    return @(self.count);
}

- (NSArray<PHAsset *> *)assets
{
    return self.phassets;
}

- (NSArray<NSString *> *)assetIdentiers
{
    return self.phassetsIds;
}


- (void)setCount:(NSInteger)count
{
//    [self willChangeValueForKey:@"count"];
    _count = count;
    [self didChangeValueForKey:@"count"];
}

@end

