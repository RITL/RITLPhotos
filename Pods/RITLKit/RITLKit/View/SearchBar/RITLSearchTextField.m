//
//  XNDCustomSearchTextField.m
//  XiaoNongDingClient
//
//  Created by YueWen on 2017/10/13.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "RITLSearchTextField.h"

@implementation RITLSearchTextField

- (instancetype)init
{
    if (self = [super init]) {
        
        self.searchIconLeftMargin = 0;
        self.placeholderLeftMargin = 0;
        self.textLeftMargin = 0;
    }
    
    return self;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect rect = [super leftViewRectForBounds:bounds];
    
    //修改left
    rect.origin.x += self.searchIconLeftMargin;
    
    return rect;
}


- (CGRect)borderRectForBounds:(CGRect)bounds
{
    CGRect rect = [super borderRectForBounds:bounds];
    
    return rect;
}


- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect rect = [super placeholderRectForBounds:bounds];
    
    rect.origin.x += self.placeholderLeftMargin;
    rect.size.width -= self.placeholderLeftMargin;
    
    //进行y轴偏移,使其位于中心位置
    rect.origin.y = MAX(0,(bounds.size.height - rect.size.height) / 2.0);
    
    return rect;
}


- (void)drawPlaceholderInRect:(CGRect)rect
{
    CGRect defaultPlaceholderRect = rect;
    
    if (UIDevice.currentDevice.systemVersion.floatValue < 11.0) {
    
        CGRect placeholderRect = [self placeholderRectForBounds:self.bounds];
        
        //修改纵坐标
        defaultPlaceholderRect.origin.y = placeholderRect.origin.y;
        defaultPlaceholderRect.size.height = placeholderRect.size.height;
    }
    
    [super drawPlaceholderInRect:defaultPlaceholderRect];
}


- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    
    //修改left
    rect.origin.x += self.textLeftMargin;
    rect.size.width -= self.textLeftMargin;
    
    return rect;
}



- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    
    //修改left
    rect.origin.x += self.textLeftMargin;
    rect.size.width -= self.textLeftMargin;
    
    return rect;
}


@end
