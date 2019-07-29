//
//  RITLTabBarItem.m
//  XiaoNongDingClient
//
//  Created by YueWen on 2017/5/4.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "RITLItemButton.h"
#import <RITLViewFrame/UIView+RITLFrameChanged.h>
#import "RITLUtility.h"
#import <Masonry/Masonry.h>

@interface RITLItemButton ()

/// 显示消息数量的badge
@property (nonatomic, strong) UILabel * badgeLabel;
@property (nonatomic, strong) UIImageView *badgeBottomView;

@end

@implementation RITLItemButton

@synthesize badgeTextColor = _badgeTextColor;
@synthesize badgeBarTintColor = _badgeBarTintColor;
@synthesize badgeSize = _badgeSize;
@synthesize badgeValue = _badgeValue;
@synthesize badgeTextFont = _badgeTextFont;
@synthesize titleLabel = _titleLabel;
@synthesize imageView = _imageView;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initializeItem];
    }
    
    return self;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initializeItem];
}



-(void)initializeItem
{
    self.autoAdjustImageView = true;
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.clipsToBounds = false;
    
    _badgeInset = UIEdgeInsetsMake(2, 0, 0, -5);

    //追加视图
    [self addSubview:self.badgeBottomView];
    [self.badgeBottomView addSubview:self.badgeLabel];
    
    self.imageSize = CGSizeMake(25, 25);
    self.badgeTextFont = [UIFont systemFontOfSize:10];
    self.titleLabelEdgeInsets = UIEdgeInsetsMake(3, 3, 4, 3);
    self.imageViewEdgeInsets = UIEdgeInsetsMake(6, 0, 0, 0);
}


-(void)layoutSubviews
{
    //保持imageView为(23,23)
    CGFloat space = (self.ritl_width - MIN(self.imageSize.width,self.imageSize.height)) / 2;
    
    //修改imageEdgeInsets
    UIEdgeInsets imageInsets = self.imageViewEdgeInsets;
    imageInsets.right = space;
    imageInsets.left = space;
    self.imageViewEdgeInsets = imageInsets;
    
    //进行布局
    [self layoutSubViewsForTitleLabelAndImageView];
    
    //进行badge布局
    self.badgeBottomView.ritl_height = self.badgeSize.height;
    self.badgeBottomView.ritl_width = self.badgeSize.width;
    self.badgeBottomView.ritl_originY = self.badgeInset.top;
    self.badgeBottomView.ritl_originX = self.imageView.ritl_maxX - self.badgeBottomView.ritl_width / 2.0 - self.badgeInset.right;
    
    self.badgeLabel.ritl_originX = 0;
    self.badgeLabel.ritl_originY = 0;
    self.badgeLabel.ritl_height = self.badgeSize.height;
    self.badgeLabel.ritl_width = self.badgeSize.width;
    self.badgeBottomView.layer.cornerRadius = MIN(self.badgeBottomView.ritl_height, self.badgeBottomView.ritl_width) / 2.0;
    
    //设置中心
    self.badgeLabel.ritl_centerX = self.badgeBottomView.ritl_width / 2.0;
    self.badgeLabel.ritl_centerY = self.badgeBottomView.ritl_height / 2.0;
}


/// 进行真实的布局约束
- (void)layoutSubViewsForTitleLabelAndImageView
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
}



#pragma mark - getter


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



-(UILabel *)badgeLabel
{
    if (!_badgeLabel) {
        
        UILabel * badgeLabel = [UILabel new];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.font = self.badgeTextFont;
        badgeLabel.backgroundColor = self.badgeBarTintColor;
        badgeLabel.textColor = self.badgeTextColor;

        _badgeLabel = badgeLabel;
    }
    
    return _badgeLabel;
}


- (UIImageView *)badgeBottomView
{
    if (!_badgeBottomView) {
        
        _badgeBottomView = [UIImageView ritl_viewInstanceTypeHandler:^(__kindof UIImageView * _Nonnull view) {
           
            view.clipsToBounds = true;
            view.userInteractionEnabled = false;
            view.hidden = true;
        }];
    }
    
    return _badgeBottomView;
}


-(UIColor *)badgeTextColor
{
    if (!_badgeTextColor) {
        
        return [UIColor whiteColor];
    }
    
    return _badgeTextColor;
}




-(UIColor *)badgeBarTintColor
{
    if (!_badgeBarTintColor) {
        
        return RITLColorFromIntRBG(255,85,85);
    }
    
    return _badgeBarTintColor;
}

-(CGSize)badgeSize
{
    if (_badgeSize.height <= 0 || _badgeSize.height >= self.ritl_height / 2.0 || _badgeSize.width <= 0 || _badgeSize.width >= self.ritl_width / 2.0) {
        
        return CGSizeMake(22, 15);
    }
    
    return _badgeSize;
}


-(UIImage *)selectedImage
{
    if (!_selectedImage) {
        
        return self.normalImage;
    }
    
    return _selectedImage;
}

-(NSString *)selectedImageURL
{
    if (!_selectedImageURL) {
        
        return self.normalImageURL;
    }
    
    return _selectedImageURL;
}


-(NSString *)badgeValue
{
    if ([_badgeValue isEqualToString:@"99+"]) {
        
        return @"99";
    }
    
    return _badgeValue;
}


- (UIFont *)badgeMaxTextFont
{
    if (!_badgeMaxTextFont) {
        
        return self.badgeTextFont;
    }
    
    return _badgeMaxTextFont;
}

#pragma mark - setter

-(void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    
    if (!badgeValue || badgeValue.integerValue == 0) {
        
        self.badgeBottomView.hidden = true;
        self.badgeLabel.text = nil;
        return;
    }
    
    
    else if(badgeValue.integerValue > 99){
        
        badgeValue = @"99+";
        self.badgeLabel.font = self.badgeMaxTextFont;
        
    }else {
        
        self.badgeLabel.font = self.badgeTextFont;
    }
    
    self.badgeLabel.text = badgeValue;
    self.badgeBottomView.hidden = false;
    
    [self setNeedsLayout];
}

-(void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    _badgeTextColor = badgeTextColor;
    self.badgeLabel.textColor = badgeTextColor;
}


-(void)setBadgeBarTintColor:(UIColor *)badgeBarTintColor
{
    _badgeBarTintColor = badgeBarTintColor;
    self.badgeLabel.backgroundColor = badgeBarTintColor;
    //设置背景图片
//    self.badgeBottomView.image = [badgeBarTintColor ritl_cornerImage:self.badgeBottomView.ritl_width / 2.0 size:self.badgeSize];
}


-(void)setBadgeSize:(CGSize)badgeSize {
    _badgeSize = badgeSize;
    [self setNeedsLayout];
}


-(void)setBadgeInset:(UIEdgeInsets)badgeInset {
    _badgeInset = badgeInset;
    [self setNeedsLayout];
}


- (void)setBadgeTextFont:(UIFont *)badgeTextFont {
    _badgeTextFont = badgeTextFont;
    self.badgeLabel.font = badgeTextFont;
}


-(void)setNormalImage:(UIImage *)normalImage {
    _normalImage = normalImage;
    [self didDisSelectedHandler];
}


-(void)showBadge {
    self.badgeLabel.hidden = false;
}


-(void)hiddenBadge {
    self.badgeLabel.hidden = true;
}

#pragma mark - super

// 如果需要此功能，请继承此类，如下设置即可
-(void)didSelectedHandler
{
    //设置属性
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.selectedImageURL] placeholderImage:self.selectedImage];
}


-(void)didDisSelectedHandler
{

//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.normalImageURL] placeholderImage:self.normalImage];
}



@end
