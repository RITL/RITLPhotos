//
//  RITLPhotoBrowerController.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPhotoBrowseController.h"
#import "RITLPhotoBrowseViewModel.h"
#import "RITLPhotoBrowseCell.h"

#import "UIKit+YPPhotoDemo.h"
#import "UIButton+RITLBlockButton.h"
#import "UIViewController+RITLPhotoAlertController.h"

#import <objc/runtime.h>
#import <objc/message.h>

#define RITLPhotoBrowerDeselectedColor ([UIColor darkGrayColor])
#define RITLPhotoBrowerSelectedColor (UIColorFromRGB(0x2dd58a))

static NSString * const cellIdentifier = @"RITLPhotoBrowerCell";

@interface RITLPhotoBrowseController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

/// @brief 展示图片的collectionView
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

/// @brief 底部的tabBar
@property (nonatomic, strong) UITabBar * bottomBar;

/// @brief 顶部的bar
@property (nonatomic, strong)UINavigationBar * topBar;

/// @brief 返回
@property (nonatomic, strong)UIButton * backButtonItem;

/// @brief 选择
@property (nonatomic, strong)UIButton * selectButtonItem;

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

@implementation RITLPhotoBrowseController


-(instancetype)initWithViewModel:(id <RITLCollectionViewModel> )viewModel
{
    if (self = [super init])
    {
        _viewModel = viewModel;
    }
    
    return self;
}


+(instancetype)photosViewModelInstance:(id <RITLCollectionViewModel> )viewModel
{
    return [[self alloc] initWithViewModel:viewModel];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //绑定viewModel
    [self bindViewModel];
    
    //添加集合视图
    [self.view addSubview:self.collectionView];
    
    //添加自定义导航栏
    [self.view addSubview:self.topBar];
    
    //添加自定义tab
    [self.view addSubview:self.bottomBar];
    
    //滚动到最后一个
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:((RITLPhotoBrowseViewModel *)self.viewModel).currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    
    //检测选择的数量
    ((void(*)(id,SEL))objc_msgSend)(self.viewModel,NSSelectorFromString(@"ritl_checkPhotoSendStatusChanged"));
    
    //检测高清状态
    ((void(*)(id,SEL))objc_msgSend)(self.viewModel,NSSelectorFromString(@"ritl_checkHightQuaratyStatus"));
}


-(BOOL)prefersStatusBarHidden
{
    return true;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController != nil)
    {
        self.navigationController.navigationBarHidden = true;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //执行viewModel
    [self scrollViewDidEndDecelerating:self.collectionView];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.navigationController != nil)
    {
        self.navigationController.navigationBarHidden = false;
    }
    
    
    ((void(*)(id,SEL))objc_msgSend)(self.viewModel,NSSelectorFromString(@"controllerViewWillDisAppear"));
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    NSLog(@"Dealloc %@",NSStringFromClass([self class]));
}



#pragma mark - lazy

#pragma mark - Create Views
-(UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-5, 0, self.width + 10, self.height) collectionViewLayout:flowLayout];
        //初始化collectionView属性
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
//        _collectionView
        
#ifdef __IPHONE_10_0
        
//        _collectionView.prefetchDataSource = _browerPreDataSource;
#endif
        
        
        _collectionView.pagingEnabled = true;
        _collectionView.showsHorizontalScrollIndicator = false;
        [_collectionView registerClass:[RITLPhotoBrowseCell class] forCellWithReuseIdentifier:cellIdentifier];
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
        _backButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 44, 44)];
        _backButtonItem.center = CGPointMake(_backButtonItem.center.x, _topBar.center.y);
        [_backButtonItem setImage:[UIImage imageNamed:@"RITLPhotoBack"] forState:UIControlStateNormal];
        [_backButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButtonItem.titleLabel setFont:[UIFont systemFontOfSize:30]];
        [_backButtonItem.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        __weak typeof(self) weakSelf = self;
        
        [_backButtonItem controlEvents:UIControlEventTouchUpInside handle:^(UIControl * _Nonnull sender) {
           
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf.navigationController popViewControllerAnimated:true];
            
        }];
    }
    
    return _backButtonItem;
}


