//
//  RITLPhotoBrowerCell.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotosBrowseImageCell.h"
#import "UICollectionViewCell+RITLPhotosAsset.h"
#import <RITLKit/RITLKit.h>
#import <Masonry/Masonry.h>

@interface RITLPhotosBrowseImageCell ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

/// @brief 是否已经缩放的标志位
@property (nonatomic, assign)BOOL isScale;

/// @brief 底部负责滚动的滚动视图
@property (strong, nonatomic, readwrite) IBOutlet UIScrollView *bottomScrollView;

//手势
@property (nonatomic, strong) UITapGestureRecognizer * simpleTapGesture;
@property (nonatomic, strong) UITapGestureRecognizer * doubleTapGesture;
/// 滑动手势
@property (nonatomic, strong) UIPanGestureRecognizer * panTapGesture;

/// @brief 缩放比例
@property (nonatomic, assign) CGFloat minScaleZoome;
@property (nonatomic, assign) CGFloat maxScaleZoome;

@end

@implementation RITLPhotosBrowseImageCell

-(void)dealloc
{

}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self browerCellLoad];
    }
    
    return self;
}


- (void)browerCellLoad
{
    self.minScaleZoome = 1.0f;
    self.maxScaleZoome = 2.0f;
    
    [self createBottomScrollView];
    [self createImageView];
    [self createDoubleTapGesture];
    [self createSimpleTapGesture];
}


-(void)prepareForReuse
{
    _imageView.image = nil;
    _bottomScrollView.zoomScale = 1.0f;
}


#pragma mark - create Subviews
- (void)createBottomScrollView
{
    if (self.bottomScrollView == nil)
    {
        self.bottomScrollView = [[UIScrollView alloc]init];
        self.bottomScrollView.backgroundColor = [UIColor blackColor];
        self.bottomScrollView.delegate = self;
        self.bottomScrollView.bounces = false;
        self.bottomScrollView.minimumZoomScale = self.minScaleZoome;
        self.bottomScrollView.maximumZoomScale = self.maxScaleZoome;
        [self.contentView addSubview:self.bottomScrollView];
        
//        self.panTapGesture = UIPanGestureRecognizer.new;
//        self.panTapGesture.delegate = self;
//        [self.bottomScrollView addGestureRecognizer:self.panTapGesture];
        
        __weak typeof(self) weakSelf = self;
        
        //添加约束
        [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView).offset(0);
        }];
    }
}


- (void)createImageView
{
    if (self.imageView == nil)
    {
        self.imageView = [[UIImageView alloc]init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.bottomScrollView addSubview:self.imageView];
        
        __weak typeof(self) weakSelf = self;
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.bottomScrollView);
            make.width.equalTo(weakSelf.bottomScrollView.mas_width);
            make.height.equalTo(weakSelf.bottomScrollView.mas_height);
        }];
    }
}


- (void)createDoubleTapGesture
{
    if (self.doubleTapGesture == nil)
    {
        self.doubleTapGesture = [UITapGestureRecognizer new];
        self.doubleTapGesture.numberOfTapsRequired = 2;
        [self.bottomScrollView addGestureRecognizer:self.doubleTapGesture];
        
        __weak typeof(self) weakSelf = self;
        
        [self.doubleTapGesture gestureRecognizerHandle:^(UIGestureRecognizer * _Nonnull sender) {
           
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (strongSelf.bottomScrollView.zoomScale != 1.0f){
                [strongSelf.bottomScrollView setZoomScale:1.0f animated:true];
            }
            
            else{
                CGFloat width = strongSelf.frame.size.width;//获得Cell的宽度
                CGFloat scale = width / strongSelf.maxScaleZoome;//触及范围
                CGPoint point = [sender locationInView:strongSelf.imageView];//获取当前的触摸点
                
                //对点进行处理
                CGFloat originX = MAX(0, point.x - width / scale);
                CGFloat originY = MAX(0, point.y - width / scale);
                
                //进行位置的计算
                CGRect rect = CGRectMake(originX, originY, width / scale , width / scale);
                [strongSelf.bottomScrollView zoomToRect:rect animated:true];//进行缩放
            }
        }];
    }
}


- (void)createSimpleTapGesture
{
    if (self.simpleTapGesture == nil)
    {
        self.simpleTapGesture = [UITapGestureRecognizer new];
        self.simpleTapGesture.numberOfTapsRequired = 1;
        [self.simpleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
        [self.bottomScrollView addGestureRecognizer:self.simpleTapGesture];
        
        [self.simpleTapGesture gestureRecognizerHandle:^(UIGestureRecognizer * _Nonnull sender) {
           
            [NSNotificationCenter.defaultCenter postNotificationName:RITLHorBrowseTooBarChangedHiddenStateNotification object:nil];
        }];
    }
}


#pragma mark - <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"scale - zoom = %@",@(scale));
    [scrollView setZoomScale:scale animated:true];
    NSLog(@"imageView = %@",@(self.imageView.bounds));
    
    
}

//#pragma mark - UIGestureRecognizerDelegate

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    return self.bottomScrollView.zoomScale != self.bottomScrollView.minimumZoomScale;
//}
//
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if (self.bottomScrollView.zoomScale == self.bottomScrollView.minimumZoomScale) {
//        return true;
//    }
//
//    return ![otherGestureRecognizer.view isKindOfClass:UICollectionView.class];
//}

@end
