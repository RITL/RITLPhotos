//
//  YPPhotoStore.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoStore.h"
#import "RITLPhotoStoreConfiguraion.h"

#import "PHImageRequestOptions+RITLPhotoRepresentation.h"
#import "PHFetchResult+RITLPhotoRepresentation.h"

typedef void(^PHAssetCollectionBlock)(NSArray<PHAssetCollection *> * groups);

@interface RITLPhotoStore ()

@property (nonatomic, strong) PHPhotoLibrary * photoLibaray;

@property (nonatomic, strong) PHFetchResult * topLevelResult;

//记录默认全部组的block,适当的进行回调
@property (nonatomic, copy) void(^defaultAllPhotosGroupBlock)(NSArray<PHAssetCollection *> * _Nonnull topLevelArray, PHFetchResult * _Nonnull result);

@end


@implementation RITLPhotoStore

-(instancetype)init
{
    if (self = [super init])
    {
        self.photoLibaray = [PHPhotoLibrary sharedPhotoLibrary];
        [self.photoLibaray registerChangeObserver:self];
        
        _config = [[RITLPhotoStoreConfiguraion alloc]init];
    }
    
    return self;
}

-(instancetype)initWithConfiguration:(RITLPhotoStoreConfiguraion *)configuration
{
    if (self = [self init])
    {
        _config = configuration;
    }
    
    return self;
}

+(instancetype)storeWithConfiguration:(RITLPhotoStoreConfiguraion *)configuration
{
    return [[self alloc] initWithConfiguration:configuration];
}


-(void)dealloc
{
    [self.photoLibaray unregisterChangeObserver:self];
    
#ifdef RITLDebug
    NSLog(@"%@ Dealloc",NSStringFromClass([self class]));
#endif
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


+(PHFetchResult *)fetchPhotos:(PHAssetCollection *)group
{
    return [PHAsset fetchAssetsInAssetCollection:group options:[PHFetchOptions new]];
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
        
        if ([collection.localizedTitle isEqualToString:NSLocalizedString(ConfigurationCameraRoll, @"")] || [collection.localizedTitle isEqualToString:NSLocalizedString(ConfigurationAllPhotos, @"")])
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
    //进行检测
    [self storeCheckAuthorizationStatusAllow:^{//获得准许
        
        //获得智能分组
        PHFetchResult * smartGroups = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        
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

@implementation RITLPhotoStore (Group)

-(void)addCustomGroupWithTitle:(NSString *)title completionHandler:(void (^)(void))successBlock failture:(void (^)(NSString * _Nonnull))failtureBlock
{
    [self.photoLibaray performChanges:^{
        
        //执行创建请求
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        
    }completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success == true)
        {
            successBlock();return ;
        }
        
        failtureBlock(error.localizedDescription);
        
    }];
}



-(void)addCustomGroupWithTitle:(NSString *)title assets:(NSArray<PHAsset *> *)assets completionHandler:(void (^)(void))successBlock failture:(void (^)(NSString * _Nonnull))failtureBlock
{
    [self.photoLibaray performChanges:^{
        
        //创建一个请求
        PHAssetCollectionChangeRequest * addRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        
        //添加资源
        [addRequest addAssets:assets];
        
    }completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success == true)
        {
            successBlock();return;
        }
        
        failtureBlock(error.localizedDescription);
        
    }];
}


-(void)checkGroupExist:(NSString *)title result:(nonnull void (^)(BOOL, PHAssetCollection * _Nullable))resultBlock
{
    //获得当前所有的Top相册
    [[PHCollection fetchTopLevelUserCollectionsWithOptions:[[PHFetchOptions alloc]init]] transToArrayComplete:^(NSArray<PHAssetCollection *> * _Nonnull topLevelArray, PHFetchResult * _Nonnull result) {
        
        BOOL isExist = false;
        PHAssetCollection * isExistCollection = nil;
        
        //开始遍历
        for (PHAssetCollection * collection in topLevelArray)
        {
            if ([collection.localizedTitle isEqualToString:title])
            {
                isExist = true;
                isExistCollection = collection;
                break;
            }
        }
        
        resultBlock(isExist,isExistCollection);
        
    }];
}


