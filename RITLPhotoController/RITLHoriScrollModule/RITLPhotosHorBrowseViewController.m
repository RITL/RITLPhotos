//
//  RITLPhotoHorBrowerViewController.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/4/27.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosHorBrowseViewController.h"
#import "RITLPhotosBrowseVideoCell.h"
#import "RITLPhotosBrowseImageCell.h"
#import "RITLPhotosBrowseLiveCell.h"
#import "RITLPhotosBottomView.h"
#import "PHAsset+RITLPhotos.h"
#import <RITLKit.h>
#import <Masonry.h>
#import "UICollectionViewCell+RITLPhotosAsset.h"
#import "UICollectionView+RITLIndexPathsForElements.h"

#define RITLPhotosHorBrowseCollectionSpace 3

static NSString *const RITLBrowsePhotoKey = @"photo";
static NSString *const RITLBrowseLivePhotoKey = @"livephoto";
static NSString *const RITLBrowseVideoKey = @"video";

typedef NSString RITLHorBrowseDifferencesKey;
static RITLHorBrowseDifferencesKey *const RITLHorBrowseDifferencesKeyAdded = @"RITLDifferencesKeyAdded";
static RITLHorBrowseDifferencesKey *const RITLHorBrowseDifferencesKeyRemoved = @"RITLDifferencesKeyRemoved";

@interface RITLPhotosHorBrowseViewController ()<UICollectionViewDelegate>

/// 顶部模拟的导航
@property (nonatomic, strong) UIView *topBar;
/// 返回的按钮
@property (nonatomic, strong) UIButton *backButton;
/// 状态按钮
@property (nonatomic, strong) UIButton *statusButton;
/// 展示图片的collectionView
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
/// 底部的视图
@property (nonatomic, strong) RITLPhotosBottomView *bottomView;
/// 用于计算缓存的位置
@property (nonatomic, assign) CGRect previousPreheatRect;
/// 预览的collectionView
@property (nonatomic, strong) UICollectionView *browseCollectionView;

@end

@implementation RITLPhotosHorBrowseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.previousPreheatRect = CGRectZero;
    [self resetCachedAssets];
    
    self.bottomView = RITLPhotosBottomView.new;
    self.bottomView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.8];
    //暂时屏蔽掉图片编辑功能
    self.bottomView.previewButton.hidden = true;
   
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    
    //进行注册
    [self.collectionView registerClass:RITLPhotosBrowseImageCell.class forCellWithReuseIdentifier:RITLBrowsePhotoKey];
    [self.collectionView registerClass:RITLPhotosBrowseVideoCell.class forCellWithReuseIdentifier:RITLBrowseVideoKey];
    [self.collectionView registerClass:RITLPhotosBrowseLiveCell.class forCellWithReuseIdentifier:RITLBrowseLivePhotoKey];

    //初始化视图
    self.topBar = ({
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.75];
        view;
    });
    
    self.backButton = ({
        
        UIButton *view = [UIButton new];
        view.adjustsImageWhenHighlighted = false;
        view.backgroundColor = [UIColor clearColor];
        [view addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        view.imageEdgeInsets = UIEdgeInsetsMake(13, 5, 5, 23);
        [view setImage:@"RITLPhotos.bundle/ritl_browse_back".ritl_image forState:UIControlStateNormal];
        view;
    });
    
    self.statusButton = ({
        
        UIButton *view = [UIButton new];
        view.adjustsImageWhenHighlighted = false;
        view.backgroundColor = [UIColor clearColor];
        view.imageEdgeInsets = UIEdgeInsetsMake(10, 11, 0, 0);
        [view setImage:@"RITLPhotos.bundle/ritl_brower_selected".ritl_image forState:UIControlStateNormal];
        view;
    });
    
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.browseCollectionView];
    [self.topBar addSubview:self.backButton];
    [self.topBar addSubview:self.statusButton];
    
    UIView *lineView = ({
        
        UIView *view = [UIView new];
        view.backgroundColor = RITLColorSimpleFromIntRBG(66);
        view.frame = @[@0,@79.3,@(RITL_SCREEN_WIDTH),@0.7].ritl_rect;
        
        view;
    });
    
    //模拟横线
    [self.browseCollectionView addSubview:lineView];
    
    //进行布局
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.bottom.offset(0);
        make.left.offset(-1 * RITLPhotosHorBrowseCollectionSpace);
        make.right.offset(RITLPhotosHorBrowseCollectionSpace);
    }];

    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.offset(0);
        make.height.mas_equalTo(RITL_DefaultNaviBarHeight);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(15);
        make.width.height.mas_equalTo(40);
        make.bottom.inset(10);
    }];
    
    [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.inset(10);
        make.width.height.mas_equalTo(40);
        make.bottom.inset(10);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.offset(0);
        make.height.mas_equalTo(RITL_DefaultTabBarHeight - 3);
    }];
    
    [self.browseCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.bottomView.mas_top).offset(0);
        make.left.right.offset(0);
        make.height.mas_equalTo(80);
    }];

    
    //如果存在默认方法
    if ([self.dataSource respondsToSelector:@selector(defaultItemIndexPath)]) {
        
       [self.collectionView scrollToItemAtIndexPath:self.dataSource.defaultItemIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:false];
    }
    
    //接收cell的单击通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(horBrowseTooBarChangedHiddenStateNotificationationHandler:) name:RITLHorBrowseTooBarChangedHiddenStateNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateCachedAssets];
}


