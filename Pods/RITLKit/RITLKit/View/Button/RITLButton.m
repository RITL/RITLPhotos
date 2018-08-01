//
//  ETButton.m
//  XiaoNongDingClient
//
//  Created by YueWen on 2017/4/26.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "RITLButton.h"
#import <RITLViewFrame/UIView+RITLFrameChanged.h>
#import <Masonry/Masonry.h>


@interface RITLButton ()

@property (nonatomic, strong) UIView * layerView;

@end


@implementation RITLButton


@synthesize titleLabel = _titleLabel;
@synthesize imageView = _imageView;


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        [self initialize];
    }
    
    return self;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}



-(void)initialize
{
    self.autoAdjustImageView = true;
//    self.autoObserver = true;
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.selectedImageView];
    
    //恢复
    [self prepareForReuse];
    
    _imageViewEdgeInsets = UIEdgeInsetsZero;
    _titleLabelEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
}



-(void)layoutSubviews
{
    [self p_startLayout];
}


#pragma mark - private

/// 开始约束布局
- (void)p_startLayout
{
    // 获得边距
    CGFloat space = self.imageViewEdgeInsets.left + self.imageViewEdgeInsets.right;

    // 获得imageView的宽度
    CGFloat width = self.ritl_width - space;
    
    // 获得文本与ImageView的边距
    CGFloat imageTitlePadding = self.imageViewEdgeInsets.bottom + self.titleLabelEdgeInsets.top;
    
    //获得label的宽度
    CGFloat labelWidth = self.ritl_width - self.titleLabelEdgeInsets.left - self.titleLabelEdgeInsets.right;
    
    // 如果不进行自动调整，默认高度为10.5
    CGFloat labelHeight = (self.autoAdjustImageView) ? 0 : 13.5;
    
    //进行布局
    if (self.autoAdjustImageView) {//如果自动适配
        
        self.imageView.ritl_width = width;
        self.imageView.ritl_height = MIN(self.ritl_height - imageTitlePadding, width);
        self.imageView.ritl_originY = self.imageViewEdgeInsets.top;
        self.imageView.ritl_centerX = self.ritl_width / 2.0;
        
        
        self.titleLabel.ritl_originX = self.titleLabelEdgeInsets.left;
        self.titleLabel.ritl_originY = self.imageView.ritl_maxY + imageTitlePadding;
        self.titleLabel.ritl_width = (NSInteger)labelWidth;
        
        //调整title高度
        self.titleLabel.ritl_height = (NSInteger)(self.ritl_height - self.imageView.ritl_maxY - self.titleLabelEdgeInsets.bottom - imageTitlePadding);

        
    }
    
    else {//如果不自动适配
        
        self.imageView.ritl_originY = self.imageViewEdgeInsets.top;
        self.imageView.ritl_originX = self.imageViewEdgeInsets.left;
        self.imageView.ritl_width = self.ritl_width - space;
        
        //计算imageView的高度
        CGFloat imageViewHeight = self.ritl_height - labelHeight - self.titleLabelEdgeInsets.bottom - self.titleLabelEdgeInsets.top - self.imageViewEdgeInsets.bottom - self.imageViewEdgeInsets.top;
        self.imageView.ritl_height = imageViewHeight;
        
        self.titleLabel.ritl_height = (NSInteger)(labelHeight);
        self.titleLabel.ritl_originX = self.titleLabelEdgeInsets.left;
        self.titleLabel.ritl_originY = self.imageView.ritl_maxY + self.titleLabelEdgeInsets.top + self.imageViewEdgeInsets.bottom + 3;
        self.titleLabel.ritl_width = (NSInteger)(self.ritl_width - space);
    }

    self.selectedImageView.frame = self.bounds;
    
    
    if (self.imageViewIsCornerRadius) {
        
        self.imageView.layer.cornerRadius = self.imageView.ritl_width / 2.0;
        self.imageView.clipsToBounds = true;
    }
}


#pragma mark - public

-(void)didSelectedHandler
{
    self.selectedImageView.hidden = false;
}

-(void)didDisSelectedHandler
{
    self.selectedImageView.hidden = true;
}


-(void)prepareForReuse
{
    self.selectedImageView.hidden = true;
    self.imageView.image = nil;
    self.titleLabel.text = nil;
}

#pragma mark - Getter

-(UIImageView *)imageView
{
    if (!_imageView) {
        
        UIImageView * imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        _imageView = imageView;
    }
    
    return _imageView;
}


-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        UILabel * titleLable = [UILabel new];
        
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:13];
        titleLable.clipsToBounds = false;
        titleLable.layer.borderColor = [UIColor clearColor].CGColor;
        titleLable.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = titleLable;
    }
    
    return _titleLabel;
}


-(UIView *)layerView
{
    if (!_layerView) {
        
        UIView * view = [UIView new];
        
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    
    return _layerView;
}


-(UIImageView *)selectedImageView
{
    if (!_selectedImageView) {
        
        UIImageView * imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.6];
        imageView.hidden = true;
        
        _selectedImageView = imageView;
    }
    
    return _selectedImageView;
}



-(UIImage *)defaultImage
{
    if (!_defaultImage) {
        
        return [UIImage imageNamed:@"placeholder_headerImage"];
    }
    
    return _defaultImage;
}


-(void)setImageViewEdgeInsets:(UIEdgeInsets)imageViewEdgeInsets
{
    _imageViewEdgeInsets = imageViewEdgeInsets;
    
    [self layoutIfNeeded];
}


-(void)setTitleLabelEdgeInsets:(UIEdgeInsets)titleLabelEdgeInsets
{
    _titleLabelEdgeInsets = titleLabelEdgeInsets;
    
    [self layoutIfNeeded];
}

@end
