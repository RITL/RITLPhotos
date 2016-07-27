//
//  YPPhotosCell.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotosCell.h"

/// @brief cell的选中状态
NS_OPTIONS(NSUInteger, YPPhotosCellType)
{
    CellTypeDeseleted = 0,/**<未选中 */
    CellTypeSelected = 1, /**<选中 */
};

@interface YPPhotosCell ()

@property (nonatomic, assign)enum YPPhotosCellType cellType;

@property (weak, nonatomic)YPPhotosCell * weakSelf;

@end

@implementation YPPhotosCell

-(void)prepareForReuse
{
    //重置所有数据
    self.imageView.image = nil;
    self.chooseImageView.hidden = false;
    self.messageView.hidden = true;
    self.messageImageView.image = nil;
    self.messageLabel.text = @"";
    [self.chooseImageView setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    self.cellType = CellTypeDeseleted;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self photosCellWillLoad];
    }
    
    return self;
}

-(void)awakeFromNib
{
    [self photosCellWillLoad];

}


- (void)photosCellWillLoad
{
    _weakSelf = self;
    
    //add subviews
    [self addSubImageView];
    [self addSubMessageView];
    [self addSubMessageImageView];
    [self addSubMessageLabel];
    [self addSubChooseImageView];

}


/** 选择按钮被点击 */
- (IBAction)chooseButtonDidTap:(id)sender
{
    switch (_cellType)
    {
        case CellTypeDeseleted:
            [self buttonShouldSelect];break;
            
        case CellTypeSelected:
            [self buttonShouldDeselect];break;
    }
}


- (void)buttonShouldSelect
{
    __weak typeof(self)copy_self = self;
    [self cellDidSelect];
    [self startAnimation];
    if (self.imageSelectedBlock) self.imageSelectedBlock(copy_self);
}



- (void)startAnimation
{
    //anmiation
    [UIView animateWithDuration:0.2 animations:^{
        
        //放大
        _chooseImageView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        
    } completion:^(BOOL finished) {//变回
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _chooseImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            
        }];
        
    }];
}


- (void)buttonShouldDeselect
{
    __weak typeof(self)copy_self = self;
    [self cellDidDeselect];
    if (self.imageDeselectedBlock) self.imageDeselectedBlock(copy_self);
}


-(void)cellDidSelect
{
    _cellType = CellTypeSelected;
    [_chooseImageView setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
}


-(void)cellDidDeselect
{
    _cellType = CellTypeDeseleted;
    [self.chooseImageView setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
}


#pragma mark - CreateSubviews

- (void)addSubImageView
{
    //添加imageView
    _imageView = [[UIImageView alloc]init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentView addSubview:_imageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(_weakSelf.contentView);
    }];
}


- (void)addSubMessageView
{
    _messageView = [[UIView alloc]init];
    
    [self.contentView addSubview:_messageView];
    
    [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.and.bottom.equalTo(_weakSelf.contentView);
        make.height.equalTo(@(20));
        
    }];
    _messageView.backgroundColor = [UIColor blackColor];
    _messageView.hidden = true;
}


- (void)addSubMessageImageView
{
    _messageImageView = [[UIImageView alloc]init];
    
    [_messageView addSubview:_messageImageView];
    
    [_messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@(5));
        make.bottom.equalTo(_weakSelf.messageView);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
}


- (void)addSubMessageLabel
{
    _messageLabel = [[UILabel alloc]init];
    
    [_messageView addSubview:_messageLabel];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_weakSelf.messageImageView.mas_right);
        make.right.equalTo(_weakSelf.contentView).offset(-3);
        make.bottom.equalTo(_weakSelf.messageImageView);
        make.height.mas_equalTo(20);
        
    }];
    
    _messageLabel.font = [UIFont systemFontOfSize:11];
    _messageLabel.textAlignment = NSTextAlignmentRight;
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.text = @"00:25";
}


- (void)addSubChooseImageView
{
    _chooseImageView = [[UIButton alloc]init];
    
    [self.contentView addSubview:_chooseImageView];
    
    [_chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.right.and.bottom.mas_equalTo(-3);
        
    }];
    
    _chooseImageView.layer.cornerRadius = 25 / 2.0f;
    _chooseImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [_chooseImageView setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [_chooseImageView addTarget:self action:@selector(chooseButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
}


@end
