//
//  PHImageRequestOptions+RITLPhotos.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "PHImageRequestOptions+RITLPhotos.h"

@implementation PHImageRequestOptions (RITLPhotos)

+(instancetype)requestOptionsWithDeliveryMode:(PHImageRequestOptionsDeliveryMode)deliverMode
{
    PHImageRequestOptions * option = [[self alloc] init];
    
    option.deliveryMode = deliverMode;
    
    return option;
}


@end
