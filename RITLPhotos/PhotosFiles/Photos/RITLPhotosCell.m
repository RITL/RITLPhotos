//
//  YPPhotosCell.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotosCell.h"


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
    self.chooseImageView.hidden = false;
    self.messageView.hidden = true;
    self.messageImageView.image = nil;
    self.messageLabel.text = @"";
    self.chooseImageView.image = RITLPhotoDeselectedImage;
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
    [self addChooseImageView];
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
    
    //等价
//    _imageView.translatesAutoresizingMaskIntoConstraints = false;
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
}


- (void)addSubMessageView
{
    _messageView = [[UIView alloc]init];
    
    [self.contentView addSubview:_messageView];
    
    [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.and.bottom.equalTo(self.contentView);
        make.height.equalTo(@(20));
        
    }];
    
    //等价
//    _messageView.translatesAutoresizingMaskIntoConstraints = false;
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_messageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageView)]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_messageView(20)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageView)]];
    
    
    _messageView.backgroundColor = [UIColor blackColor];
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

//    _messageImageView.translatesAutoresizingMaskIntoConstraints = false;
//    [_messageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_messageImageView(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageImageView)]];
//    [_messageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_messageImageView(20)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageImageView)]];

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
    
//    _messageLabel.translatesAutoresizingMaskIntoConstraints = false;
//    [_messageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_messageImageView]-0-[_messageLabel]-3-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageImageView,_messageLabel)]];
//    [_messageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_messageLabel(20)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel)]];
    
    
    _messageLabel.font = [UIFont systemFontOfSize:11];
    _messageLabel.textAlignment = NSTextAlignmentRight;
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.text = @"00:25";
}


//- (void)addSubChooseImageView
//{
//    _chooseImageView = [[UIButton alloc]init];
//    
//    [self.contentView addSubview:_chooseImageView];
//    
//    [_chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.size.mas_equalTo(CGSizeMake(25, 25));
//        make.right.and.bottom.mas_equalTo(-3);
//        
//    }];
//    
////     _chooseImageView.translatesAutoresizingMaskIntoConstraints = false;
////    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_chooseImageView(25)]-3-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_chooseImageView)]];
////    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_chooseImageView(25)]-3-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_chooseImageView)]];
//    
//    _chooseImageView.layer.cornerRadius = 25 / 2.0f;
//    _chooseImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    [_chooseImageView setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
//    [_chooseImageView addTarget:self action:@selector(chooseButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
//}


- (void)addChooseControl
{
    _chooseControl = [UIControl new];
    
    [self.contentView addSubview:_chooseControl];
    
    [_chooseControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.right.and.bottom.mas_equalTo(-3);
    }];
    
    _chooseControl.backgroundColor = [UIColor clearColor];
    [_chooseControl addTarget:self action:@selector(chooseButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
}



/** 选择按钮被点击 */
- (IBAction)chooseButtonDidTap:(id)sender
{
    if (self.chooseImageDidSelectBlock)
    {
        self.chooseImageDidSelectBlock(self);
    }
}



- (void)addChooseImageView
{
    _chooseImageView = [UIImageView new];
    
    [_chooseControl addSubview:_chooseImageView];
    
    [_chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.right.and.bottom.mas_equalTo(0);
        
    }];
    
    _chooseImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _chooseImageView.image = RITLPhotoDeselectedImage;
    _chooseImageView.layer.cornerRadius = 25 / 2.0;
    _chooseImageView.clipsToBounds = true;
    
}

@end


@implementation RITLPhotosCell (RITLPhotosViewModel)

-(void)cellSelectedAction:(BOOL)isSelected
{
//    NSString * imageName = !isSelected ? @"未选中" : @"选中";
    
//    self.chooseImageView.image = [UIImage imageNamed:imageName];
    
    self.chooseImageView.image = !isSelected ? RITLPhotoDeselectedImage : RITLPhotoSelectedImage;
    
    
    if (isSelected)
    {
        [self startSelectedAnimation];
    }
    
}


- (void)startSelectedAnimation
{
    //anmiation
    [UIView animateWithDuration:0.2 animations:^{
        
        //放大
        self.chooseImageView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        
    } completion:^(BOOL finished) {//变回
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.chooseImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            
        }];
        
    }];
}

@end
