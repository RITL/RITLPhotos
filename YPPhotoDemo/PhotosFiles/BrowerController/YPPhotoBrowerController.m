//
//  YPPhotoBrowerController.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotoBrowerController.h"
#import "YPPhotoBrowerCell.h"
#import "PHObject+SupportCategory.h"
#import "YPPhotoDemo-Swift.h"


static NSString * reuserIdentifier = @"YPPhotoBrowerCell";


@interface YPPhotoBrowerController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    //标志第一次进入
    NSUInteger index;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

/* Config */
@property (nonatomic, strong) UIColor * selectedColor;//仅表示选中的圆圈的颜色
@property (nonatomic, strong) UIColor * deselectedColor;
@property (nonatomic, assign) BOOL isHighQuality;
@property (nonatomic, strong) NSNumber * maxNumberOfSelectImages;


/* Data */
/// @brief 当前的资源对象
@property (nonatomic, strong) PHAsset * currentAsset;
/// @brief 存放所有的资源
@property (nonatomic, strong) PHFetchResult * assets;
/// @brief 存放可以游览的资源数组
@property (nonatomic, copy)NSArray <PHAsset *> * browerAssets;
/// @brief 存储之前已经选择的资源
@property (nonatomic, strong)NSMutableArray <PHAsset *> * didSelectAssets;
@property (nonatomic, strong)NSMutableArray <NSNumber *> * didSelectAssetStatus;

/* View */
/// @brief 顶部的bar
@property (nonatomic, strong)UINavigationBar * topBar;
/// @brief 返回
@property (nonatomic, strong)UIButton * backButtonItem;
/// @brief 选择
@property (nonatomic, strong)UIButton * selectButtonItem;

/// @brief 底部的tabBar
@property (nonatomic, strong)UITabBar * bottomBar;
/// @brief 高清图的响应Control
@property (strong, nonatomic) IBOutlet UIControl * highQualityControl;
/// @brief 选中圆圈
@property (strong, nonatomic) IBOutlet UIImageView * hignSignImageView;
/// @brief 原图:
@property (strong, nonatomic) IBOutlet UILabel * originPhotoLabel;
/// @brief 等待风火轮
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * activityIndicatorView;
/// @brief 照片大小
@property (strong, nonatomic) IBOutlet UILabel *photoSizeLabel;
/// @brief 发送按钮
@property (strong, nonatomic) UIButton * sendButton;
/// @brief 显示数目
@property (strong, nonatomic) UILabel * numberOfLabel;

@end

@implementation YPPhotoBrowerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化各种选择的颜色
    self.selectedColor = UIColorFromRGB(0x2dd58a);
    self.deselectedColor = [UIColor darkGrayColor];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.bottomBar];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[self.browerAssets indexOfObject:self.currentAsset] inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    
    [self setNumbersForSelectAssets:_didSelectAssets.count];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController != nil)  self.navigationController.navigationBarHidden = true;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollViewDidEndDecelerating:self.collectionView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController != nil) self.navigationController.navigationBarHidden = false;
}

-(BOOL)prefersStatusBarHidden
{
    return true;
}

-(void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    NSLog(@"YPPhotoBrowerController Dealloc");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backItemDidTap:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(photoBrowerControllerShouldBack:)])
    {
        [self.delegate photoBrowerControllerShouldBack:self];
    }
    
    [self.navigationController popViewControllerAnimated:true];
}



#pragma mark - Setter
-(void)setAssets:(PHFetchResult *)assets
{
    _assets = assets;
    
    __weak typeof(self) weakSelf = self;
    
    [_assets preparationWithType:PHAssetMediaTypeImage Complete:^(NSArray<PHAsset *> * _Nullable shouldBowerAssets) {
       
        weakSelf.browerAssets = shouldBowerAssets;
        
    }];
    
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.browerAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPPhotoBrowerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YPPhotoBrowerCell class]) forIndexPath:indexPath];
    
    //config the cell
    [self.browerAssets[indexPath.item] representationImageWithSize:CGSizeMake(60, 60) complete:^(UIImage * _Nullable image, PHAsset * _Nonnull asset) {
       
        cell.imageView.image = image;
        
    }];
    
    
    //更新标志位
    if ([self.didSelectAssets containsObject:self.browerAssets[indexPath.item]]) [self buttonDidSelect];
    
    else [self buttonDidDeselect];
    
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    return CGSizeMake(screenBounds.size.width + 10, screenBounds.size.height);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}



