//
//  RITLPhotosItemsCollectionViewController.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosCollectionViewController.h"
#import "RITLPhotoPreviewController.h"

#import "RITLPhotosCell.h"
#import "RITLPhotosBottomView.h"

#import "PHAsset+RITLPhotos.h"
#import "NSString+RITLPhotos.h"

#import <RITLKit.h>
#import <Masonry.h>
#import <Photos/Photos.h>


typedef NSString RITLDifferencesKey;
static RITLDifferencesKey *const RITLDifferencesKeyAdded = @"RITLDifferencesKeyAdded";
static RITLDifferencesKey *const RITLDifferencesKeyRemoved = @"RITLDifferencesKeyRemoved";

@interface UICollectionView (RITLPhotosCollectionViewController)

- (NSArray <NSIndexPath *>*)indexPathsForElementsInRect:(CGRect)rect;

@end


@interface RITLPhotosCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIViewControllerPreviewingDelegate,UICollectionViewDataSourcePrefetching>

// data
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)PHAssetCollection *assetCollection;
@property (nonatomic, strong)PHFetchResult <PHAsset *> *assets;

@property (nonatomic, strong) PHCachingImageManager* imageManager;
@property (nonatomic, assign) CGRect previousPreheatRect;

// view
@property (nonatomic, strong) RITLPhotosBottomView *bottomView;

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
       
        self.imageManager = [PHCachingImageManager new];
        self.previousPreheatRect = CGRectZero;
    }
    
    return self;
}


- (void)resetCachedAssets
{
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    // NavigationItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancle" style:UIBarButtonItemStyleDone target:self action:@selector(dismissPhotoControllers)];
    
    // Register cell classes
    [self.collectionView registerClass:[RITLPhotosCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.bottomView = RITLPhotosBottomView.new;
    self.bottomView.backgroundColor = UIColor.blackColor;
    
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    
    // Layout
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.left.right.offset(0);
        make.height.mas_equalTo(RITL_DefaultTabBarHeight);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.offset(0);
        make.bottom.equalTo(self.bottomView.mas_top).offset(0);
    }];

    //加载数据
    if (!self.localIdentifier) { return; }
    
    //加载
    self.assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[self.localIdentifier] options:nil].firstObject;
    
    self.assets = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:nil];
    
    //reload
    self.collectionView.hidden = true;
    [self.collectionView reloadData];
    
    if (self.assets.count < 1) { return; }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        //进行滚动
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assets.count - 1 inSection:0]atScrollPosition:UICollectionViewScrollPositionBottom animated:false];
//
        self.collectionView.hidden = false;
//
//    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateCachedAssets];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - *************** cache ***************

- (void)updateCachedAssets
{
    if (!self.isViewLoaded || self.view.window == nil) { return; }
    
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


- (NSDictionary <RITLDifferencesKey*,NSArray<NSValue *>*> *)differencesBetweenRects:(CGRect)old new:(CGRect)new
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

#pragma mark - Dismiss

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
    
    // Configure the cell
    cell.representedAssetIdentifier = asset.localIdentifier;
    [self.imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier] && result) {
            cell.imageView.image = result;
            
            cell.messageView.hidden = (asset.mediaType == PHAssetMediaTypeImage);
            
            if (cell.imageView.hidden) { return; }
            
            cell.messageLabel.text = [NSString timeStringWithTimeDuration:asset.duration];
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

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateCachedAssets];
}



#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat sizeHeight = (RITL_SCREEN_WIDTH - 3.0f * 3) / 4;
    
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

#pragma mark - <UIViewControllerPreviewingDelegate>
//#warning 会出现内存泄露，临时不使用
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
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
    
    RITLPhotoPreviewController * viewController = [RITLPhotoPreviewController previewWithShowAsset:asset];
    
    return viewController;
}


- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    //获取当前cell的indexPath
//    NSIndexPath * indexPath = [self.collectionView indexPathForCell:(RITLPhotosCell *)previewingContext.sourceView];
    
    
//    [self.viewModel didSelectItemAtIndexPath:indexPath];
}

#pragma mark - <UICollectionViewDataSourcePrefetching>

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0)
{

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
        
        _collectionView.allowsMultipleSelection = true;
        
//#ifdef __IPHONE_10_0
//        if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)
//        {
//            _collectionView.prefetchDataSource = self;
//        }
        
//#endif
        
        //property
        _collectionView.backgroundColor = [UIColor whiteColor];
        
//        //register View
//        [_collectionView registerClass:[RITLPhotosCell class] forCellWithReuseIdentifier:cellIdentifier];
//        [_collectionView registerClass:[RITLPhotoBottomReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reusableViewIdentifier];
    }
    
    return _collectionView;
}

@end


@implementation UICollectionView (RITLPhotosCollectionViewController)


- (NSArray<NSIndexPath *> *)indexPathsForElementsInRect:(CGRect)rect
{
    NSArray <UICollectionViewLayoutAttributes*> *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    
    return [allLayoutAttributes ritl_map:^id _Nonnull(UICollectionViewLayoutAttributes * _Nonnull attribute) {
        
        return attribute.indexPath;
    }];
}

@end
