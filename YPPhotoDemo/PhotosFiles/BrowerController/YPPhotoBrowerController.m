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
#import "UIKit+YPPhotoDemo.h"

static NSString * reuserIdentifier = @"YPPhotoBrowerCell";


@interface YPPhotoBrowerController ()

/// @brief 展示图片的collectionView
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
/// @brief 底部的tabBar
@property (nonatomic, strong) UITabBar * bottomBar;
/// @brief 顶部的bar
@property (nonatomic, strong)UINavigationBar * topBar;

/* Config */
@property (nonatomic, strong) UIColor * selectedColor;//仅表示选中的圆圈的颜色
@property (nonatomic, strong) UIColor * deselectedColor;

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
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[_browerDatasource.browerAssets indexOfObject:_browerDatasource.currentAsset] inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    
    [self setNumbersForSelectAssets];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController != nil)  self.navigationController.navigationBarHidden = true;
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_browerDelegate scrollViewEndDecelerating:_collectionView];
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
-(void)setBrowerDataSource:(id)assets currentAsset:(PHAsset *)currentAsset didSelectAssets:(NSMutableArray<PHAsset *> *)didSelectAssets status:(NSMutableArray<NSNumber *> *)status maxNumberOfSelectImages:(NSNumber *)maxNumber;
{
    //设置delegate
    _browerDelegate = [YPPhotoBrowerCDelegate borwerDelegateWithLinkViewController:self];
    
#ifdef __IPHONE_10_0
    
    _browerPreDataSource = [YPPhotoBrowerPreDataSource borwerPreDataSourceWithLinkViewController:self];
#endif
    
    //如果是集合对象
    if ([assets isMemberOfClass:[PHFetchResult class]])
    {
        //进行遍历
        [assets preparationWithType:PHAssetMediaTypeImage Complete:^(NSArray<PHAsset *> * _Nullable browerAssets) {

            //进行初始化
            _browerDatasource = [YPPhotoBrowerDataSource browerDataSourceWithCurrentAsset:currentAsset BrowerAssets:browerAssets selectAssets:didSelectAssets status:status browerViewController:self];
            
            _browerDatasource.maxNumberOfSelectImages = maxNumber;

        }];
    }

    //如果是点击预览进入
    else if([NSStringFromClass([assets class]) isEqualToString:@"__NSArrayM"])
    {
        //获得浏览的数据
        NSArray <PHAsset *> * browerAssets = [assets mutableCopy];
        
        _browerDatasource = [YPPhotoBrowerDataSource browerDataSourceWithCurrentAsset:currentAsset BrowerAssets:browerAssets selectAssets:didSelectAssets status:status browerViewController:self];
        
        _browerDatasource.maxNumberOfSelectImages = maxNumber;
    }
}






- (IBAction)sendButtonDidTap:(id)sender
{
    //如果没有选，默认为当前的照片 -  微信就是那么干的0.0 --
    if (_browerDatasource.didSelectAssets.count == 0)
    {
        [_browerDatasource.didSelectAssets addObject:_browerDatasource.currentAsset];
        NSUInteger statusInteger = (_browerDatasource.isHighQuality ? 2 : 0);
        [_browerDatasource.didSelectAssetStatus addObject:[NSNumber numberWithUnsignedInteger:statusInteger]];
    }
    
   //执行回调
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(photoBrowerController:photosSelected:Status:)])
    {
        [self.delegate photoBrowerController:self photosSelected:[_browerDatasource.didSelectAssets mutableCopy] Status:[_browerDatasource.didSelectAssetStatus mutableCopy]];
    }
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
        _collectionView.dataSource = _browerDatasource;
        _collectionView.delegate = _browerDelegate;
        
#ifdef __IPHONE_10_0
        
        _collectionView.prefetchDataSource = _browerPreDataSource;
#endif
        
        
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
        
        [_selectButtonItem addTarget:_browerDelegate action:NSSelectorFromString(@"selectButtonDidTap:") forControlEvents:UIControlEventTouchUpInside];
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
        [_highQualityControl addSubview:self.hignSignImageView];
        [_highQualityControl addSubview:self.originPhotoLabel];
        [_highQualityControl addSubview:self.activityIndicatorView];
        [_highQualityControl addSubview:self.photoSizeLabel];
        
        [_highQualityControl addTarget:_browerDelegate action:NSSelectorFromString(@"controlAction:") forControlEvents:UIControlEventTouchUpInside];
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
/** 设置当前选择后的资源数量 */
- (void)setNumbersForSelectAssets
{
    NSUInteger number = _browerDatasource.didSelectAssets.count;
    
    if (number == 0) {_numberOfLabel.hidden = true; return;}
    
    _numberOfLabel.hidden = false;
    _numberOfLabel.text = [NSString stringWithFormat:@"%@",@(number)];
    _numberOfLabel.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    //设置动画
    [UIView animateWithDuration:0.3 animations:^{
        
        _numberOfLabel.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }];

}


/** 显示高清信息 */
- (void)showHighQualityData
{
    if (!_browerDatasource.isHighQuality) return;
    
    [_activityIndicatorView startAnimating];
    
    //获取当前的资源对象
    PHAsset * currentAsset = _browerDatasource.currentAsset;
    
    //需要计算当前高清的大小
    [currentAsset sizeOfHignQualityWithSize:CGSizeMake(currentAsset.pixelWidth,currentAsset.pixelHeight) complete:^(NSString * size) {
        
        _photoSizeLabel.text = size;
        [_activityIndicatorView stopAnimating];
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

- (void)buttonDidSelect
{
    [self.selectButtonItem setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
}

- (void)buttonDidDeselect
{
    [self.selectButtonItem setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
}

@end
