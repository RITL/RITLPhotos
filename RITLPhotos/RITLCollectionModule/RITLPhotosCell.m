//
//  YPPhotosCell.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotosCell.h"
#import "NSBundle+RITLPhotos.h"
#import <PhotosUI/PhotosUI.h>
#import <Masonry/Masonry.h>
#import <RITLKit/RITLKit.h>

//static NSString *const RITLPhotosCollectionCellDeselectImageName = @"RITLPhotos.bundle/ritl_deselect";

@interface RITLPhotosCell ()

/// 不能点击进行的遮罩层
@property (nonatomic, strong, readwrite)UIView *shadeView;

@end

@implementation RITLPhotosCell

-(void)prepareForReuse
{
    //重置所有数据
//    self.imageView.image = nil;
//    self.chooseButton.hidden = false;
//    self.messageView.hidden = true;
//    self.messageImageView.image = nil;
//    self.messageLabel.text = @"";
//    self.indexLabel.text = @"";
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
    self.backgroundColor = [UIColor whiteColor];
    
    //add subviews
    [self addSubImageView];
    [self addSubMessageView];
    [self addSubMessageImageView];
    [self addSubMessageLabel];
    [self addChooseControl];
    
    self.indexLabel = ({
        
        UILabel *label = [UILabel new];
        label.backgroundColor = RITLColorFromIntRBG(9, 187, 7);
        label.text = @"0";
        label.font = RITLUtilityFont(RITLFontPingFangSC_Regular, 13);
        label.textColor = UIColor.whiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 21 / 2.0;
        label.layer.masksToBounds = true;
        label.hidden = true;
        label;
    });
    
    [self.contentView addSubview:self.indexLabel];
    
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.height.mas_equalTo(21);
        make.right.inset(5);
        make.top.offset(4);
    }];
    
    self.liveBadgeImageView = ({
        
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = UIColor.clearColor;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.hidden = true;
        
        if (@available(iOS 9.1,*)) {
            
            imageView.image = [PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent];
        }
    
        imageView;
    });
    
    if (RITL_iOS_Version_GreaterThanOrEqualTo(9.1)) {
        
        [self.contentView addSubview:self.liveBadgeImageView];
        
        [self.liveBadgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.bottom.inset(3);
            make.left.offset(3);
            make.width.and.height.mas_equalTo(28);
        }];
    }
    
    self.shadeView = ({
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.6];
        view.hidden = true;
        
        view;
    });
    
    [self.contentView addSubview:self.shadeView];
    
    [self.shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.offset(0);
    }];

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
        
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.offset(0);
        make.right.offset(0);
    }];
    
    [_chooseButton addTarget:self
                      action:@selector(chooseButtonDidTap:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    _chooseButton.imageEdgeInsets = UIEdgeInsetsMake(4, 14, 15, 5);
    
    /// normal
    [_chooseButton setImage:/*RITLPhotosCollectionCellDeselectImageName.ritl_image*/NSBundle.ritl_deselect forState:UIControlStateNormal];

    /// selected
    [_chooseButton setTitle:@"1" forState:UIControlStateSelected];
    [_chooseButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    _chooseButton.imageView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.15];
    
    _chooseButton.imageView.layer.cornerRadius = 21 / 2.0;
    _chooseButton.imageView.layer.masksToBounds = true;
}



/** 选择按钮被点击 */
- (IBAction)chooseButtonDidTap:(id)sender
{
    if (self.actionTarget && [self.actionTarget respondsToSelector:@selector(photosCellDidTouchUpInSlide:asset:indexPath:complete:)]) {
        
        [self.actionTarget photosCellDidTouchUpInSlide:self asset:self.asset indexPath:self.indexPath complete:^(RITLPhotosCellAnimatedStatus status, BOOL selected,NSUInteger count) {
            
            if (status == RITLPhotosCellAnimatedStatusPermit) {//允许使用动画
                [self selectedStatusDidChanged:selected count:count];
            }
        }];
    }
}


- (void)selectedStatusDidChanged:(BOOL)selected count:(NSUInteger)count
{
    self.indexLabel.hidden = !selected;
    
    if (!selected) {
        self.indexLabel.text = @"";
        return;
    }
    
    self.indexLabel.text = @(count).stringValue;

    [UIView animateWithDuration:0.15 animations:^{//anmiation

        self.indexLabel.transform = CGAffineTransformMakeScale(1.3f, 1.3f);//放大

    } completion:^(BOOL finished) {//变回

        [UIView animateWithDuration:0.1 animations:^{

            self.indexLabel.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }];
    }];
}

@end

