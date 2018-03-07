//
//  UILabel+RITLExtension.m
//  RITLKitDemo
//
//  Created by YueWen on 2017/12/22.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "UILabel+RITLExtension.h"

@implementation UILabel (RITLExtension)


- (CGSize)ritl_contentSize
{
    return [self textRectForBounds:CGRectMake(0, 0, self.bounds.size.width, 1000) limitedToNumberOfLines:self.numberOfLines].size;
}

- (CGFloat)ritl_contentWidth
{
    return self.ritl_contentSize.width;
}


- (CGFloat)ritl_contentHeight
{
    return self.ritl_contentSize.height;
}

@end
