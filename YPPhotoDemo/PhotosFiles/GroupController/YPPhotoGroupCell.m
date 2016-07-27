//
//  YPPhotoGroupCell.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotoGroupCell.h"

@implementation YPPhotoGroupCell

@synthesize imageView = _imageView,titleLabel = _titleLabel;


-(void)prepareForReuse
{
    _imageView.image = nil;
    _titleLabel.text = @"";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
