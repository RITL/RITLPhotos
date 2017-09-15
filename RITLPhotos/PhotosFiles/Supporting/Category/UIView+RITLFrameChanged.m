//
//  UIView+RITLFrameChanged.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2017/3/27.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "UIView+RITLFrameChanged.h"

@implementation UIView (RITLFrameChanged)


#pragma mark - Getter

-(CGSize)ritl_size
{
    return self.bounds.size;
}

-(CGPoint)ritl_originPoint
{
    return self.frame.origin;
}

-(CGFloat)ritl_originX
{
    return self.ritl_originPoint.x;
}

-(CGFloat)ritl_originY
{
    return self.ritl_originPoint.y;
}

-(CGFloat)ritl_width
{
    return self.ritl_size.width;
}

-(CGFloat)ritl_height
{
    return self.ritl_size.height;
}

-(CGFloat)ritl_centerX
{
    return self.center.x;
}

-(CGFloat)ritl_centerY
{
    return self.center.y;
}

-(CGFloat)ritl_maxX
{
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)ritl_maxY
{
    return CGRectGetMaxY(self.frame);
}

-(CGFloat)ritl_minX
{
    return CGRectGetMinX(self.frame);
}

-(CGFloat)ritl_minY
{
    return CGRectGetMinY(self.frame);
}

-(CGFloat)ritl_midX
{
    return CGRectGetMidX(self.frame);
}

-(CGFloat)ritl_midY
{
    return CGRectGetMidY(self.frame);
}


#pragma mark - Setter

-(void)setRitl_size:(CGSize)ritl_size
{
    CGRect frame = self.frame;
    
    frame.size = ritl_size;
    
    self.frame = frame;
}



-(void)setRitl_originPoint:(CGPoint)ritl_originPoint
{
    CGRect frame = self.frame;
    
    frame.origin = ritl_originPoint;
    
    self.frame = frame;
}


-(void)setRitl_originX:(CGFloat)ritl_originX
{
    [self setRitl_originPoint:CGPointMake(ritl_originX, self.ritl_originY)];
}


-(void)setRitl_originY:(CGFloat)ritl_originY
{
    [self setRitl_originPoint:CGPointMake(self.ritl_originX, ritl_originY)];
}

-(void)setRitl_width:(CGFloat)ritl_width
{
    [self setRitl_size:CGSizeMake(ritl_width, self.ritl_height)];
}


-(void)setRitl_height:(CGFloat)ritl_height
{
    [self setRitl_size:CGSizeMake(self.ritl_width, ritl_height)];
}

-(void)setRitl_centerX:(CGFloat)ritl_centerX
{
    self.center = CGPointMake(ritl_centerX, self.ritl_centerY);
}

-(void)setRitl_centerY:(CGFloat)ritl_centerY
{
    self.center = CGPointMake(self.ritl_centerX, ritl_centerY);
}

@end

@implementation UIViewController (RITLFrameChanged)


-(CGFloat)ritl_height
{
    return self.view.ritl_height;
}

-(CGFloat)ritl_width
{
    return self.view.ritl_width;
}

@end

@implementation UIScreen (RITLFrameChanged)

-(CGFloat)ritl_height
{
    return self.bounds.size.height;
}

-(CGFloat)ritl_width
{
    return self.bounds.size.width;
}

@end

@implementation UIScrollView (RITLFrameChanged)

-(CGFloat)ritl_contentOffSetX
{
    return self.contentOffset.x;
}

-(CGFloat)ritl_contentOffSetY
{
    return self.contentOffset.y;
}

-(CGFloat)ritl_contentSizeWidth
{
    return self.contentSize.width;
}

-(CGFloat)ritl_contentSizeHeight
{
    return self.contentSize.height;
}


-(void)setRitl_contentOffSetX:(CGFloat)ritl_contentOffSetX
{
    [self setRitl_contentOffSetX:ritl_contentOffSetX animated:false];
}


-(void)setRitl_contentOffSetY:(CGFloat)ritl_contentOffSetY
{
    [self setRitl_contentOffSetY:ritl_contentOffSetY animated:false];
}


-(void)setRitl_contentOffSetX:(CGFloat)ritl_contentOffSetX animated:(BOOL)animated
{
    [self setContentOffset:CGPointMake(ritl_contentOffSetX, self.ritl_contentOffSetY) animated:animated];
}


-(void)setRitl_contentOffSetY:(CGFloat)ritl_contentOffSetY animated:(BOOL)animated
{
    [self setContentOffset:CGPointMake(self.ritl_contentOffSetX, ritl_contentOffSetY) animated:animated];
}


-(void)setRitl_contentSizeWidth:(CGFloat)ritl_contentSizeWidth
{
    self.contentSize = CGSizeMake(ritl_contentSizeWidth, self.ritl_contentSizeHeight);
}


-(void)setRitl_contentSizeHeight:(CGFloat)ritl_contentSizeHeight
{
    self.contentSize = CGSizeMake(self.ritl_contentSizeWidth, ritl_contentSizeHeight);
}


@end
