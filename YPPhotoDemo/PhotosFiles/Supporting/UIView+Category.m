//
//  UIView+Category.m
//  CityBao
//
//  Created by YueWen on 16/7/5.
//  Copyright © 2016年 wangpj. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Bounds)

-(CGSize)size
{
    return self.frame.size;
}

-(CGFloat)width
{
    return self.size.width;
}

-(CGFloat)height
{
    return self.size.height;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

-(CGFloat)originX
{
    return self.origin.x;
}

-(CGFloat)originY
{
    return self.origin.y;
}


-(CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

@end


@implementation UIView (Convenice)

+(instancetype)viewWithFrame:(CGRect)frame
{
    return [[UIView alloc]initWithFrame:frame];
}

@end

@implementation UIView (RemoveSubviews)

-(void)removeAllSubviews
{
    for (UIView * view in self.subviews)
    {
        [view removeFromSuperview];
    }
}

@end

@implementation UIView (ChangeFrame)

-(void)changeLength:(CGFloat)dLength
{
    [self changeFrameWithOriginX:0 OriginY:0 Width:0 Height:dLength];
}


-(void)changeLengthWithChangedLength:(CGFloat)length
{
    if (length < 0) return;
    
    [self changeFrameWithOriginX:0 OriginY:0 Width:0 Height:(length - self.height)];
    
}


-(void)changeOriginY:(CGFloat)dOriginY
{
    [self changeFrameWithOriginX:0 OriginY:dOriginY Width:0 Height:0];
}

-(void)changeOriginYWithChangedOriginY:(CGFloat)originY
{
    [self changeFrameWithOriginX:0 OriginY:(originY - self.originY) Width:0 Height:0];
}



- (void)changeFrameWithOriginX:(CGFloat)dx OriginY:(CGFloat)dy Width:(CGFloat)dWidth Height:(CGFloat)dHeight
{
    //获得当前的frame
    CGRect frame = self.frame;
    
    frame.origin.x += dx;
    frame.origin.y += dy;
    frame.size.width += dWidth;
    frame.size.height += dHeight;
    
    self.frame = frame;
    
}


@end



