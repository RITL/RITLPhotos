//
//  YPPhotosCell.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPPhotosCell;

NS_ASSUME_NONNULL_BEGIN

typedef void(^YPPhotosCellOperationBlock)(YPPhotosCell * __nullable cell);

@interface YPPhotosCell : UICollectionViewCell

//display backgroundImage
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//default hidden is true
@property (weak, nonatomic) IBOutlet UIView *messageView;

//imageView in messageView to show the kind of asset
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;

//label in messageVie to show the information
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

//button in order to display the selected image
@property (weak, nonatomic) IBOutlet UIButton *chooseImageView;

//evoked when the chooseImageView clicked
@property (nullable, copy, nonatomic)YPPhotosCellOperationBlock imageSelectedBlock;
@property (nullable, copy, nonatomic)YPPhotosCellOperationBlock imageDeselectedBlock;



//simple method to set UI change, not evoked the block
- (void) cellDidSelect;
- (void) cellDidDeselect;


@end

NS_ASSUME_NONNULL_END
