//
//  RITLCustomTitleButton.m
//  XiaoNongDingClient
//
//  Created by YueWen on 2017/5/12.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "RITLTitleButton.h"
#import "RITLUtility.h"
#import <Masonry/Masonry.h>

@implementation RITLTitleButton

@synthesize normalTextFont = _normalTextFont,normalTextColor = _normalTextColor;
@synthesize selectedTextFont = _selectedTextFont,selectedTextColor = _selectedTextColor;


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self sb_initialize];
    }
    
    return self;
}



-(void)awakeFromNib
{
    [super awakeFromNib];
    [self sb_initialize];
}



-(void)sb_initialize
{
    [self.imageView removeFromSuperview];
    [self.selectedImageView removeFromSuperview];
    
    self.titleLabel.textColor = self.normalTextColor;
    self.titleLabel.font = self.normalTextFont;
}



-(void)layoutSubviews
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.bottom.and.left.offset(0);
        
    }];
}


-(void)prepareForReuse
{
    [self didDisSelectedHandler];
}



-(void)didSelectedHandler
{
    self.titleLabel.textColor = self.selectedTextColor;
    self.titleLabel.font = self.selectedTextFont;
    self.backgroundColor = [UIColor whiteColor];
}

-(void)didDisSelectedHandler
{
    self.titleLabel.textColor = self.normalTextColor;
    self.titleLabel.font = self.normalTextFont;
    self.backgroundColor = RITLColorFromIntRBG(246, 246, 246);
}



-(UIColor *)normalTextColor
{
    if (!_normalTextColor) {
        
        return RITLColorFromIntRBG(102, 102, 102);
    }
    
    return _normalTextColor;
}


-(UIColor *)selectedTextColor
{
    if (!_selectedTextColor) {
        
        return RITLColorFromIntRBG(61, 175, 145);
    }
    
    return _selectedTextColor;
}


-(UIFont *)normalTextFont
{
    if (!_normalTextFont) {
        
        return [UIFont fontWithName:RITLFontPingFangSC_Regular size:14];
        
    }
    
    return _normalTextFont;
}


-(UIFont *)selectedTextFont
{
    if (!_selectedTextColor) {
        
        return [UIFont fontWithName:RITLFontPingFangSC_Regular size:16];
    }
    
    return _selectedTextFont;
}


@end
