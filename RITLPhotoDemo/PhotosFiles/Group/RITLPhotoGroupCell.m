//
//  YPPhotoGroupCell.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoGroupCell.h"

@implementation RITLPhotoGroupCell

@synthesize imageView = _imageView,titleLabel = _titleLabel;


-(void)dealloc
{
#ifdef RITLDebug
//    NSLog(@"YPPhotoGroupCell Dealloc");
#endif
}

-(void)prepareForReuse
{
    _imageView.image = nil;
    _titleLabel.text = @"";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self photoGroupCellWillLoad];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [self photoGroupCellWillLoad];
}

- (void)photoGroupCellWillLoad
{
    [self addSubImageView];
    [self addSubTitleLabel];
    [self addSubCategoryImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - AddSubviews

- (void)addSubImageView
{
    _imageView = [[UIImageView alloc]init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = true;
    
    [self.contentView addSubview:_imageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.leading.mas_equalTo(10);
        make.width.equalTo(self.imageView.mas_height);
        
    }];
    
    
    //等价
//    _imageView.translatesAutoresizingMaskIntoConstraints = false;
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_imageView]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
}


- (void)addSubTitleLabel
{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.contentView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.imageView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        
    }];
    
    
    //等价
//    _titleLabel.translatesAutoresizingMaskIntoConstraints = false;
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageView]-10-[_titleLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel,_imageView)]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}

- (void)addSubCategoryImageView
{
    _categoryImageView = [[UIImageView alloc]init];
    
    [self.contentView addSubview:_categoryImageView];
    
    [_categoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.bottom.mas_equalTo(-7);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
  
    //等价
//    _categoryImageView.translatesAutoresizingMaskIntoConstraints = false;
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_categoryImageView(15)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_categoryImageView)]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_categoryImageView(15)]-7-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_categoryImageView)]];

    _categoryImageView.hidden = true;
    
}

@end
