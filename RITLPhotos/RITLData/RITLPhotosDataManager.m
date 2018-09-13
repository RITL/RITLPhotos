//
//  RITLPhotosDataManager.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/16.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosDataManager.h"
#import "PHFetchResult+RITLPhotos.h"
#import <Photos/Photos.h>

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
    _count = count;
    [self didChangeValueForKey:@"count"];
}

- (void)setHightQuality:(BOOL)hightQuality
{
    _hightQuality = hightQuality;
    [self didChangeValueForKey:@"hightQuality"];
}

- (void)setDefaultIdentifers:(NSArray<NSString *> *)defaultIdentifers
{
    if (defaultIdentifers.count  == 0 || !defaultIdentifers) { return; }
    
    [self.phassetsIds addObjectsFromArray:defaultIdentifers];
    
    //追加资源对象
    [self.phassets addObjectsFromArray:[PHAsset fetchAssetsWithLocalIdentifiers:defaultIdentifers options:nil].array];
    
    self.count = self.phassetsIds.count;
}

- (BOOL)containAsset:(PHAsset *)asset
{
    return [self.assetIdentiers containsObject:asset.localIdentifier];
}

- (void)dealloc
{
    NSLog(@"[%@] is dealloc",NSStringFromClass(self.class));
}


@end

