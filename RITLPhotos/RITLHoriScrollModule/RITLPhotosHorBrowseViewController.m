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
#import "NSBundle+RITLPhotos.h"
#import "PHAsset+RITLPhotos.h"
#import <RITLKit/RITLKit.h>
#import <RITLViewFrame/UIView+RITLFrameChanged.h>
#import <Masonry/Masonry.h>
#import "RITLPhotosMaker.h"
#import "RITLPhotosDataManager.h"
#import "RITLPhotosConfiguration.h"
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
/// 显示索引的标签
@property (strong, nonatomic) IBOutlet UILabel *indexLabel;
/// 展示图片的collectionView
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
/// 底部的视图
@property (nonatomic, strong) RITLPhotosBottomView *bottomView;
/// 用于计算缓存的位置
@property (nonatomic, assign) CGRect previousPreheatRect;
/// 预览的collectionView
@property (nonatomic, strong) UICollectionView *browseCollectionView;

// Data
@property (nonatomic, strong) RITLPhotosDataManager *dataManager;

@end

@implementation RITLPhotosHorBrowseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.dataManager = RITLPhotosDataManager.sharedInstance;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.previousPreheatRect = CGRectZero;
    [self resetCachedAssets];
    
    self.bottomView = RITLPhotosBottomView.new;
    self.bottomView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.8];
    
    self.bottomView.previewButton.hidden = true;//暂时屏蔽掉图片编辑功能
    
    self.bottomView.fullImageButton.selected = self.dataManager.isHightQuality;
    [self.bottomView.fullImageButton addTarget:self
                                        action:@selector(hightQualityShouldChanged:)
                              forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView.sendButton addTarget:self
                                   action:@selector(sendButtonDidClick:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.collectionView];
    
    //进行注册
    [self.collectionView registerClass:RITLPhotosBrowseImageCell.class forCellWithReuseIdentifier:RITLBrowsePhotoKey];
    [self.collectionView registerClass:RITLPhotosBrowseVideoCell.class forCellWithReuseIdentifier:RITLBrowseVideoKey];
    if (@available(iOS 9.1,*)) {
        
        [self.collectionView registerClass:RITLPhotosBrowseLiveCell.class forCellWithReuseIdentifier:RITLBrowseLivePhotoKey];
    }

    
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
        [view setImage:NSBundle.ritl_browse_back/*@"RITLPhotos.bundle/ritl_browse_back".ritl_image*/ forState:UIControlStateNormal];
        view;
    });
    
    self.statusButton = ({
        
        UIButton *view = [UIButton new];
        view.adjustsImageWhenHighlighted = false;
        view.backgroundColor = [UIColor clearColor];
        view.imageEdgeInsets = UIEdgeInsetsMake(10, 11, 0, 0);
        [view setImage:NSBundle.ritl_brower_selected/*@"RITLPhotos.bundle/ritl_brower_selected".ritl_image*/ forState:UIControlStateNormal];
        [view addTarget:self action:@selector(assetStatusDidChanged:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    self.indexLabel = ({
        
        UILabel *label = [UILabel new];
        label.backgroundColor = RITLColorFromIntRBG(9, 187, 7);
        label.text = @"0";
        label.font = RITLUtilityFont(RITLFontPingFangSC_Regular, 15);
        label.textColor = UIColor.whiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 30 / 2.0;
        label.layer.masksToBounds = true;
        label.hidden = true;
        label;
    });
    
    
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.browseCollectionView];
    [self.topBar addSubview:self.backButton];
    [self.topBar addSubview:self.statusButton];
    [self.topBar addSubview:self.indexLabel];
    
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
        
        make.right.inset(15);
        make.width.height.mas_equalTo(40);
        make.bottom.inset(10);
    }];
    
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(30);
        make.bottom.inset(10);
        make.right.inset(15);
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
        
        [self updateTopViewWithAsset:[self.dataSource assetAtIndexPath:self.dataSource.defaultItemIndexPath]];
    }
    
    //接收cell的单击通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(horBrowseTooBarChangedHiddenStateNotificationationHandler:) name:RITLHorBrowseTooBarChangedHiddenStateNotification object:nil];
    
    //KVO
    [self.dataManager addObserver:self forKeyPath:@"count" options:NSKeyValueObservingOptionNew context:nil];
    [self.dataManager addObserver:self forKeyPath:@"hightQuality" options:NSKeyValueObservingOptionNew context:nil];
    
    //更新发送按钮
    [self updateBottomSendButton];
    [self updateBrowseCollectionView];
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
    self.backHandler();
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
    if (self.isViewLoaded) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.dataManager removeObserver:self forKeyPath:@"count"];
        [self.dataManager removeObserver:self forKeyPath:@"hightQuality"];
    }
    
    NSLog(@"[%@] is dealloc",NSStringFromClass(self.class));
}

- (void)pop
{
    [self.collectionView.visibleCells makeObjectsPerformSelector:@selector(stop)];
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Cache

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
    
    //进行计算当前第几个位置
    [self adjustScrollIndexWithContentOffset:scrollView.contentOffset scrollView:scrollView];
}


