//
//  RITLTabBarItem.m
//  XiaoNongDingClient
//
//  Created by YueWen on 2017/5/4.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "RITLButtonItem.h"
#import <RITLViewFrame/UIView+RITLFrameChanged.h>
#import "RITLUtility.h"
#import <Masonry/Masonry.h>

@interface RITLButtonItem ()

/// 显示消息数量的badge
@property (nonatomic, strong) UILabel * badgeLabel;
@property (nonatomic, strong) UIImageView *badgeBottomView;

@end

@implementation RITLButtonItem

@synthesize badgeTextColor = _badgeTextColor;
@synthesize badgeBarTintColor = _badgeBarTintColor;
@synthesize badgeSize = _badgeSize;
@synthesize badgeValue = _badgeValue;
@synthesize badgeTextFont = _badgeTextFont;

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
    
    [super layoutSubviews];
    
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
//    self.badgeBottomView.image = [self.badgeBarTintColor ritl_cornerImage:MIN(self.badgeBottomView.ritl_height, self.badgeBottomView.ritl_width) / 2.0 size:self.badgeSize];
    
    //设置中心
    self.badgeLabel.ritl_centerX = self.badgeBottomView.ritl_width / 2.0;
    self.badgeLabel.ritl_centerY = self.badgeBottomView.ritl_height / 2.0;
}



#pragma mark - getter

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


-(void)setBadgeSize:(CGSize)badgeSize
{
    _badgeSize = badgeSize;
    
    [self setNeedsLayout];
}


-(void)setBadgeInset:(UIEdgeInsets)badgeInset
{
    _badgeInset = badgeInset;
    
    [self setNeedsLayout];
}

- (void)setBadgeTextFont:(UIFont *)badgeTextFont
{
    _badgeTextFont = badgeTextFont;
    
    self.badgeLabel.font = badgeTextFont;
}


-(void)setNormalImage:(UIImage *)normalImage
{
    _normalImage = normalImage;
    
    [self didDisSelectedHandler];
}




-(void)showBadge
{
    self.badgeLabel.hidden = false;
}


-(void)hiddenBadge
{
    self.badgeLabel.hidden = true;
}

#pragma mark - super

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
