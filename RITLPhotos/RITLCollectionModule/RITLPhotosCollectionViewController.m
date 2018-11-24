//
//  RITLPhotosItemsCollectionViewController.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosCollectionViewController.h"
#import "RITLPhotosPreviewController.h"
#import "RITLPhotosHorBrowseViewController.h"

#import "RITLPhotosCell.h"
#import "RITLPhotosBottomView.h"
#import "RITLPhotosBrowseAllDataSource.h"
#import "RITLPhotosBrowseDataSource.h"
#import "RITLPhotosConfiguration.h"

#import "PHAsset+RITLPhotos.h"
#import "NSString+RITLPhotos.h"
#import "PHPhotoLibrary+RITLPhotoStore.h"
#import "UICollectionView+RITLIndexPathsForElements.h"
#import "UICollectionViewCell+RITLPhotosAsset.h"

#import <RITLKit/RITLKit.h>
#import <RITLViewFrame/UIView+RITLFrameChanged.h>
#import <Masonry/Masonry.h>
#import <Photos/Photos.h>

//Data
#import "RITLPhotosMaker.h"
#import "RITLPhotosDataManager.h"
#import "RITLPhotosConfiguration.h"




typedef NSString RITLDifferencesKey;
static RITLDifferencesKey *const RITLDifferencesKeyAdded = @"RITLDifferencesKeyAdded";
static RITLDifferencesKey *const RITLDifferencesKeyRemoved = @"RITLDifferencesKeyRemoved";

@interface UICollectionView (RITLPhotosCollectionViewController)

- (NSArray <NSIndexPath *>*)indexPathsForElementsInRect:(CGRect)rect;

@end


@interface RITLPhotosCollectionViewController ()<UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIViewControllerPreviewingDelegate,
UICollectionViewDataSourcePrefetching,
RITLPhotosCellActionTarget>

// Library
@property (nonatomic, strong) PHPhotoLibrary *photoLibrary;
// Datamanager
@property (nonatomic, strong) RITLPhotosDataManager *dataManager;

// data
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) PHFetchResult <PHAsset *> *assets;

@property (nonatomic, strong) PHCachingImageManager* imageManager;
@property (nonatomic, assign) CGRect previousPreheatRect;

// view
@property (nonatomic, strong) RITLPhotosBottomView *bottomView;
/// 用于iOS 10的缓存的队列
@property (nonatomic, strong) dispatch_queue_t photo_queue NS_AVAILABLE_IOS(10_0);
/// 用图存储时间的字典
@property (nonatomic, strong) NSMutableDictionary *timeCache;

@end

@implementation RITLPhotosCollectionViewController

static NSString *const reuseIdentifier = @"photo";

+ (RITLPhotosCollectionViewController *)photosCollectionController
{
    return RITLPhotosCollectionViewController.new;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.previousPreheatRect = CGRectZero;
        self.dataManager = [RITLPhotosDataManager sharedInstance];
    }
    
    return self;
}


- (void)resetCachedAssets
{
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}


- (PHAssetCollection *)assetCollection
{
    if (!_assetCollection) {
        
        _assetCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].firstObject;
    }
    
    return _assetCollection;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.timeCache = [NSMutableDictionary dictionaryWithCapacity:80];
    
    //进行KVO观察
    [self.dataManager addObserver:self forKeyPath:@"count" options:NSKeyValueObservingOptionNew context:nil];
    [self.dataManager addObserver:self forKeyPath:@"hightQuality" options:NSKeyValueObservingOptionNew context:nil];
    
    if (@available(iOS 10.0,*)) {
        self.photo_queue = dispatch_queue_create("com.ritl.photos", DISPATCH_QUEUE_CONCURRENT);
    }
    
    // NavigationItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Cancle", @"") style:UIBarButtonItemStyleDone target:self action:@selector(cancleItemDidTap)];
    
    // Register cell classes
    [self.collectionView registerClass:[RITLPhotosCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.bottomView = RITLPhotosBottomView.new;
    self.bottomView.previewButton.enabled = false;
    self.bottomView.sendButton.enabled = false;
    
    [self.bottomView.previewButton addTarget:self
                                      action:@selector(pushPreviewViewController)
                            forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView.fullImageButton addTarget:self
                                        action:@selector(hightQualityShouldChanged:)
                              forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView.sendButton addTarget:self
                                   action:@selector(pushPhotosMaker)
                         forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.8];
    
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    
    // Layout
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.offset(0);
        make.height.mas_equalTo(RITL_DefaultTabBarHeight - 3);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.offset(0);
        make.bottom.equalTo(self.bottomView.mas_top).offset(0);
    }];
    
    //加载数据
    if (self.localIdentifier) {
        //加载
        self.assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[self.localIdentifier] options:nil].firstObject;
    }
    
    //进行权限检测
    [PHPhotoLibrary authorizationStatusAllow:^{
        
        self.imageManager = [PHCachingImageManager new];
        self.photoLibrary = PHPhotoLibrary.sharedPhotoLibrary;
        
        [self resetCachedAssets];
        
        self.assets = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:nil];
        
        //reload
        self.collectionView.hidden = true;
        [self.collectionView reloadData];
        
        //设置itemTitle
        self.navigationItem.title = self.assetCollection.localizedTitle;
        
        //计算行数,并滑动到最后一行
        self.collectionView.hidden = false;
        
        [self collectionViewScrollToBottomAnimatedNoneHandler:^NSInteger(NSInteger row) {
            
            return row;
        }];
        
    } denied:^{}];
    
    [self changedBottomViewStatus];
}