- (void)resetCachedAssets
{
    [self.dataSource.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return true;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pop
{
    [self.collectionView.visibleCells makeObjectsPerformSelector:@selector(stop)];
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - *************** cache ***************

- (void)updateCachedAssets
{
    if (!self.isViewLoaded || self.view.window == nil) { return; }
    
    //可视化
    CGRect visibleRect = CGRectMake(self.collectionView.ritl_contentOffSetX, self.collectionView.ritl_contentOffSetY, self.collectionView.ritl_width, self.collectionView.ritl_height);
    
    //进行拓展
    CGRect preheatRect = CGRectInset(visibleRect, -0.5 * visibleRect.size.width, 0);
    
    //只有可视化的区域与之前的区域有显著的区域变化才需要更新
    CGFloat delta = ABS(CGRectGetMidX(preheatRect) - CGRectGetMidX(self.previousPreheatRect));
    if (delta <= self.view.ritl_width / 3.0) { return; }
    
    //获得比较后需要进行预加载以及需要停止缓存的区域
    NSDictionary *differences = [self differencesBetweenRects:self.previousPreheatRect new:preheatRect];
    NSArray <NSValue *> *addedRects = differences[RITLHorBrowseDifferencesKeyAdded];
    NSArray <NSValue *> *removedRects = differences[RITLHorBrowseDifferencesKeyRemoved];
    
    ///进行提前缓存的资源
    NSArray <PHAsset *> *addedAssets = [[[addedRects ritl_map:^id _Nonnull(NSValue * _Nonnull rectValue) {
        return [self.collectionView indexPathsForElementsInRect:rectValue.CGRectValue];
        
    }] ritl_reduce:@[] reduceHandler:^NSArray * _Nonnull(NSArray * _Nonnull result, NSArray <NSIndexPath *>*_Nonnull items) {
        return [result arrayByAddingObjectsFromArray:items];
        
    }] ritl_map:^id _Nonnull(NSIndexPath *_Nonnull index) {

        return [self.dataSource assetAtIndexPath:index];
        
    }];
    
    ///提前停止缓存的资源
    NSArray <PHAsset *> *removedAssets = [[[removedRects ritl_map:^id _Nonnull(NSValue * _Nonnull rectValue) {
        return [self.collectionView indexPathsForElementsInRect:rectValue.CGRectValue];
        
    }] ritl_reduce:@[] reduceHandler:^NSArray * _Nonnull(NSArray * _Nonnull result, NSArray <NSIndexPath *>* _Nonnull items) {
        return [result arrayByAddingObjectsFromArray:items];
        
    }] ritl_map:^id _Nonnull(NSIndexPath *_Nonnull index) {

        return [self.dataSource assetAtIndexPath:index];
    }];
    
    CGSize thimbnailSize = ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize;
    
    //更新缓存
    [self.dataSource.imageManager startCachingImagesForAssets:addedAssets targetSize:thimbnailSize contentMode:PHImageContentModeAspectFill options:nil];
    [self.dataSource.imageManager stopCachingImagesForAssets:removedAssets targetSize:thimbnailSize contentMode:PHImageContentModeAspectFill options:nil];
    
    //记录当前位置
    self.previousPreheatRect = preheatRect;
}

- (NSDictionary <RITLHorBrowseDifferencesKey*,NSArray<NSValue *>*> *)differencesBetweenRects:(CGRect)old new:(CGRect)new
{
    if (CGRectIntersectsRect(old, new)) {//如果区域交叉
        
        NSMutableArray <NSValue *> * added = [NSMutableArray arrayWithCapacity:10];
        if (CGRectGetMaxX(new) > CGRectGetMaxX(old)) {//表示左滑
            [added addObject:[NSValue valueWithCGRect:CGRectMake(CGRectGetMaxX(old), new.origin.y, CGRectGetMaxX(new) - CGRectGetMaxX(old), new.size.height)]];
        }
        
        if(CGRectGetMinX(old) > CGRectGetMinX(new)){//表示右滑
            
            [added addObject:[NSValue valueWithCGRect:CGRectMake(CGRectGetMinX(new), new.origin.y, CGRectGetMinX(old) - CGRectGetMinX(new), new.size.height)]];
        }
        
        NSMutableArray <NSValue *> * removed = [NSMutableArray arrayWithCapacity:10];
        if (CGRectGetMaxX(new) < CGRectGetMaxX(old)) {//表示右滑
            [removed addObject:[NSValue valueWithCGRect:CGRectMake(CGRectGetMinX(new), new.origin.y, CGRectGetMaxX(old) - CGRectGetMaxX(new), new.size.height)]];
        }
        
        if (CGRectGetMinX(old) < CGRectGetMinX(new)) {//表示左滑
            
            [removed addObject:[NSValue valueWithCGRect:CGRectMake(CGRectGetMinX(new), new.origin.y, CGRectGetMinX(new) - CGRectGetMinX(old), new.size.height)]];
        }
        
        return @{RITLHorBrowseDifferencesKeyAdded:added,
                 RITLHorBrowseDifferencesKeyRemoved:removed};
    }else {
        
        return @{RITLHorBrowseDifferencesKeyAdded:@[[NSValue valueWithCGRect:new]],
                 RITLHorBrowseDifferencesKeyRemoved:@[[NSValue valueWithCGRect:old]]};
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateCachedAssets];
    [self.collectionView.visibleCells makeObjectsPerformSelector:@selector(stop)];
}


#pragma mark - Getter
-(UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 2 * RITLPhotosHorBrowseCollectionSpace;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, RITLPhotosHorBrowseCollectionSpace, 0, RITLPhotosHorBrowseCollectionSpace);
        flowLayout.itemSize = @[@(RITL_SCREEN_WIDTH),@(RITL_SCREEN_HEIGHT)].ritl_size;

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-1 * RITLPhotosHorBrowseCollectionSpace, 0, self.ritl_width + 2 * RITLPhotosHorBrowseCollectionSpace, self.ritl_height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.blackColor;
        
        //初始化collectionView属性
        _collectionView.dataSource = self.dataSource;
        _collectionView.delegate = self;
        
        _collectionView.pagingEnabled = true;
        _collectionView.showsHorizontalScrollIndicator = false;
        
        //不使用自动适配
        if (@available(iOS 11.0,*)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return _collectionView;
}


- (UICollectionView *)browseCollectionView
{
    if (_browseCollectionView == nil)
    {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        flowLayout.minimumLineSpacing = 2 * RITLPhotosHorBrowseCollectionSpace;
        
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, RITLPhotosHorBrowseCollectionSpace, 0, RITLPhotosHorBrowseCollectionSpace);
//        flowLayout.itemSize = @[@(RITL_SCREEN_WIDTH),@(RITL_SCREEN_HEIGHT)].ritl_size;
        
        _browseCollectionView = [[UICollectionView alloc]initWithFrame:@[].ritl_rect collectionViewLayout:flowLayout];
        _browseCollectionView.backgroundColor = self.bottomView.backgroundColor;
        
        //初始化collectionView属性
//        _browseCollectionView.dataSource = self.dataSource;
//        _browseCollectionView.delegate = self;
        
        _browseCollectionView.hidden = true;
        _browseCollectionView.pagingEnabled = true;
        _browseCollectionView.showsHorizontalScrollIndicator = false;
        
        //不使用自动适配
        if (@available(iOS 11.0,*)) {
            _browseCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return _browseCollectionView;
}


#pragma mark - Notification

- (void)horBrowseTooBarChangedHiddenStateNotificationationHandler:(NSNotification *)notification
{
    NSNumber *hiddenResult = [notification.userInfo valueForKey:@"hidden"];
    
    if (hiddenResult) {
        
        self.topBar.hidden = self.bottomView.hidden = hiddenResult.boolValue;
        
    }else {
        
        BOOL beforeStatus = self.topBar.hidden;
        self.topBar.hidden = self.bottomView.hidden = !beforeStatus;
    }
}



@end
