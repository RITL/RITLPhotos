//
//  PHImageRequestOptions+RITLPhotoRepresentation.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "PHImageRequestOptions+RITLPhotoRepresentation.h"

@implementation PHImageRequestOptions (RITLPhotoRepresentation)

+(instancetype)imageRequestOptionsWithDeliveryMode:(PHImageRequestOptionsDeliveryMode)deliverMode
{
    PHImageRequestOptions * option = [[self alloc] init];
    
    option.deliveryMode = deliverMode;
    
    return option;
}


@end