- (void)dealloc
{
    if (self.isViewLoaded) {
        [self.dataManager removeObserver:self forKeyPath:@"count"];
        [self.dataManager removeObserver:self forKeyPath:@"hightQuality"];
    }

    [self.dataManager removeAllPHAssets];
    NSLog(@"[%@] is dealloc",NSStringFromClass(self.class));
}


- (void)collectionViewScrollToBottomAnimatedNoneHandler:(NSInteger(^)(NSInteger row))handler
{
    //获得所有的数据个数
    NSInteger itemCount = self.assets.count;
    
    if (itemCount < 4) { return; }
    
    //获得行数
    NSInteger row = itemCount % 4 == 0 ? itemCount / 4 : itemCount / 4 + 1;
    
    if (handler) { row = handler(row); }
    
    //item
    CGFloat itemHeight = (RITL_SCREEN_WIDTH - 3.0f * 3) / 4;
    
    //进行高度换算
    CGFloat height = row * itemHeight;
    height += 3.0 * (row - 1);
    
    //扩展contentSize
    self.collectionView.ritl_contentSizeHeight = height;
    
    //底部bottom
    CGFloat bottomHeight = RITL_DefaultTabBarHeight;
    
    //可以显示的区域
    CGFloat showSapce = RITL_SCREEN_HEIGHT - RITL_DefaultNaviBarHeight - bottomHeight;
    
    //进行单位换算
    self.collectionView.ritl_contentOffSetY = MAX(MAX(0,height - showSapce),-1 * RITL_DefaultNaviBarHeight);
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!RITL_iOS_Version_GreaterThanOrEqualTo(10.0)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
       [self updateCachedAssets];
#pragma clang diagnostic pop
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Dismiss

- (void)cancleItemDidTap {
    
    [NSNotificationCenter.defaultCenter postNotificationName:@"PhotosControllerDidDismissNotification" object:nil];
    [self dismissPhotoControllers];
}


- (void)dismissPhotoControllers
{
    if(self.navigationController.presentingViewController){//如果是模态弹出
        
        [self.navigationController dismissViewControllerAnimated:true completion:nil];
        
    }else if(self.navigationController){
        
        [self.navigationController popViewControllerAnimated:true];
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets ? self.assets.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RITLPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //Asset
    PHAsset *asset = [self.assets objectAtIndex:indexPath.item];

    //Size
    CGSize size = [self collectionView:collectionView layout:collectionView.collectionViewLayout sizeForItemAtIndexPath:indexPath];

    PHImageRequestOptions *options = PHImageRequestOptions.new;
    options.networkAccessAllowed = true;

    // Configure the cell
    cell.representedAssetIdentifier = asset.localIdentifier;
    [self.imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {

        if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier] && result) {

            cell.actionTarget = self;
            cell.asset = asset;
            cell.indexPath = indexPath;
            cell.imageView.image = result;
        }
    }];
    
    //注册3D Touch
    if (@available(iOS 9.0,*)) {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable){
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        }
    }
    
    return cell;
}

