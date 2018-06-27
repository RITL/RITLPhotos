//
//  LLSegmentBarVC.h
//  LLSegmentBar
//
//  Created by liushaohua on 2017/6/3.
//  Copyright © 2017年 416997919@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSegmentBar.h"

@interface LLSegmentBarVC : UIViewController

@property (nonatomic,weak) LLSegmentBar * segmentBar;

- (void)setUpWithItems: (NSArray <NSString *>*)items childVCs: (NSArray <UIViewController *>*)childVCs;

@end