/// 进行计算当前第几个位置
- (void)adjustScrollIndexWithContentOffset:(CGPoint)contentOffset scrollView:(UIScrollView *)scrollView
{
    //根据四舍五入获得的index
    NSInteger index = [self indexOfCurrentAsset:scrollView];
    
    //获得资源
    PHAsset *currentAsset = [self.dataSource assetAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    [self updateTopViewWithAsset:currentAsset];
}


/// 根据偏移量获得当前响应到资源
- (NSInteger)indexOfCurrentAsset:(UIScrollView *)scrollView
{
    //获得当前正常位置的偏移量
    CGFloat contentOffsetX = MIN(MAX(0,scrollView.contentOffset.x),scrollView.contentSize.width);
    
    CGFloat space = 2 * RITLPhotosHorBrowseCollectionSpace;
    
    //根据四舍五入获得的index
    NSInteger index = @(round((contentOffsetX + space) * 1.0 / (space + RITL_SCREEN_WIDTH))).integerValue;
    
    return index;
}

#pragma mark - Update View

- (void)updateTopViewWithAsset:(PHAsset *)asset
{
    BOOL isSelected = [self.dataManager containAsset:asset];
    
    RITLPhotosConfiguration *configuration = RITLPhotosConfiguration.defaultConfiguration;
    
    if (!configuration.containVideo) {  //如果不包含视频
        
        self.statusButton.hidden = (asset.mediaType == PHAssetMediaTypeVideo);
    }
    
    //进行属性隐藏设置
    self.indexLabel.hidden = !isSelected;
    
    if (isSelected) {
        
        self.indexLabel.text = @([self.dataManager.assetIdentiers indexOfObject:asset.localIdentifier] + 1).stringValue;
    }
}


/// 更新发送按钮
- (void)updateBottomSendButton
{
    NSInteger count = self.dataManager.count;
    
    UIControlState state = (count == 0 ? UIControlStateDisabled : UIControlStateNormal);
    
    NSString *title = (count == 0 ? @"发送" : [NSString stringWithFormat:@"发送(%@)",@(count)]);
    
    self.bottomView.sendButton.enabled = !(count == 0);
    [self.bottomView.sendButton setTitle:title forState:state];
}


/// 更新排版集合视图的状态
- (void)updateBrowseCollectionView
{
//    NSInteger count = self.dataManager.count;
//    self.browseCollectionView.hidden = (count == 0);
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

#pragma mark - < UICollectionViewDelegate >

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [cell reset];
}


#pragma mark - Notification

- (void)horBrowseTooBarChangedHiddenStateNotificationationHandler:(NSNotification *)notification
{
    NSNumber *hiddenResult = [notification.userInfo valueForKey:@"hidden"];
    
    if (hiddenResult) {//存在控制
        
        /*self.browseCollectionView.hidden = */self.topBar.hidden = self.bottomView.hidden = hiddenResult.boolValue;
        
        if (hiddenResult.boolValue == false) {//如果是显示，需要更新状态
            [self updateBrowseCollectionView];
        }
        
    }else {
        
        BOOL beforeStatus = self.topBar.hidden;
        /*self.browseCollectionView.hidden = */self.topBar.hidden = self.bottomView.hidden = !beforeStatus;
        
        if (beforeStatus) {//如果是需要展示
            [self updateBrowseCollectionView];
        }
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"count"] && [object isEqual:self.dataManager]) {

        // 预览功能现在是屏蔽状态
        //self.bottomView.previewButton.enabled = !(count == 0);
        
        //发送按钮
        [self updateBottomSendButton];
        
        //选中的排版视图
        [self updateBrowseCollectionView];
    }
    
    else if([keyPath isEqualToString:@"hightQuality"] && [object isEqual:self.dataManager]){
        
        BOOL hightQuality = [change[NSKeyValueChangeNewKey] boolValue];
        self.bottomView.fullImageButton.selected = hightQuality;
    }
}


#pragma mark - action

- (void)hightQualityShouldChanged:(UIButton *)sender
{
    self.dataManager.hightQuality = !self.dataManager.hightQuality;
}


- (void)sendButtonDidClick:(UIButton *)sender
{
    [RITLPhotosMaker.sharedInstance startMakePhotosComplete:^{
       
        [self.collectionView.visibleCells makeObjectsPerformSelector:@selector(stop)];
        [self.navigationController dismissViewControllerAnimated:true completion:nil];
    }];
}


- (void)assetStatusDidChanged:(UIButton *)sender
{
    //获得当前的资源
    PHAsset *asset = [self.dataSource assetAtIndexPath:[NSIndexPath indexPathForItem:[self indexOfCurrentAsset:self.collectionView] inSection:0]];
    
    //如果是添加，需要坚持数量
    if (self.dataManager.count >= RITLPhotosConfiguration.defaultConfiguration.maxCount &&
        ![self.dataManager containAsset:asset]/*是添加*/) { return; }//不能进行选择
    
    //进行修正
    [self.dataManager addOrRemoveAsset:asset];
    
    //更新top
    [self updateTopViewWithAsset:asset];
}

@end