// set value
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Asset
    PHAsset *asset = [self.assets objectAtIndex:indexPath.item];
    //强转
    if (![cell isKindOfClass:RITLPhotosCell.class]) { return; }
    
    RITLPhotosCell *photoCell = (RITLPhotosCell *)cell;
    
    photoCell.messageView.hidden = (asset.mediaType == PHAssetMediaTypeImage);

    if(!RITLPhotosConfiguration.defaultConfiguration.containVideo){//是否允许选择视频-不允许选择视频，去掉选择符
        photoCell.chooseButton.hidden = (asset.mediaType == PHAssetMediaTypeVideo);
    }

    BOOL isSelected = [self.dataManager.assetIdentiers containsObject:asset.localIdentifier];
    //进行属性隐藏设置
    photoCell.indexLabel.hidden = !isSelected;

    if (isSelected) {
        photoCell.indexLabel.text = @([self.dataManager.assetIdentiers indexOfObject:asset.localIdentifier] + 1).stringValue;
    }

    if (photoCell.imageView.hidden) { return; }

    NSString *time = [self.timeCache valueForKey:[NSString stringWithFormat:@"%@",@(asset.duration)]];
    if (time != nil){
        photoCell.messageLabel.text = time; return;
    }

    time = [NSString timeStringWithTimeDuration:asset.duration];
    photoCell.messageLabel.text = time;
    [self.timeCache addEntriesFromDictionary:@{@(asset.duration) : time}];//追加缓存

    if (@available(iOS 9.1,*)) {//Live图片
        photoCell.liveBadgeImageView.hidden = !(asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive);
    }
}



#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!RITL_iOS_Version_GreaterThanOrEqualTo(10.0)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self updateCachedAssets];
#pragma clang diagnostic pop
    }
}


#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat sizeHeight = (MIN(RITL_SCREEN_WIDTH,RITL_SCREEN_HEIGHT) - 3.0f * 3) / 4;
    
    return CGSizeMake(sizeHeight, sizeHeight);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.f;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //获取当前的资源
    PHAsset *asset = [self.assets objectAtIndex:indexPath.item];
    //跳出控制器
    [self pushHorAllBrowseViewControllerWithAsset:asset];
}



#pragma mark - <UIViewControllerPreviewingDelegate>

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0)
{
    //获取当前cell的indexPath
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:(RITLPhotosCell *)previewingContext.sourceView];
    
    NSUInteger item = indexPath.item;
    
    //获得当前的资源
    PHAsset *asset = self.assets[item];
    
    if (asset.mediaType != PHAssetMediaTypeImage)
    {
        return nil;
    }
    
    RITLPhotosPreviewController * viewController = [RITLPhotosPreviewController previewWithShowAsset:asset];
    
    return viewController;
}


- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0)
{
    //获取当前cell的indexPath
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:(RITLPhotosCell *)previewingContext.sourceView];
    
    //获取当前的资源
    PHAsset *asset = [self.assets objectAtIndex:indexPath.item];
    
    //跳出控制器
    [self pushHorAllBrowseViewControllerWithAsset:asset];
}


