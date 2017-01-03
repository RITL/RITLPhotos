//
//  UIViewController+Frame.m
//  YOpenFiles
//
//  Created by YueWen on 16/6/17.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "UIViewController+Frame.h"

@implementation UIViewController (Frame)

-(NSUInteger)width
{
    return self.view.bounds.size.width;
}

-(NSUInteger)height
{
    return self.view.bounds.size.height;
}

-(CGFloat)originX
{
    return self.view.frame.origin.x;
}

-(CGFloat)originY
{
    return self.view.frame.origin.y;
}

-(CGPoint)center
{
    return self.view.center;
}

-(CGFloat)centerX
{
    return self.center.x;
}

-(CGFloat)centerY
{
    return self.center.y;
}

-(CGRect)bounds
{
    return self.view.bounds;
}

@end


@implementation UIScreen (Frame)

-(NSUInteger)width
{
    return self.bounds.size.width;
}

-(NSUInteger)height
{
    return self.bounds.size.height;
}

@end
