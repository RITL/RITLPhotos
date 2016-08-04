//
//  YPPhotoStore.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotoStore.h"
#import "YPPhotoStoreConfiguraion.h"
#import "PHObject+SupportCategory.h"

typedef void(^PHAssetCollectionBlock)(NSArray<PHAssetCollection *> * groups);

@interface YPPhotoStore ()

@property (nonatomic, strong) PHPhotoLibrary * photoLibaray;

@property (nonatomic, strong) PHFetchResult * topLevelResult;

//记录默认全部组的block,适当的进行回调
@property (nonatomic, copy) void(^defaultAllPhotosGroupBlock)(NSArray<PHAssetCollection *> * _Nonnull topLevelArray, PHFetchResult * _Nonnull result);

@end


@implementation YPPhotoStore

-(instancetype)init
{
    if (self = [super init])
    {
        self.photoLibaray = [PHPhotoLibrary sharedPhotoLibrary];
        [self.photoLibaray registerChangeObserver:self];
        
        _config = [[YPPhotoStoreConfiguraion alloc]init];
    }
    
    return self;
}

-(instancetype)initWithConfiguration:(YPPhotoStoreConfiguraion *)configuration
{
    if (self = [self init])
    {
        _config = configuration;
    }
    
    return self;
}

+(instancetype)storeWithConfiguration:(YPPhotoStoreConfiguraion *)configuration
{
    return [[self alloc] initWithConfiguration:configuration];
}


-(void)dealloc
{
    [self.photoLibaray unregisterChangeObserver:self];
}




#pragma mark - public function

- (void)fetchPhotosGroup:(void (^)(NSArray<PHAssetCollection *> * _Nonnull))groups
{
    __weak typeof(self) weakSelf = self;
    
    [self fetchBasePhotosGroup:^(PHFetchResult * _Nullable result) {
       
        if (result == nil) return;
        
        [result transToArrayComplete:^(NSArray<PHAssetCollection *> * _Nonnull group, PHFetchResult * _Nonnull result) {
            
            groups([weakSelf handleAssetCollection:group]);
            
        }];
    }];

}



-(void)fetchDefaultPhotosGroup:(void (^)(NSArray<PHAssetCollection *> * _Nonnull))groups
{
    __weak typeof(self) weakSelf = self;
    
    [self fetchBasePhotosGroup:^(PHFetchResult * _Nullable result) {
       
        if (result == nil) return;
        
        [weakSelf preparationWithFetchResult:result complete:^(NSArray<PHAssetCollection *> * _Nonnull defalutGroup) {
           
            groups([weakSelf handleAssetCollection:defalutGroup]);
            
        }];
        
    }];
}



-(void)fetchDefaultAllPhotosGroup:(void (^)(NSArray<PHAssetCollection *> * _Nonnull,PHFetchResult * _Nonnull))groups
{
    __block NSMutableArray <PHAssetCollection *> * defaultAllGroups = [NSMutableArray arrayWithCapacity:0];
    
    [self fetchDefaultPhotosGroup:^(NSArray<PHAssetCollection *> * _Nonnull defaultGroups) {
       
        [defaultAllGroups addObjectsFromArray:defaultGroups];
        
        //遍历自定义的组
        [[PHCollection fetchTopLevelUserCollectionsWithOptions:[[PHFetchOptions alloc]init]] transToArrayComplete:^(NSArray<PHAssetCollection *> * _Nonnull topLevelArray, PHFetchResult * _Nonnull result) {
            
            [defaultAllGroups addObjectsFromArray:topLevelArray];
            
            //callBack with block
            groups([NSArray arrayWithArray:defaultAllGroups],result);
            
            defaultAllGroups = nil;
            
        }];
        
    }];
    
}

#pragma mark - 处理照片

/// @brief 将configuration属性中的类别进行筛选
-(void)preparationWithFetchResult:(PHFetchResult<PHAssetCollection *> *)fetchResult complete:(void (^)(NSArray<PHAssetCollection *> * _Nonnull))groups
{
    NSMutableArray <PHAssetCollection *> * preparationCollections = [NSMutableArray arrayWithCapacity:0];
    
    
    [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([_config.groupNamesConfig containsObject:obj.localizedTitle])
        {
            [preparationCollections addObject:obj];
        }
        
        if (idx == fetchResult.count - 1)
        {
            groups([NSArray arrayWithArray:preparationCollections]);
        }
        
    }];
    
}


#pragma mark - 相片
-(PHFetchResult *)fetchPhotos:(PHAssetCollection *)group
{
    return [PHAsset fetchAssetsInAssetCollection:group options:[[PHFetchOptions alloc]init]];
}







#pragma mark - private function

/** 将assetCollections 中的胶卷相册排到第一位 */
-(NSArray <PHAssetCollection *> *)handleAssetCollection:(NSArray <PHCollection *> *)assetCollections
{
    NSMutableArray <PHAssetCollection *> * collections = [NSMutableArray arrayWithArray:assetCollections];
    
    //针对部分顺序问题将胶卷相册拍到第一位
    for (NSUInteger i = 0 ;i < collections.count; i++)
    {
        //获取当前的相册组
        PHAssetCollection * collection = collections[i];
        
        if ([collection.localizedTitle isEqualToString:NSLocalizedString(ConfigurationCameraRoll, @"")])
        {
            //移除该相册
            [collections removeObject:collection];
            
            //添加至第一位
            [collections insertObject:collection atIndex:0];
            
            break;
        }
    }
    
    return [collections mutableCopy];
}


/** 获取最基本的智能分组 */
-(void)fetchBasePhotosGroup:(void(^)( PHFetchResult * _Nullable  result))completeBlock
{
    //获得智能分组
    PHFetchResult * smartGroups = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
 
    //进行检测
    [self storeCheckAuthorizationStatusAllow:^{//获得准许
        
        completeBlock(smartGroups);
        
    } denied:^{}];//无操作
}


#pragma mark - 权限检测
- (void)storeCheckAuthorizationStatusAllow:(void(^)(void))allowBlock denied:(void(^)(void))deniedBlock
{
    //获取权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];

    //switch 判定
    switch (status)
    {
        //准许
        case PHAuthorizationStatusAuthorized: allowBlock(); break;
            
        //待获取
        case PHAuthorizationStatusNotDetermined:
        {
           [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
              
               if (status == PHAuthorizationStatusAuthorized)//允许，进行回调
               {
                   allowBlock();
               }
               else
               {
                  deniedBlock();
               }
               
           }];
        }
        break;
            
        //不允许,进行无权限回调
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted: deniedBlock(); break;
    }
}



#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    if (_photoStoreHasChanged != nil)
    {
        _photoStoreHasChanged(changeInstance);
    }
}

@end