#pragma mark - <UICollectionViewDataSourcePrefetching>

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0)
{
    CGSize thimbnailSize = [self collectionView:collectionView layout:collectionView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    dispatch_async(self.photo_queue, ^{
       
        [self.imageManager startCachingImagesForAssets:[indexPaths ritl_map:^id _Nonnull(NSIndexPath * _Nonnull obj) {
            return [self.assets objectAtIndex:obj.item];
            
        }] targetSize:thimbnailSize contentMode:PHImageContentModeAspectFill options:nil];
    });
}


- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths  NS_AVAILABLE_IOS(10_0)
{
    CGSize thimbnailSize = [self collectionView:collectionView layout:collectionView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    dispatch_async(self.photo_queue, ^{
       
        [self.imageManager stopCachingImagesForAssets:[indexPaths ritl_map:^id _Nonnull(NSIndexPath * _Nonnull obj) {
            
            return [self.assets objectAtIndex:obj.item];
            
        }] targetSize:thimbnailSize contentMode:PHImageContentModeAspectFill options:nil];
    });
}


#pragma mark - Browse All Assets Display

/// Push 出所有的资源浏览
- (void)pushHorAllBrowseViewControllerWithAsset:(PHAsset *)asset
{
    [self.navigationController pushViewController:({
        
        RITLPhotosHorBrowseViewController *browerController = RITLPhotosHorBrowseViewController.new;
        
        RITLPhotosBrowseAllDataSource *dataSource = RITLPhotosBrowseAllDataSource.new;
        dataSource.collection = self.assetCollection;
        dataSource.asset = asset;
        
        browerController.dataSource = dataSource;
        browerController.backHandler = ^{
            
            [self.collectionView reloadData];
        };
        
        browerController;
        
    }) animated:true];
}


/// Push出已经选择的资源浏览
- (void)pushPreviewViewController
{
    [self.navigationController pushViewController:({
        
        RITLPhotosHorBrowseViewController *browerController = RITLPhotosHorBrowseViewController.new;
        
        RITLPhotosBrowseDataSource *dataSource = RITLPhotosBrowseDataSource.new;
        dataSource.assets = self.dataManager.assets;
        
        browerController.dataSource = dataSource;
        browerController.backHandler = ^{
            
            [self.collectionView reloadData];
        };
        
        browerController;
        
    }) animated:true];
}

#pragma mark - Send

- (void)pushPhotosMaker
{
    [RITLPhotosMaker.sharedInstance startMakePhotosComplete:^{
       
        [self dismissPhotoControllers];
    }];
}

#pragma mark -

-(UICollectionView *)collectionView
{
    if(_collectionView == nil)
    {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        
        //protocol
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        if (@available(iOS 10.0,*)) {
            _collectionView.prefetchDataSource = self;
        }
        
        //property
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    
    return _collectionView;
}


#pragma mark - <RITLPhotosCellActionTarget>

- (void)photosCellDidTouchUpInSlide:(RITLPhotosCell *)cell asset:(PHAsset *)asset indexPath:(NSIndexPath *)indexPath complete:(RITLPhotosCellStatusAction)animated
{
    if (self.dataManager.count >= RITLPhotosConfiguration.defaultConfiguration.maxCount &&
        ![self.dataManager containAsset:asset]/*是添加*/) { return; }//不能进行选择
    
    NSInteger index = [self.dataManager addOrRemoveAsset:asset].integerValue;
    
    animated(RITLPhotosCellAnimatedStatusPermit,index > 0,MAX(0,index));
    
    if (index < 0) {//表示进行了取消操作
        [self.collectionView reloadData];
    }
}


#pragma mark - <KVO>

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"count"] && [object isEqual:self.dataManager]) {
        
        [self changedBottomViewStatus];
    }
    
    else if([keyPath isEqualToString:@"hightQuality"] && [object isEqual:self.dataManager]){
        
        BOOL hightQuality = [change[NSKeyValueChangeNewKey] boolValue];
        self.bottomView.fullImageButton.selected = hightQuality;
    }
}

#pragma mark - *************** cache ***************
#pragma mark - iOS 10 之前进行的手动计算，iOS 10 以后使用 UICollectionViewDataSourcePrefetching


- (void)updateCachedAssets __deprecated_msg("iOS 10 Use collectionView:prefetchItemsAtIndexPaths: and collectionView:cancelPrefetchingForItemsAtIndexPaths: instead.")
{
    if (!self.isViewLoaded || self.view.window == nil) { return; }
    
    //没有权限，关闭
    if (PHPhotoLibrary.authorizationStatus != PHAuthorizationStatusAuthorized) { return; }
    
    //可视化
    CGRect visibleRect = CGRectMake(self.collectionView.ritl_contentOffSetX, self.collectionView.ritl_contentOffSetY, self.collectionView.ritl_width, self.collectionView.ritl_height);
    
    //进行拓展
    CGRect preheatRect = CGRectInset(visibleRect, 0, -0.5 * visibleRect.size.height);
    
    //只有可视化的区域与之前的区域有显著的区域变化才需要更新
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta <= self.view.ritl_height / 3.0) { return; }
    
    //获得比较后需要进行预加载以及需要停止缓存的区域
    NSDictionary *differences = [self differencesBetweenRects:self.previousPreheatRect new:preheatRect];
    NSArray <NSValue *> *addedRects = differences[RITLDifferencesKeyAdded];
    NSArray <NSValue *> *removedRects = differences[RITLDifferencesKeyRemoved];
    
    ///进行提前缓存的资源
    NSArray <PHAsset *> *addedAssets = [[[addedRects ritl_map:^id _Nonnull(NSValue * _Nonnull rectValue) {
        return [self.collectionView indexPathsForElementsInRect:rectValue.CGRectValue];
        
    }] ritl_reduce:@[] reduceHandler:^NSArray * _Nonnull(NSArray * _Nonnull result, NSArray <NSIndexPath *>*_Nonnull items) {
        return [result arrayByAddingObjectsFromArray:items];
        
    }] ritl_map:^id _Nonnull(NSIndexPath *_Nonnull index) {
        return [self.assets objectAtIndex:index.item];
        
    }];
    
    ///提前停止缓存的资源
    NSArray <PHAsset *> *removedAssets = [[[removedRects ritl_map:^id _Nonnull(NSValue * _Nonnull rectValue) {
        return [self.collectionView indexPathsForElementsInRect:rectValue.CGRectValue];
        
    }] ritl_reduce:@[] reduceHandler:^NSArray * _Nonnull(NSArray * _Nonnull result, NSArray <NSIndexPath *>* _Nonnull items) {
        return [result arrayByAddingObjectsFromArray:items];
        
    }] ritl_map:^id _Nonnull(NSIndexPath *_Nonnull index) {
        return [self.assets objectAtIndex:index.item];
    }];
    
    CGSize thimbnailSize = [self collectionView:self.collectionView layout:self.collectionView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    //更新缓存
    [self.imageManager startCachingImagesForAssets:addedAssets targetSize:thimbnailSize contentMode:PHImageContentModeAspectFill options:nil];
    [self.imageManager stopCachingImagesForAssets:removedAssets targetSize:thimbnailSize contentMode:PHImageContentModeAspectFill options:nil];
    
    //记录当前位置
    self.previousPreheatRect = preheatRect;
}