@end



@implementation RITLPhotoStore (Asset)

-(void)addCustomAsset:(UIImage *)image collection:(PHAssetCollection *)collection completionHandler:(void (^)(void))successBlock failture:(void (^)(NSString * _Nonnull))failtureBlock
{
    //执行变化请求
    [self.photoLibaray performChanges:^{
        
        //判断组是否允许操作
        if([collection canPerformEditOperation:PHCollectionEditOperationAddContent])
        {
            //创建资源变化对象
            PHAssetChangeRequest * assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            
            //创建组的变化
            PHAssetCollectionChangeRequest * groupChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
            
            [groupChangeRequest addAssets:@[assetChangeRequest.placeholderForCreatedAsset]];
            
        }
        
    }completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success == true)
        {
            successBlock();return;
        }
        
        failtureBlock(error.localizedDescription);
        
    }];
}


-(void)addCustomAssetPath:(NSString *)imagePath collection:(PHAssetCollection *)collection completionHandler:(void (^)(void))successBlock failture:(void (^)(NSString * _Nonnull))failtureBlock
{
    //获得image
    UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
    
    [self addCustomAsset:image collection:collection completionHandler:^{
        
        successBlock();
        
    } failture:^(NSString * _Nonnull error) {
        
        failtureBlock(error);
    }];
}

@end







#pragma mark - Deprecated


@implementation YPPhotoStoreHandleClass

+(void)imagesWithAssets:(NSArray<PHAsset *> *)assets status:(NSArray<NSNumber *> *)status Size:(CGSize)size complete:(nonnull void (^)(NSArray<UIImage *> * _Nonnull))imagesBlock
{
    __block NSMutableArray <UIImage *> * images = [NSMutableArray arrayWithCapacity:assets.count];
    
    for (NSUInteger i = 0; i < assets.count; i++)
    {
        //获取资源
        PHAsset * asset = assets[i];
    
        //获取图片类型
        PHImageRequestOptionsDeliveryMode mode = status[i].integerValue;
        
        PHImageRequestOptions * option = [PHImageRequestOptions imageRequestOptionsWithDeliveryMode:mode];
        option.synchronous = true;
        
        //请求图片
        [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            [images addObject:result];
            
            if (images.count == assets.count)//表示已经添加完毕
            {
                //回调
                imagesBlock([images mutableCopy]);
                
                images = nil;
            }
        }];
    }

}

+(void)dataWithAssets:(NSArray<PHAsset *> *)assets status:(NSArray<NSNumber *> *)status complete:(void (^)(NSArray<NSData *> * _Nonnull))dataBlock
{
    __block NSMutableArray <NSData *> * datas = [NSMutableArray arrayWithCapacity:assets.count];
    
    for (NSUInteger i = 0; i < assets.count; i++)
    {
        //获取资源
        PHAsset * asset = assets[i];
        
        //获取图片类型
        PHImageRequestOptionsDeliveryMode mode = status[i].integerValue;
        
        PHImageRequestOptions * option = [PHImageRequestOptions imageRequestOptionsWithDeliveryMode:mode];
        option.synchronous = true;
        
        //请求数据
        [[PHImageManager defaultManager]requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            [datas addObject:imageData];
            
            if (datas.count == assets.count)
            {
                //回调
                dataBlock([datas mutableCopy]);
                
                datas = nil;
            }
            
        }];
        
    }
}

@end


@implementation RITLPhotoStore (NSDeprecated)

-(PHFetchResult *)fetchPhotos:(PHAssetCollection *)group
{
    return [PHAsset fetchAssetsInAssetCollection:group options:[[PHFetchOptions alloc]init]];
}

@end




