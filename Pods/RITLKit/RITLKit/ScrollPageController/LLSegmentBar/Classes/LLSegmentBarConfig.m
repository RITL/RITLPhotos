//
//  LLSegmentBarConfig.m
//  LLSegmentBar
//
//  Created by liushaohua on 2017/6/3.
//  Copyright © 2017年 416997919@qq.com. All rights reserved.
//

#import "LLSegmentBarConfig.h"

@implementation LLSegmentBarConfig

+ (instancetype)defaultConfig {
    LLSegmentBarConfig *config = [[LLSegmentBarConfig alloc] init];
    config.sBBackColor = [UIColor clearColor];
    config.itemF = [UIFont systemFontOfSize:15];
    config.itemNC = [UIColor lightGrayColor];
    config.itemBC = UIColor.clearColor;
    config.itemRa = 0;
    config.itemSC = [UIColor redColor];
    config.indicatorC = [UIColor redColor];
    config.indicatorH = 2;
    config.indicatorW = 10;
    config.indicatorRadius = 0;
    return config;
    
}

- (LLSegmentBarConfig *(^)(UIColor *))segmentBarBackColor{
    return ^(UIColor *color){
        self.sBBackColor = color;
        return self;
    };
}

- (LLSegmentBarConfig *(^)(UIFont *))itemFont{
    return ^(UIFont *font){
        self.itemF = font;
        return self;
    };
}


- (LLSegmentBarConfig *(^)(CGFloat))itemRadius
{
    return ^(CGFloat r){
      
        self.itemRa = r;
        return self;
    };
}

- (LLSegmentBarConfig *(^)(UIColor *))itemNormalColor{
    return ^(UIColor *color){
        self.itemNC = color;
        return self;
    };
}

- (LLSegmentBarConfig *(^)(UIColor *))itemSelectColor{
    return ^(UIColor *color){
        self.itemSC = color;
        return self;
    };
}

- (LLSegmentBarConfig *(^)(UIColor *))itemBackColor
{
    return ^(UIColor *color){
      
        self.itemBC = color;
        return self;
    };
}

- (LLSegmentBarConfig *(^)(UIColor *))indicatorColor{
    return ^(UIColor *color){
        self.indicatorC = color;
        return self;
    };
}

- (LLSegmentBarConfig *(^)(CGFloat))indicatorHeight{
    return ^(CGFloat H){
        self.indicatorH = H;
        return self;
    };
}

- (LLSegmentBarConfig *(^)(CGFloat))indicatorExtraW{
    return ^(CGFloat W){
        self.indicatorW = W;
        return self;
    };
}

- (LLSegmentBarConfig *(^)(CGFloat))indicatorRadiusR
{
    return ^(CGFloat R){
      
        self.indicatorRadius = R;
        return self;
    };
}


@end