#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UICollectionView * collectionView = (UICollectionView *)scrollView;
    
    //获得偏移量
    CGFloat contentOffSet = collectionView.contentOffset.x;
    
    //计算偏移量的倍数
    NSUInteger indexSet = contentOffSet / (collectionView.bounds.size.width);
    
    //获取当前资源
    PHAsset * asset = self.browerAssets[indexSet];
    
    //获得当前Cell
    YPPhotoBrowerCell * cell = (YPPhotoBrowerCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexSet inSection:0]];
    
    if (![self.currentAsset isEqual:asset] || index == 0)
    {
        //设置当前asset
        self.currentAsset = asset;
        
        //设置图片
        [self.currentAsset representationImageWithSize:cell.frame.size complete:^(UIImage * _Nullable image, PHAsset * _Nonnull asset) {
            
            cell.imageView.image = image;
            
        }];
        
        //清除显示的大小
        self.photoSizeLabel.text = @"";
        [self showHighQualityData];
        
        index++;
    }
}


#pragma mark - Action
- (IBAction)selectButtonDidTap:(id)sender
{
    if ([self.didSelectAssets containsObject:self.currentAsset])//表示已经选过,应该取消
    {
        //移除标志位
        [self.didSelectAssetStatus removeObjectAtIndex:[self.didSelectAssets indexOfObject:self.currentAsset]];
        //移除数据
        [self.didSelectAssets removeObject:self.currentAsset];
        //更新UI
        [self buttonDidDeselect];
    }
    
    else//表示选择
    {
        if (self.didSelectAssets.count >= self.maxNumberOfSelectImages.unsignedIntegerValue)
        {
            [self alertControllerShouldPresent];
        }
        
        else{
            
            [self.didSelectAssets addObject:self.currentAsset];
            
            //如果是高清图模式
            if (self.isHighQuality) [self.didSelectAssetStatus addObject:[NSNumber numberWithUnsignedInteger:2]];
            else [self.didSelectAssetStatus addObject:[NSNumber numberWithUnsignedInteger:0]];
            
            //updateUI
            [self buttonDidSelect];
        }

    }
    
    [self setNumbersForSelectAssets:self.didSelectAssets.count];
}


- (void)buttonDidSelect
{
//    [self.selectButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    [self.selectButtonItem setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
}

- (void)buttonDidDeselect
{
//    [self.selectButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.selectButtonItem setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
}


- (void)controlAction:(UIControl *)sender
{
    self.isHighQuality = !self.isHighQuality;
    
    if (self.isHighQuality)//是高清
    {
        [self changeHightQualityStatus];
        [self showHighQualityData];
        
        //如果含有此时的照片
        if ([self.didSelectAssets containsObject:self.currentAsset])//标志位进行替换
        {
            [self.didSelectAssetStatus replaceObjectAtIndex:[self.didSelectAssets indexOfObject:self.currentAsset] withObject:[NSNumber numberWithUnsignedInteger:2]];//更新标志位
        }
        
        else//如果不含有此照片
        {
            if (!(self.didSelectAssets.count >= self.maxNumberOfSelectImages.unsignedIntegerValue))//没有达到选择上限
            {
                //进行添加
                [self.didSelectAssets addObject:self.currentAsset];
                [self.didSelectAssetStatus addObject:[NSNumber numberWithUnsignedInteger:2]];
                //修改UI
                [self buttonDidSelect];//选中
            }

        }
    }
    
    else//变成不是高清图
    {
        [self changeDehightQualityStatus];
        //如果含有照片
        if ([self.didSelectAssets containsObject:self.currentAsset])
        {
            //替换标志位
            [self.didSelectAssetStatus replaceObjectAtIndex:[self.didSelectAssets indexOfObject:self.currentAsset] withObject:[NSNumber numberWithUnsignedInteger:0]];
        }
    }
    
    [self setNumbersForSelectAssets:self.didSelectAssets.count];
}


