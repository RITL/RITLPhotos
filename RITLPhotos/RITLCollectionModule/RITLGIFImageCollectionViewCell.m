//
//  RITLGIFImageCollectionViewCell.m
//  rabbit
//
//  Created by iOSzhang Inc on 20/8/12.
//  Copyright © 2020 jixiultd. All rights reserved.
//

#import "RITLGIFImageCollectionViewCell.h"
#import "UICollectionViewCell+RITLPhotosAsset.h"
#import <RITLKit/RITLKit.h>
#import <Masonry/Masonry.h>

@interface RITLGIFImageCollectionViewCell() <UIScrollViewDelegate,UIGestureRecognizerDelegate>

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

@implementation RITLGIFImageCollectionViewCell

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
    [self createGifLabel];
    [self createDoubleTapGesture];
    [self createSimpleTapGesture];
}


-(void)prepareForReuse
{
    _imageView.image = nil;

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
//            make.center.mas_equalTo(0);
//            make.edges.mas_greaterThanOrEqualTo(0);
            make.edges.equalTo(weakSelf.contentView).offset(0);
        }];
    }
}


- (void)createImageView
{
    if (self.imageView == nil)
    {
        self.imageView = [[UIImageView alloc]init];
        self.imageView.contentMode = UIViewContentModeCenter;
        [self.bottomScrollView addSubview:self.imageView];
        
        __weak typeof(self) weakSelf = self;
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.mas_equalTo(0);
//            make.edges.mas_greaterThanOrEqualTo(0);
            make.edges.equalTo(weakSelf.bottomScrollView);
            make.width.equalTo(weakSelf.bottomScrollView.mas_width);
            make.height.equalTo(weakSelf.bottomScrollView.mas_height);
        }];
    }
}

- (void)createGifLabel {
    if (self.gifLabel == nil) {
        self.gifLabel = [[UILabel alloc] init];
        self.gifLabel.text = @"GIF";
        self.gifLabel.font = [UIFont systemFontOfSize:14];
        self.gifLabel.textColor = UIColor.whiteColor;
        [self.contentView addSubview:self.gifLabel];
        
        [self.gifLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(25);
            make.left.offset(18);
            make.top.offset(RITL_DefaultNaviBarHeight + 18);
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
                CGFloat height = strongSelf.frame.size.height;//获得Cell的宽度
                CGFloat scaleW = width / strongSelf.maxScaleZoome;//触及范围
                CGFloat scaleH = height / strongSelf.maxScaleZoome;//触及范围
//                CGPoint point = [sender locationInView:strongSelf.imageView];//获取当前的触摸点
                CGPoint point = [sender locationInView:strongSelf.bottomScrollView];//获取当前的触摸点
                //计算触摸点对中心点的偏移量
                CGPoint devPoint = CGPointMake(point.x-scaleW, point.y-scaleH);
                
                //对点进行处理
                CGFloat originX = MAX(0, point.x - scaleW*0.5 - devPoint.x/2);
                CGFloat originY = MAX(0, point.y - scaleH*0.5 - devPoint.y/2);

                //进行位置的计算
                CGRect rect = CGRectMake(originX, originY, scaleW, scaleH);
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
    //对不在范围内的重置范围
    [scrollView setZoomScale:MAX(MIN(scale, self.maxScaleZoome), self.minScaleZoome) animated:true];
    NSLog(@"imageView = %@",NSStringFromCGRect(self.imageView.frame));
}

//#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.bottomScrollView.zoomScale != self.bottomScrollView.minimumZoomScale;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.bottomScrollView.zoomScale == self.bottomScrollView.minimumZoomScale) {
        return true;
    }

    return ![otherGestureRecognizer.view isKindOfClass:UICollectionView.class];
}

- (void)updateViews:(UIImage *)image info:(NSDictionary *)info {
    //适配长图
    self.imageView.image = image;
    
    //对缩放进行适配
    CGFloat height = self.currentAsset.pixelHeight / 2;
    CGFloat width = self.currentAsset.pixelWidth / 2;
    CGFloat max = MAX(width, height);
    CGFloat scale = 1.0;
    if (height > width) {
        scale = max / MAX(1,self.imageView.bounds.size.height);
    }else {
        scale = max / MAX(1,self.imageView.bounds.size.width);
    }
    self.bottomScrollView.maximumZoomScale = MAX(2.0,scale);
}


- (void)reset {
    self.bottomScrollView.maximumZoomScale = 2.0;
    [self.bottomScrollView setZoomScale:1];
}


@end