-(UIButton *)selectButtonItem
{
    if(_selectButtonItem == nil)
    {
        _selectButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(_topBar.width - 44 - 10, 0, 44, 44)];
        [_selectButtonItem setImageEdgeInsets:UIEdgeInsetsMake(12, 10, 8, 10)];
        _selectButtonItem.center = CGPointMake(_selectButtonItem.center.x, _topBar.center.y);
        [_selectButtonItem setImage:RITLPhotoDeselectedImage forState:UIControlStateNormal];
        
        __weak typeof(self) weakSelf = self;
        
        [_selectButtonItem controlEvents:UIControlEventTouchUpInside handle:^(UIControl * _Nonnull sender) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [((RITLPhotoBrowseViewModel *)strongSelf.viewModel) selectedPhotoInScrollView:strongSelf.collectionView];
            
        }];
        
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

        
        __weak typeof(self) weakSelf = self;
        
        [_highQualityControl controlEvents:UIControlEventTouchUpInside handle:^(UIControl * _Nonnull sender) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [((RITLPhotoBrowseViewModel *)strongSelf.viewModel) highQualityStatusShouldChanged:strongSelf.collectionView];
            
        }];
        
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
        //计算字的大小
        NSAttributedString * constWord = [[NSAttributedString alloc]initWithString:@"原图:" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        
        CGFloat width = [constWord boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
        
        _originPhotoLabel = [[UILabel alloc]initWithFrame:CGRectMake(_hignSignImageView.maxX + 5, 0, width, 25)];
        _originPhotoLabel.center = CGPointMake(_originPhotoLabel.center.x, _highQualityControl.center.y);
        _originPhotoLabel.font = [UIFont systemFontOfSize:13];
        _originPhotoLabel.textColor = RITLPhotoBrowerDeselectedColor;
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
        _photoSizeLabel.textColor = RITLPhotoBrowerDeselectedColor;
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
        
        __weak typeof(self) weakSelf = self;
        
        [_sendButton controlEvents:UIControlEventTouchUpInside handle:^(UIControl * _Nonnull sender) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            
            ((void(*)(id,SEL,id))objc_msgSend)(strongSelf.viewModel,NSSelectorFromString(@"photoDidSelectedComplete:"),strongSelf.collectionView);
            
        }];
    }
    
    return _sendButton;
}



-(UILabel *)numberOfLabel
{
    if (_numberOfLabel == nil)
    {
        _numberOfLabel = [[UILabel alloc]initWithFrame:CGRectMake(_sendButton.originX - 20, 0, 20, 20)];
        _numberOfLabel.center = CGPointMake(_numberOfLabel.center.x, _sendButton.center.y);
        _numberOfLabel.textAlignment = NSTextAlignmentCenter;
        _numberOfLabel.font = [UIFont boldSystemFontOfSize:14];
        _numberOfLabel.text = @"8";
        _numberOfLabel.backgroundColor = UIColorFromRGB(0x2dd58a);
        _numberOfLabel.textColor = [UIColor whiteColor];
        _numberOfLabel.layer.cornerRadius = _numberOfLabel.width / 2.0;
        _numberOfLabel.clipsToBounds = true;
        
        _numberOfLabel.hidden = true;
    }
    
    return _numberOfLabel;
}


#pragma mark - ViewModel

-(id<RITLCollectionViewModel>)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [RITLPhotoBrowseViewModel new];
    }
    
    return _viewModel;
}