- (NSDictionary <RITLDifferencesKey*,NSArray<NSValue *>*> *)differencesBetweenRects:(CGRect)old new:(CGRect)new __deprecated_msg("iOS 10 Use collectionView:prefetchItemsAtIndexPaths: and collectionView:cancelPrefetchingForItemsAtIndexPaths: instead.")
{
    if (CGRectIntersectsRect(old, new)) {//如果区域交叉
        
        NSMutableArray <NSValue *> * added = [NSMutableArray arrayWithCapacity:10];
        if (CGRectGetMaxY(new) > CGRectGetMaxY(old)) {//表示上拉
            [added addObject:[NSValue valueWithCGRect:CGRectMake(new.origin.x, CGRectGetMaxY(old), new.size.width, CGRectGetMaxY(new) - CGRectGetMaxY(old))]];
        }
        
        if(CGRectGetMinY(old) > CGRectGetMinY(new)){//表示下拉
            
            [added addObject:[NSValue valueWithCGRect:CGRectMake(new.origin.x, CGRectGetMinY(new), new.size.width, CGRectGetMinY(old) - CGRectGetMinY(new))]];
        }
        
        NSMutableArray <NSValue *> * removed = [NSMutableArray arrayWithCapacity:10];
        if (CGRectGetMaxY(new) < CGRectGetMaxY(old)) {//表示下拉
            [removed addObject:[NSValue valueWithCGRect:CGRectMake(new.origin.x, CGRectGetMaxY(new), new.size.width, CGRectGetMaxY(old) - CGRectGetMaxY(new))]];
        }
        
        if (CGRectGetMinY(old) < CGRectGetMinY(new)) {//表示上拉
            
            [removed addObject:[NSValue valueWithCGRect:CGRectMake(new.origin.x, CGRectGetMinY(old), new.size.width, CGRectGetMinY(new) - CGRectGetMinY(old))]];
        }
        
        return @{RITLDifferencesKeyAdded:added,
                 RITLDifferencesKeyRemoved:removed};
    }else {
        
        return @{RITLDifferencesKeyAdded:@[[NSValue valueWithCGRect:new]],
                 RITLDifferencesKeyRemoved:@[[NSValue valueWithCGRect:old]]};
    }
}



#pragma mark - 检测

/// 检测底部视图的状态
- (void)changedBottomViewStatus
{
    NSInteger count = self.dataManager.count;
    
    self.bottomView.previewButton.enabled = !(count == 0);
    
    UIControlState state = (count == 0 ? UIControlStateDisabled : UIControlStateNormal);
    NSString *title = (count == 0 ? @"发送" : [NSString stringWithFormat:@"发送(%@)",@(count)]);
    [self.bottomView.sendButton setTitle:title forState:state];
    self.bottomView.sendButton.enabled = !(count == 0);
}


#pragma mark - action

- (void)hightQualityShouldChanged:(UIButton *)sender
{
    self.dataManager.hightQuality = !self.dataManager.hightQuality;
}

@end

