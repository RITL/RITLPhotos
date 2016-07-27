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

-(void)awakeFromNib
{
    _chooseImageView.layer.cornerRadius = _chooseImageView.bounds.size.width / 2.0f;
    _chooseImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
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




@end
