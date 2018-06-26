//
//  NSBundle+RITLPhotos.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/6/26.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "NSBundle+RITLPhotos.h"

@interface NSString (RITLPhotosBundle)

@property (nonatomic, strong, readonly, nullable) UIImage * ritl_bundleImage;

@end

@implementation NSString (RITLPhotosBundle)

- (UIImage *)ritl_bundleImage
{
    return [UIImage imageWithContentsOfFile:[[NSBundle.ritl_bundle resourcePath] stringByAppendingPathComponent:self]];
}

@end

@implementation NSBundle (RITLPhotos)

+ (NSBundle *)ritl_bundle
{
    static NSBundle *ritl_bundle = nil;
    
    if (ritl_bundle == nil) {
        
        ritl_bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"RITLPhotosViewController")]pathForResource:@"RITLPhotos" ofType:@"bundle"]];
    }
    
    return ritl_bundle;
}


+ (UIImage *)ritl_arrow_right
{
    return @"ritl_arrow_right".ritl_bundleImage;
}

+ (UIImage *)ritl_placeholder
{
    return @"ritl_placeholder".ritl_bundleImage;
}

+ (UIImage *)ritl_browse_back
{
    return @"ritl_browse_back".ritl_bundleImage;
}


+ (UIImage *)ritl_deselect
{
    return @"ritl_deselect".ritl_bundleImage;
}

+ (UIImage *)ritl_brower_selected
{
    return @"ritl_brower_selected".ritl_bundleImage;
}

+ (UIImage *)ritl_bottomSelected
{
    return @"ritl_bottomSelected".ritl_bundleImage;
}

+ (UIImage *)ritl_bottomUnselected
{
    return @"ritl_bottomUnselected".ritl_bundleImage;
}

+ (UIImage *)ritl_video_play
{
    return @"ritl_video_play".ritl_bundleImage;
}

@end
