//
//  YPPhotoGroupCell.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotoGroupCell.h"

@interface YPPhotoGroupCell ()

@property (nonatomic, weak)YPPhotoGroupCell * weakSelf;

@end

@implementation YPPhotoGroupCell

@synthesize imageView = _imageView,titleLabel = _titleLabel;


-(void)dealloc
{
#ifdef YDEBUG
    NSLog(@"YPPhotoGroupCell Dealloc");
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
    _weakSelf = self;
    
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
        make.width.equalTo(_weakSelf.imageView.mas_height);
        
    }];
}


- (void)addSubTitleLabel
{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.contentView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(_weakSelf.contentView.mas_centerY);
        make.left.equalTo(_weakSelf.imageView.mas_right).offset(10);
        make.right.equalTo(_weakSelf.contentView).offset(-10);
        
    }];
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
    
    _categoryImageView.hidden = true;
    
}

@end