/** 显示高清信息 */
- (void)showHighQualityData
{
    if (!_isHighQuality) return;
    
    __weak typeof(self) weakSelf = self;
    
    [self.activityIndicatorView startAnimating];
    
    //需要计算当前高清的大小
    [self.currentAsset sizeOfHignQualityWithSize:CGSizeMake(self.currentAsset.pixelWidth,self.currentAsset.pixelHeight) complete:^(NSString * size) {
        
        weakSelf.photoSizeLabel.text = size;
        [weakSelf.activityIndicatorView stopAnimating];
    }];
}


/** 转变为高清图状态 */
- (void)changeHightQualityStatus
{
    self.hignSignImageView.backgroundColor = self.selectedColor;
    self.originPhotoLabel.textColor = [UIColor whiteColor];
    self.photoSizeLabel.textColor = [UIColor whiteColor];
    [self.activityIndicatorView startAnimating];
    NSLog(@"高清图!");
}


/** 转变为非高清图状态 */
- (void)changeDehightQualityStatus
{
    self.hignSignImageView.backgroundColor = self.deselectedColor;
    self.originPhotoLabel.textColor = self.deselectedColor;
    self.photoSizeLabel.textColor = self.deselectedColor;
    [self.activityIndicatorView stopAnimating];
    self.photoSizeLabel.text = @"";
    
}


- (IBAction)sendButtonDidTap:(id)sender
{
    //如果没有选，默认为当前的照片 -  微信就是那么干的0.0 --
    if (self.didSelectAssets.count == 0)
    {
        [self.didSelectAssets addObject:self.currentAsset];
        NSUInteger statusInteger = (self.isHighQuality ? 2 : 0);
        [self.didSelectAssetStatus addObject:[NSNumber numberWithUnsignedInteger:statusInteger]];
    }
    
   //执行回调
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(photoBrowerController:photosSelected:Status:)])
    {
        [self.delegate photoBrowerController:self photosSelected:[self.didSelectAssets mutableCopy] Status:[self.didSelectAssetStatus mutableCopy]];
    }
}


#pragma mark - Alert
- (void)alertControllerShouldPresent
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"你最多只能选择%@张照片",@(_maxNumberOfSelectImages.unsignedIntegerValue)] message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:true completion:nil];
}



#pragma mark - Create Views
-(UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width + 10, self.height) collectionViewLayout:flowLayout];
        //初始化collectionView属性
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = true;
        _collectionView.showsHorizontalScrollIndicator = false;
        [_collectionView registerClass:[YPPhotoBrowerCell class] forCellWithReuseIdentifier:reuserIdentifier];
    }
    
    return _collectionView;
}


-(UINavigationBar *)topBar
{
    if (_topBar == nil)
    {
        _topBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
        _topBar.barStyle = UIBarStyleBlack;
        [_topBar setViewColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        
        [_topBar addSubview:self.backButtonItem];
        [_topBar addSubview:self.selectButtonItem];
    }
    
    return _topBar;
}

-(UIButton *)backButtonItem
{
    if (_backButtonItem == nil)
    {
        _backButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 45, 30)];
        _backButtonItem.center = CGPointMake(_backButtonItem.center.x, _topBar.center.y);
        [_backButtonItem setTitle:@"<" forState:UIControlStateNormal];
        [_backButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButtonItem.titleLabel setFont:[UIFont systemFontOfSize:30]];
        [_backButtonItem.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_backButtonItem addTarget:self action:@selector(backItemDidTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backButtonItem;
}


-(UIButton *)selectButtonItem
{
    if(_selectButtonItem == nil)
    {
        _selectButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(_topBar.width - 35, 0, 25, 25)];
        _selectButtonItem.center = CGPointMake(_selectButtonItem.center.x, _topBar.center.y + 4);
        [_selectButtonItem setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [_selectButtonItem addTarget:self action:@selector(selectButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _selectButtonItem;
}

-(UITabBar *)bottomBar
{
    if (_bottomBar == nil)
    {
        _bottomBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, self.height - 44, self.width, 44)];
        _bottomBar.barStyle = UIBarStyleBlack;
        [_bottomBar setViewColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        
        [_bottomBar addSubview:self.highQualityControl];
        [_bottomBar addSubview:self.sendButton];
        [_bottomBar addSubview:self.numberOfLabel];
    }
    
    return _bottomBar;
}

-(UIControl *)highQualityControl
{
    if (_highQualityControl == nil)
    {
        _highQualityControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 150, _bottomBar.height)];
        [_highQualityControl addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_highQualityControl addSubview:self.hignSignImageView];
        [_highQualityControl addSubview:self.originPhotoLabel];
        [_highQualityControl addSubview:self.activityIndicatorView];
        [_highQualityControl addSubview:self.photoSizeLabel];
    }
    
    return _highQualityControl;
}

-(UIImageView *)hignSignImageView
{
    if (_hignSignImageView == nil)
    {
        _hignSignImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 15, 15)];
        _hignSignImageView.center = CGPointMake(_hignSignImageView.center.x, _highQualityControl.center.y);
        _hignSignImageView.layer.cornerRadius = _hignSignImageView.bounds.size.width / 2.0f;
        _hignSignImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _hignSignImageView.layer.borderWidth = 1.0f;
    }
    
    return _hignSignImageView;
}


