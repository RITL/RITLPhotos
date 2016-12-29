//
//  RITLPhotoBrowerCell.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPhotoBrowerCell.h"

@interface RITLPhotoBrowerCell ()<UIScrollViewDelegate>

/// @brief 是否已经缩放的标志位
@property (nonatomic, assign)BOOL isScale;

/// @brief 底部负责滚动的滚动视图
@property (strong, nonatomic) IBOutlet UIScrollView *bottomScrollView;

//手势
@property (nonatomic, strong) UITapGestureRecognizer * simpleTapGesture;
@property (nonatomic, strong) UITapGestureRecognizer * doubleTapGesture;

/// @brief 缩放比例
@property (nonatomic, assign) CGFloat minScaleZoome;
@property (nonatomic, assign) CGFloat maxScaleZoome;

@end

@implementation RITLPhotoBrowerCell

-(void)dealloc
{
#ifdef YDEBUG
    NSLog(@"YPPhotoBrowerCell Dealloc");
#endif
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self browerCellLoad];
    }
    
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self browerCellLoad];
}

- (void)browerCellLoad
{
    self.minScaleZoome = 1.0f;
    self.maxScaleZoome = 4.0f;
    
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


#pragma mark - Action

- (void)simpleTapGestureDidTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"单击了!");
    if (self.bottomScrollView.zoomScale != 1.0f)
    {
        //单击缩小
        [self.bottomScrollView setZoomScale:1.0f animated:true];
    }
}


- (void)doubleTapGestureDidTap:(UITapGestureRecognizer *)touch
{
    NSLog(@"双击了!");
    if (self.bottomScrollView.zoomScale != 1.0f)
    {
        [self.bottomScrollView setZoomScale:1.0f animated:true];
    }
    
    else{
        
        //获得Cell的宽度
        CGFloat width = self.frame.size.width;
        
        //触及范围
        CGFloat scale = width / self.maxScaleZoome;
        
        //获取当前的触摸点
        CGPoint point = [touch locationInView:self.imageView];
        
        //对点进行处理
        CGFloat originX = MAX(0, point.x - width / scale);
        CGFloat originY = MAX(0, point.y - width / scale);
        
        //进行位置的计算
        CGRect rect = CGRectMake(originX, originY, width / scale , width / scale);
        
        //进行缩放
        [self.bottomScrollView zoomToRect:rect animated:true];
        
    }
}


#pragma mark - create Subviews
- (void)createBottomScrollView
{
    if (self.bottomScrollView == nil)
    {
        self.bottomScrollView = [[UIScrollView alloc]init];
        self.bottomScrollView.backgroundColor = [UIColor blackColor];
        self.bottomScrollView.delegate = self;
        self.bottomScrollView.minimumZoomScale = self.minScaleZoome;
        self.bottomScrollView.maximumZoomScale = self.maxScaleZoome;
        [self.contentView addSubview:self.bottomScrollView];
        
        
        __weak typeof(self) weakSelf = self;
        
        //添加约束
        [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 10));
            
        }];
        
        //等价
        //        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bottomScrollView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomScrollView)]];
        //        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bottomScrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomScrollView)]];
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
        
        //等价添加约束
        //        [self.bottomScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
        //        [self.bottomScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
        //        [self.bottomScrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.bottomScrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        //        [self.bottomScrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.bottomScrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    }
}


- (void)createDoubleTapGesture
{
    if (self.doubleTapGesture == nil)
    {
        self.doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapGestureDidTap:)];
        self.doubleTapGesture.numberOfTapsRequired = 2;
        [self.bottomScrollView addGestureRecognizer:self.doubleTapGesture];
    }
}

- (void)createSimpleTapGesture
{
    if (self.simpleTapGesture == nil)
    {
        self.simpleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(simpleTapGestureDidTap:)];
        self.simpleTapGesture.numberOfTapsRequired = 1;
        [self.simpleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
        [self.bottomScrollView addGestureRecognizer:self.simpleTapGesture];
    }
}


#pragma mark - <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:true];
}



@end