/// 绑定viewModel
- (void)bindViewModel
{
    if ([self.viewModel isMemberOfClass:[RITLPhotoBrowseViewModel class]])
    {
        RITLPhotoBrowseViewModel * viewModel = self.viewModel;
        
        __weak typeof(self) weakSelf = self;
        
        // 显示清晰图的回调
        viewModel.ritl_BrowerCellShouldRefreshBlock = ^(UIImage * image,PHAsset * asset,NSIndexPath * indexPath){
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
        
            RITLPhotoBrowseCell * cell = (RITLPhotoBrowseCell *)[strongSelf.collectionView cellForItemAtIndexPath:indexPath];

    
            [UIView animateWithDuration:0.5 delay:0. options:UIViewAnimationOptionCurveLinear animations:^{
    
                cell.imageView.image = image;
                
            } completion:nil];
        };
        
        
        
        // 刷新选中按钮状态
        viewModel.ritl_BrowerSelectedBtnShouldRefreshBlock = ^(UIImage * image){
          
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf.selectButtonItem setImage:image forState:UIControlStateNormal];
        };
        
        
        // 弹出警告提示框
        viewModel.warningBlock = ^(BOOL result,NSUInteger maxCount){
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf presentAlertController:maxCount];
        };
        
        // 模态弹出
        viewModel.dismissBlock = ^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf dismissViewController];
            
        };
        
        // 显示选择的数量
        viewModel.ritl_BrowerSendStatusChangedBlock = ^(BOOL hiddenNumberLabel,NSUInteger count){
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf updateNumbersForSelectAssets:count];
        };
        
        
        
        
        
        // hight quarity
        viewModel.ritl_browerQuarityChangedBlock = ^(BOOL isHightQuarity){
          
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf updateSizeLabelForIsHightQuarity:isHightQuarity];
        };
        
        
        viewModel.ritl_browerRequestQuarityBlock = ^(BOOL result,NSString * selectorName){
          
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            ((void(*)(id,SEL))objc_msgSend)(strongSelf.activityIndicatorView,NSSelectorFromString(selectorName));
            
            strongSelf.photoSizeLabel.hidden = result;
        };
        
        
        viewModel.ritl_browerQuarityCompleteBlock = ^(NSString * imageSize){
          
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            strongSelf.photoSizeLabel.text = imageSize;
            
        };
        
    }
}

-(void)dismissViewController
{
    return [super dismissViewControllerAnimated:true completion:nil];
}




#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel numberOfItemsInSection:section];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RITLPhotoBrowseCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([self.viewModel isMemberOfClass:[RITLPhotoBrowseViewModel class]])
    {
        RITLPhotoBrowseViewModel * viewModel = self.viewModel;
        
        [viewModel imageForIndexPath:indexPath collection:collectionView isThumb:true complete:^(UIImage * _Nonnull image, PHAsset * _Nonnull asset) {
            
            cell.imageView.image = image;
            
        }];
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.viewModel sizeForItemAtIndexPath:indexPath inCollection:collectionView];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return [self.viewModel minimumInteritemSpacingForSectionAtIndex:section];
}


#pragma mark - UICollectionDelegate

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    Nothing..
//    printf("didEndDisplayingCell\n");
//    [self.viewModel didEndDisplayingCellForItemAtIndexPath:indexPath];
}




#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [(RITLPhotoBrowseViewModel *)self.viewModel viewModelScrollViewDidEndDecelerating:scrollView];
}

@end


@implementation RITLPhotoBrowseController (UpdateNumberOfLabel)

-(void)updateNumbersForSelectAssets:(NSUInteger)number
{
    BOOL hidden = (number == 0);
    
    _numberOfLabel.hidden = hidden;
    
    if (!hidden)
    {
        _numberOfLabel.text = [NSString stringWithFormat:@"%@",@(number)];
        
        //设置放射以及动画
        _numberOfLabel.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _numberOfLabel.transform = CGAffineTransformIdentity;
            
        }];
    }
}

@end


@implementation RITLPhotoBrowseController (UpdateSizeLabel)

-(void)updateSizeLabelForIsHightQuarity:(BOOL)isHightQuarity
{
    if (isHightQuarity)//如果是高清状态
    {
        //
        [self ritlChangeToHightQualityStatus];
        
    }
    
    else //如果不是高清状态
    {
        [self ritlChangeToThumiStatus];
    }
}



/**
 变为高清状态
 */
- (void)ritlChangeToHightQualityStatus
{
    UIColor * currentColor = RITLPhotoBrowerSelectedColor;
    
    self.hignSignImageView.backgroundColor = currentColor;
    
    self.originPhotoLabel.textColor = [UIColor whiteColor];
    self.photoSizeLabel.textColor = [UIColor whiteColor];
    
    NSLog(@"高清图!");
}


/**
 变为缩略状态
 */
- (void)ritlChangeToThumiStatus
{
    UIColor * currentColor = RITLPhotoBrowerDeselectedColor;
    
    self.hignSignImageView.backgroundColor = currentColor;
    self.originPhotoLabel.textColor = currentColor;
    self.photoSizeLabel.textColor = currentColor;
    
    [self.activityIndicatorView stopAnimating];
    self.photoSizeLabel.text = @"";
    
}

@end