-(UILabel *)originPhotoLabel
{
    if (_originPhotoLabel == nil)
    {
        _originPhotoLabel = [[UILabel alloc]initWithFrame:CGRectMake(_hignSignImageView.maxX + 5, 0, 30, 25)];
        _originPhotoLabel.center = CGPointMake(_originPhotoLabel.center.x, _highQualityControl.center.y);
        _originPhotoLabel.font = [UIFont systemFontOfSize:13];
        _originPhotoLabel.textColor = self.deselectedColor;
        _originPhotoLabel.text = @"原图:";
    }
    
    return _originPhotoLabel;
}

-(UIActivityIndicatorView *)activityIndicatorView
{
    if (_activityIndicatorView == nil)
    {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.frame = CGRectMake(_originPhotoLabel.maxX + 5, 0, 15, 15);
        _activityIndicatorView.center = CGPointMake(_activityIndicatorView.center.x, _highQualityControl.center.y);
        _activityIndicatorView.hidesWhenStopped = true;
    }
    
    return _activityIndicatorView;
}

-(UILabel *)photoSizeLabel
{
    if (_photoSizeLabel == nil)
    {
        _photoSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_originPhotoLabel.maxX + 5, 0, _highQualityControl.width - _photoSizeLabel.originX , 25)];
        _photoSizeLabel.center = CGPointMake(_photoSizeLabel.center.x, _highQualityControl.center.y);
        _photoSizeLabel.font = [UIFont systemFontOfSize:13];
        _photoSizeLabel.textColor = self.deselectedColor;
        _photoSizeLabel.text = @"";
    }
    
    return _photoSizeLabel;
}

-(UIButton *)sendButton
{
    if (_sendButton == nil)
    {
        _sendButton = [[UIButton alloc]initWithFrame:CGRectMake(_bottomBar.width - 50 - 5, 0, 50, 40)];
        _sendButton.center = CGPointMake(_sendButton.center.x, _bottomBar.center.y - _bottomBar.originY);
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_sendButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [_sendButton addTarget:self action:@selector(sendButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sendButton;
}

-(UILabel *)numberOfLabel
{
    if (_numberOfLabel == nil)
    {
        _numberOfLabel = [[UILabel alloc]initWithFrame:CGRectMake(_sendButton.originX - 20, 0, 20, 20)];
        _numberOfLabel.center = CGPointMake(_numberOfLabel.center.x, _sendButton.center.y);
        _numberOfLabel.backgroundColor = self.selectedColor;
        _numberOfLabel.textAlignment = NSTextAlignmentCenter;
        _numberOfLabel.font = [UIFont boldSystemFontOfSize:14];
        _numberOfLabel.text = @"8";
        _numberOfLabel.textColor = [UIColor whiteColor];
        _numberOfLabel.layer.cornerRadius = _numberOfLabel.width / 2.0;
        _numberOfLabel.clipsToBounds = true;
    }
    
    return _numberOfLabel;
}

#pragma mark - 设置numberOfLabel的数目
- (void)setNumbersForSelectAssets:(NSUInteger)number
{
    if (number == 0) {_numberOfLabel.hidden = true; return;}
    
    _numberOfLabel.text = [NSString stringWithFormat:@"%@",@(number)];
    
    //设置动画
//    [UIView ];
    
//    _numberOfLabel.hidden = false;
}


@end
