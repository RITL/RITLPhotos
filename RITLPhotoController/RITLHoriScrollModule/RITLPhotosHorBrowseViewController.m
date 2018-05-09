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
#import <RITLKit.h>
#import <Masonry.h>

static NSString *const RITLBrowsePhotoKey = @"photo";
static NSString *const RITLBrowseLivePhotoKey = @"livephoto";
static NSString *const RITLBrowseVideoKey = @"video";

@interface RITLPhotosHorBrowseViewController ()<UICollectionViewDelegateFlowLayout,
                                                UICollectionViewDataSource>

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

@end

@implementation RITLPhotosHorBrowseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    [self.topBar addSubview:self.backButton];
    [self.topBar addSubview:self.statusButton];
    
    
    //进行布局
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.offset(0);
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
        make.height.mas_equalTo(RITL_DefaultTabBarHeight);
    }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return true;
}


- (void)pop
{
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
    
    
    
    return cell;
}


#pragma mark - Getter
-(UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-5, 0, self.ritl_width + 10, self.ritl_height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        
        //初始化collectionView属性
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.pagingEnabled = true;
        _collectionView.showsHorizontalScrollIndicator = false;
        
        [_collectionView registerClass:[RITLPhotosBrowseImageCell class] forCellWithReuseIdentifier:@"image"];
    }
    
    return _collectionView;
}

@end
