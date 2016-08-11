# RITLImagePickerDemo
一个基于Photos.framework的图片多选，模仿微信，还有很多不足，正在改进和优化

Photos.framework是iOS8后苹果推出的一套替代AssetsLibrary.framework获取相册资源的原生库，至于AL库，欢迎大家给博文[iOS开发------简单实现图片多选功能(AssetsLibrary.framework篇)](http://blog.csdn.net/runintolove/article/details/51163192)提出宝贵的意见。

楼主大部分都是查看官方开发文档进行探索的(当然，实在不明白了也会请求google 的 0.0 )。这里就说一下个人的看法吧，相比AL库，Photos的开发文档显然更像是目前我们接触的ObjC语言(如果不信，可以对比一下AL库和Photos库的开发文档)。初次接触这个库的时候可能会感觉比较乱，毕竟类的数量比AL库多了好多，但在熟悉大体逻辑之后，就会发现它的分工比AL更加明确，并且使用起来要比AL灵活的多。

提醒一下，要使用相册资源库的时候，为了适配一下将来的iOS10，不要忘记在info.plist文件中加入`NSPhotoLibraryUsageDescription`这个描述字段啊，更多的权限坑请关注一下博文[ iOS开发------iOS 10 由于权限问题导致崩溃的那些坑](http://blog.csdn.net/runintolove/article/details/52087623)

博文原址 : [iOS开发------简单实现图片多选功能(Photos.framework篇)](http://blog.csdn.net/runintolove/article/details/52024806)

<div align="center"><img src="http://7xruse.com1.z0.glb.clouddn.com/PhotoShow.gif" height=500></img><div>
<br>

话说的有点多了，下面就谈谈个人对Photos的理解，这里只记录一下Photos.framework中类的使用与理解，真正的实现多选功能请前去上面的链接下载demo查看，多谢指正:
<br>
#类逻辑
研究一个库或者框架，总体逻辑一定是要缕清的，下面就是个人对photos的理解，有点多，分类一下吧:
<br>
##资源类 
- PHPhotoLibrary 是一个资源库。能够获取相册权限以及对相册的操作，与AL不同，它不能获取资源对象哦.
- PHFetchResult 是一个结果集，一个泛型类。通过方法获取到的相册或者资源组就是被封装成该类返回.
- PHAssetCollection 是一个资源集合对象。其实它就是一个相册的概念，可通过`类方法`获得想要的相册集合，继承自PHCollection.
- PHCollectionList 是一个资源集合列表对象。刚接触时以为它是存放PHCollection对象的集合，后来才知道，如果想要通过地点以及时间分组的话，请使用这个类替代PHAssetCollection吧，用法与PHAssetCollection类似，同样是继承自PHCollection.
- PHAsset 是一个独立的资源对象。可以通过`类方法`对PHCollection对象进行遍历，获得存放Asset对象的结果集，可以直接获得资源的规格数据，若想获得图片以及原图等资源，需要配合PHImageManager对象，继承自PHObject.
<br>
##工具类
- PHFetchOptions 一个遍历配置类。一般情况下，当存在遍历方法的时候就存在这个类型的参数，里面含有谓词、遍历顺序等属性，可以通过设置这些属性，完成不同的遍历.
- PHImageManager 是一个负责渲染资源的类。比如获得PHAsset对象的原图等操作需要使用该类.
-  PHCachingImageManager 继承自PHImageManager，可以对请求的资源对象进行缓存，这样再次获取时就不需要重新渲染，在加快获取速度的同时也降低了CPU的压力，这里最好对缓存的PHImageRequestID进行一下记录，防止同一资源被无限缓存的尴尬.
- PHImageRequestOptions 是一个资源请求的配置类。通常在使用PHImageManager对某个资源进行请求时都会存在此类型的参数，可以在请求资源时对该对象进行设置，获得想要的结果，比如原图..
<br>
##请求类
- 请求类不能独立使用，要想发挥作用，需要与PHPhotoLibrary对象配合使用.
- PHAssetCollectionChangeRequest 集合变化请求类，负责对PHAssetCollection对象的操作
- PHCollectionListChangeRequest 集合变化请求类，负责PHCollectionList对象的操作
- PHAssetChangeRequest 资源变化请求类，负责PHAsset对象的操作

<br>
#类库中的类及其属性方法:

这里提到的都是代码中用到的属性和方法，如果只是为了多图选择，那么以下的方法应该是够用的，不够的话可以Command+单击进入开发文档查看即可。 
<br>
##PHPhotoLibrary_照片库

###基础方法
我觉得下面的方法应该都懂，毕竟每个涉及到权限的库都会存在下面三个方法的.
```
//获得单例对象
+ (PHPhotoLibrary *)sharedPhotoLibrary;
//获得相册权限
+ (PHAuthorizationStatus)authorizationStatus;
//请求权限
+ (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler;
```
<br>
###操作相册

之前说请求类不能独自使用，需要配合PHPhotoLibrary对象，为什么这么说呢，是因为在使用请求类的时候必须使用下面两个方法其中之一，下面是开发文档的一句话:
```
/*表示请求只能通过下面两种方法的block进行创建和使用，所有的ChangeRequest类上面都会存在这句话，当然类名肯定不一样的.*/
PHAssetCollectionChangeRequest can only be created or used within a -[PHPhotoLibrary performChanges:] 
or -[PHPhotoLibrary performChangesAndWait:] block.

//异步执行change的变化请求
- (void)performChanges:(dispatch_block_t)changeBlock completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler;

//同步执行change的请求变化
- (BOOL)performChangesAndWait:(dispatch_block_t)changeBlock error:(NSError *__autoreleasing *)error;
```
其实我感觉只看上面的两个方法感觉会比较抽象，那么就拿出Demo中的两段小源码举个例子，相信这样就比较好理解了.
<br>
###新建相册
```
///新建一个名字叫做title的相册
-(void)addCustomGroupWithTitle:(NSString *)title
             completionHandler:(void (^)(void))successBlock
                      failture:(void (^)(NSString * _Nonnull))failtureBlock
{
    [self.photoLibaray performChanges:^{
        
        //创建一个创建相册的请求
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        
    }completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success == true)//成功
        {
            successBlock();return ;
        }
        //失败
        failtureBlock(error.localizedDescription);
    }];
}
```
<br>
###向相册里面添加图片
```
///向collection中添加图片
-(void)addCustomAsset:(UIImage *)image
           collection:(PHAssetCollection *)collection
    completionHandler:(void (^)(void))successBlock
             failture:(void (^)(NSString * _Nonnull))failtureBlock
{
    //执行变化请求
    [self.photoLibaray performChanges:^{
        
        //如果相册允许操作
        if([collection canPerformEditOperation:PHCollectionEditOperationAddContent])
        {
            //创建资源请求对象
            PHAssetChangeRequest * assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            
            //创建相册请求对象
            PHAssetCollectionChangeRequest * groupChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
            
            //向相册中添加资源
            [groupChangeRequest addAssets:@[assetChangeRequest.placeholderForCreatedAsset]];
        
        }
        
    }completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success == true)//成功
        {
            successBlock();return;
        }
        //失败
        failtureBlock(error.localizedDescription);
    }];
}

//这里不止能够通过图片对象创建，还存在如下两种创建方法
+ (nullable instancetype)creationRequestForAssetFromImageAtFileURL:(NSURL *)fileURL;//通过图片所在的路径url进行创建

+ (nullable instancetype)creationRequestForAssetFromVideoAtFileURL:(NSURL *)fileURL;//通过视频所在的路径url进行创建

```
<br>
##PHAssetCollection_资源集合对象

- 常用属性
```
//组的标题，比如Camera Roll（胶卷相册）
@property (nonatomic, strong, readonly, nullable) NSString *localizedTitle;

//资源组的类型，比如是智能相册，普通相册还是外界创建的相册
PHAssetCollectionType assetCollectionType;

typedef NS_ENUM(NSInteger, PHAssetCollectionType) {
    PHAssetCollectionTypeAlbum      = 1, //传统相册
    PHAssetCollectionTypeSmartAlbum = 2, //智能相册
    PHAssetCollectionTypeMoment     = 3, //自定义创建的相册
} NS_ENUM_AVAILABLE_IOS(8_0);

//具体的子类型，比如是智能相册的自拍还是喜爱等，这个枚举类太多，就不进行粘贴了.
PHAssetCollectionSubtype assetCollectionSubtype;

//资源组中资源的大约数量，不一定准，如果想要确切的，获得PHFetchResult对象取count即可
NSUInteger estimatedAssetCount;

//最早的一张图片存在相册的时间
NSDate *startDate;

//最近的一张图片存在相册的时间
NSDate *endDate;
```
- 获得具体资源的方法，基本都是通过类方法进行获取，这样就降低了PhotosLibrary对象复杂度。

```
//判断是否能够进行编辑，如果是进行修改请求，最好通过这个方法来判断是下
- (BOOL)canPerformEditOperation:(PHCollectionEditOperation)anOperation;

//获得智能分组，比如胶卷相册，最近添加，自拍等
PHFetchResult * smartGroups = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                       subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                       options:nil];

//获得我们自定义创建的相册组，比如有QQ的手机应该都会有QQ这个相册，那么通过该方法就可以获取的到
+ (PHFetchResult<PHCollection *> *)fetchTopLevelUserCollectionsWithOptions:(nullable PHFetchOptions *)options;
```
如果PHFetchResult觉得用起来不是很爽的话，可以将其包装成数组来进行下一步的操作，Demo中就是将其打包成数组来进行操作的:
```
@implementation PHFetchResult (NSArray)

//将PHFetchResult对象转成NSArray对象
-(void)transToArrayComplete:(void (^)(NSArray<PHAssetCollection *> * _Nonnull, PHFetchResult * _Nonnull))arrayObject
{
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *  array = [NSMutableArray arrayWithCapacity:0];
    
    if (self.count == 0)
    {
        arrayObject([array mutableCopy],weakSelf);
        array = nil;
        return;
    }
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [array addObject:obj];
        
        //如果遍历完毕，进行回调
        if (idx == self.count - 1)
        {
            arrayObject([array mutableCopy],weakSelf);
        }
    }];
}

@end
```

<br>
##PHAsset_资源对象
- 常用属性
```
//资源媒体的类型
PHAssetMediaType mediaType;

typedef NS_ENUM(NSInteger, PHAssetMediaType) {
    PHAssetMediaTypeUnknown = 0,  //未知类型
    PHAssetMediaTypeImage   = 1,  //图片类型
    PHAssetMediaTypeVideo   = 2,  //视频类型
    PHAssetMediaTypeAudio   = 3,  //音频类型
} NS_ENUM_AVAILABLE_IOS(8_0);

//资源美图的子类型，比如如果资源是图片，那么它是全景还是HDR,如果是iOS9,还能知道他是屏幕截图还是live图片，枚举有点多，也不再次粘贴了.
PHAssetMediaSubtype mediaSubtypes;

//资源的像素宽
NSUInteger pixelWidth;

//资源的像素高
NSUInteger pixelHeight;

//资源的创建日期
NSDate *creationDate;

//资源的最近一次修改的时间
NSDate *modificationDate;

//资源拍摄的地点
CLLocation *location;

//如果是音频或者视频，它的持续时间
NSTimeInterval duration;

//它是否被隐藏
BOOL hidden;

//它是否是喜爱的
BOOL favorite;
```

- 常用搭配使用方法
```
//请求图片，将想要获取Image实体的资源，裁剪的大小以及方式进行获取图片
//如果想要原图，设置PHImageRequestOptions对象的deliveryMode属性为PHImageRequestOptionsDeliveryModeHighQualityFormat即可
[[PHImageManager defaultManager]requestImageForAsset:asset
                                          targetSize:size
                                         contentMode:PHImageContentModeAspectFill
                                             options:option
                                       resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
    
    //通过block回传图片，并将部分信息存在于info字典中，并且该方法的返回值可以在info字典中找到
}];
```
```
//请求数据，获取资源的Data对象，可以用来计算资源的大小。
//这样可以避免UIImage->Data导致内存以及CPU瞬间激增
[[PHImageManager defaultManager]requestImageDataForAsset:asset
                                                 options:option
                                           resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
    //在block里面获取图片的各种信息
}];
```
```
//这里最好存在一个标位置或者其他方法标志一下，避免每次都要缓存导致的卡顿以及CPU卡死
[((PHCachingImageManager *)[PHCachingImageManager defaultManager])startCachingImagesForAssets:@[copy_self]
                                                                                   targetSize:newSize
                                                                                  contentMode:PHImageContentModeAspectFill
                                                                                      options:nil];
```
<br>
##PHFetchResult_结果集合
表示乍一看，是不是和数组很相似呀.

-  属性

```
//当前集合的数量
NSUInteger count;

//获得index位置的对象
- (ObjectType)objectAtIndex:(NSUInteger)index;

//是否包含对象
- (BOOL)containsObject:(ObjectType)anObject;

//对象的索引
- (NSUInteger)indexOfObject:(ObjectType)anObject;

//第一个对象
ObjectType firstObject;

//最后一个对象
ObjectType lastObject;
```
- 遍历方法，应该也是获取集合内部数据的唯一方法了.
```
/*使用Block进行枚举遍历，stop控制是否停止，每次获得数据都会执行一次回调*/
- (void)enumerateObjectsUsingBlock:(void (^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;

/*根据枚举类型进行枚举，比如正序还是倒序*/
- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;

/*枚举特定区间并按照响应枚举类型进行遍历*/
- (void)enumerateObjectsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts usingBlock:(void (^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;
```
<br>
#相册发生变化

使用PHPhotoLibrary对象注册观察者，当然，不要在dealloc或者特定的地方注销观察者啊，与KVO相同.
```
//注册观察者
- (void)registerChangeObserver:(id<PHPhotoLibraryChangeObserver>)observer;

//注销观察者
- (void)unregisterChangeObserver:(id<PHPhotoLibraryChangeObserver>)observer;
```

`PHPhotoLibraryChangeObserver`协议方法
```
//This callback is invoked on an arbitrary serial queue.
//If you need this to be handled on a specific queue,
//you should redispatch appropriately.

//这个回调是在一个随意的线程中被唤起，如果需要在一个特定的线程中处理，应该在合适的地方重新唤起
//(翻译可能不太准确，如果需要更新，一般情况需要在主线程，这个应该都懂得.)
- (void)photoLibraryDidChange:(PHChange *)changeInstance;
```
<br>
##实例
具体用法如下:

首先需要查看是否发生了变化，如果没有变化，那么就返回nil；如果发生了变化，就会返回响应类型的对象:
```
//PHChange对象的两个方法:

//获取PHObject对象的变化详情，其实PHAsset和PHCollection都是继承自PHObject的
- (nullable PHObjectChangeDetails *)changeDetailsForObject:(PHObject *)object;
-
//获取结果集的变化详情，和上面一样，如果不存在变化，返回nil
- (nullable PHFetchResultChangeDetails *)changeDetailsForFetchResult:(PHFetchResult *)object;
```

下面记录一下描述详细变化的类吧:
<br>
##PHObjectChangeDetails
```
//PHObject对象变化详情对象
PHObjectChangeDetails.h

//变化之前的对象
@property (atomic, strong, readonly) __kindof PHObject *objectBeforeChanges;

//变化之后的对象，
@property (atomic, strong, readonly, nullable) __kindof PHObject *objectAfterChanges;

//内容是否发生了变化
@property (atomic, readonly) BOOL assetContentChanged;

//该对象是否已经删除
@property (atomic, readonly) BOOL objectWasDeleted;

@end

/*
1、判断一下是否被删除了，如果被删除了，那么请把数据源的该对象也删除了吧，并重新reload一下当前的视图.
2、如果没有被删除，就可以知道是否发生了变化，那么，获取变化后的内容对象并将之前的内容replace一下，刷新视图即可
*/
```
<br>
##PHFetchResultChangeDetails
```
//PHFetchResult对象发生变化的详情类
PHFetchResultChangeDetails.h

//变化之前的结果集
@property (atomic, strong, readonly) PHFetchResult *fetchResultBeforeChanges;

//变化之后的结果集
@property (atomic, strong, readonly) PHFetchResult *fetchResultAfterChanges;

/*
这个变量很有意思:
如果为true,表示集合发生了增删改,那么通过一下面的删除、新增以及更新操作的响应属性或方法进行数据的修改即可。
如果为false,则表示发生了大的改变，不在提供下面那些变化的详情，只能使用fetchResultAfterChanges属性对该属性进行替换即可*/
@property (atomic, assign, readonly) BOOL hasIncrementalChanges;

//如果是删除操作，返回删除的位置以及删除的对象
@property (atomic, strong, readonly, nullable) NSIndexSet *removedIndexes;
@property (atomic, strong, readonly) NSArray<__kindof PHObject *> *removedObjects;

//如果是新增操作，返回新增的位置以及新增的对象
@property (atomic, strong, readonly, nullable) NSIndexSet *insertedIndexes;
@property (atomic, strong, readonly) NSArray<__kindof PHObject *> *insertedObjects;

//如果是更新操作，返回更新的位置以及更新的对象
@property (atomic, strong, readonly, nullable) NSIndexSet *changedIndexes;
@property (atomic, strong, readonly) NSArray<__kindof PHObject *> *changedObjects;

/*
1、判断一下hasIncrementalChanges值，如果为false,直接取fetchResultAfterChanges属性进行值的替换
2、如果为true,根据下面的详情数据进行相应操作即可，当然，使用全体替换的方法也是可以的，但是单个操作可以使用动画哦
*/
```
<br>
#吐槽
我要开始吐槽啦！其实毕业回学校的时候无聊，想练习一下Swift，研究过这个库，大体的功能与博文Demo的功能差不多，但由于起名太随便，随手删了,没错..删了！(还真是感谢我随手清理垃圾篓的习惯，呵呵....所以大家一定要不忘记备份呀，= = 再就是起名不要太随便啊)，这个Demo是趁工作的业余时间写的，目的是加深对Photos库理解的同时不辜负学校的那段时间，<font color=red>不太建议直接拿本文的Demo直接放入工程中使用哦，Demo的目的只是为了学习一下Photos库，尽管对Demo进行了一些内存泄露的处理，但每次还是会有大约1MB多的内存多余占用，这个问题会在之后楼主不断进步的过程中进行修复的</font>

记录完毕`3Q`


