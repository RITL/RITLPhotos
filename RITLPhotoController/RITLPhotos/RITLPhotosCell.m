//
//  YPPhotosCell.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotosCell.h"
#import <Masonry.h>
#import <RITLKit.h>

static NSString *const RITLPhotosCollectionCellDeselectImageName = @"RITLPhotos.bundle/ritl_deselect";

@interface RITLPhotosCell ()


@end

@implementation RITLPhotosCell

-(void)dealloc
{
#ifdef YDEBUG
//    NSLog(@"YPPhotosCell Dealloc");
#endif
}

-(void)prepareForReuse
{
    //重置所有数据
    self.imageView.image = nil;
    self.chooseButton.hidden = false;
    self.messageView.hidden = true;
    self.messageImageView.image = nil;
    self.messageLabel.text = @"";
//    self.chooseImageView.image = RITLPhotoDeselectedImage;
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
    [super awakeFromNib];
    [self photosCellWillLoad];

}


- (void)photosCellWillLoad
{
//    _weakSelf = self;
    self.backgroundColor = [UIColor whiteColor];
    
    //add subviews
    [self addSubImageView];
    [self addChooseControl];
//    [self addChooseImageView];
    [self addSubMessageView];
    [self addSubMessageImageView];
    [self addSubMessageLabel];
    
    
}


#pragma mark - CreateSubviews

- (void)addSubImageView
{
    //添加imageView
    _imageView = [[UIImageView alloc]init];
    _imageView.clipsToBounds = true;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.backgroundColor = [UIColor whiteColor];
    
    
    [self.contentView addSubview:_imageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.edges.equalTo(self.contentView);
        
    }];
}


- (void)addSubMessageView
{
    _messageView = [[UIView alloc]init];
    
    [self.contentView addSubview:_messageView];
    
    [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.and.bottom.equalTo(self.contentView);
        make.height.equalTo(@(20));
        
    }];
    
    
    _messageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.03];
    _messageView.hidden = true;
}


- (void)addSubMessageImageView
{
    _messageImageView = [[UIImageView alloc]init];
    
    [_messageView addSubview:_messageImageView];
    
    [_messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@(5));
        make.bottom.equalTo(self.messageView);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
}


- (void)addSubMessageLabel
{
    _messageLabel = [[UILabel alloc]init];
    
    [_messageView addSubview:_messageLabel];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.messageImageView.mas_right);
        make.right.equalTo(self.messageView).offset(-3);
        make.bottom.equalTo(self.messageView);
        make.height.mas_equalTo(20);
        
    }];

    
    _messageLabel.font = [UIFont systemFontOfSize:11];
    _messageLabel.textAlignment = NSTextAlignmentRight;
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.text = @"00:25";
}



- (void)addChooseControl
{
    _chooseButton = [UIButton new];
    
    [self.contentView addSubview:_chooseButton];
    
    [_chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.top.offset(0);
        make.right.offset(0);
    }];
    
//    _chooseButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _chooseButton.layer.cornerRadius = 25 / 2.0;
    _chooseButton.clipsToBounds = true;
    [_chooseButton addTarget:self
                      action:@selector(chooseButtonDidTap:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    _chooseButton.imageEdgeInsets = UIEdgeInsetsMake(4, 19, 20, 5);
    [_chooseButton setImage:RITLPhotosCollectionCellDeselectImageName.ritl_image forState:UIControlStateNormal];


    [_chooseButton setTitle:@"1" forState:UIControlStateSelected];
    _chooseButton.imageView.backgroundColor = UIColor.orangeColor;

}



/** 选择按钮被点击 */
- (IBAction)chooseButtonDidTap:(id)sender
{
    if (self.chooseImageDidSelectBlock)
    {
        self.chooseImageDidSelectBlock(self);
    }
}



//- (void)addChooseImageView
//{
//    _chooseImageView = [UIImageView new];
//
//    [_chooseControl addSubview:_chooseImageView];
//
//    [_chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.size.mas_equalTo(CGSizeMake(25, 25));
//        make.right.and.bottom.mas_equalTo(0);
//
//    }];
//
//    _chooseImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    _chooseImageView.layer.cornerRadius = 25 / 2.0;
//    _chooseImageView.clipsToBounds = true;
//
//}

@end


//@implementation RITLPhotosCell (RITLPhotosViewModel)
//
//-(void)cellSelectedAction:(BOOL)isSelected
//{
////    NSString * imageName = !isSelected ? @"未选中" : @"选中";
//
////    self.chooseImageView.image = [UIImage imageNamed:imageName];
//
//    self.chooseImageView.image = !isSelected ? RITLPhotoDeselectedImage : RITLPhotoSelectedImage;
//
//
//    if (isSelected)
//    {
//        [self startSelectedAnimation];
//    }
//
//}
//
//
//- (void)startSelectedAnimation
//{
//    //anmiation
//    [UIView animateWithDuration:0.2 animations:^{
//
//        //放大
//        self.chooseImageView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
//
//    } completion:^(BOOL finished) {//变回
//
//        [UIView animateWithDuration:0.2 animations:^{
//
//            self.chooseImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//
//        }];
//
//    }];
//}

//@end

