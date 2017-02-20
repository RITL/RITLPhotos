//
//  YPPhotoStoreConfiguraion.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoStoreConfiguraion.h"


NSString * ConfigurationCameraRoll = @"Camera Roll";
NSString * ConfigurationAllPhotos = @"All Photos";
NSString * ConfigurationHidden = @"Hidden";
NSString * ConfigurationSlo_mo = @"Slo-mo";
NSString * ConfigurationScreenshots = @"Screenshots";
NSString * ConfigurationVideos = @"Videos";
NSString * ConfigurationPanoramas = @"Panoramas";
NSString * ConfigurationTime_lapse = @"Time-lapse";
NSString * ConfigurationRecentlyAdded = @"Recently Added";
NSString * ConfigurationRecentlyDeleted = @"Recently Deleted";
NSString * ConfigurationBursts = @"Bursts";
NSString * ConfigurationFavorite = @"Favorite";
NSString * ConfigurationSelfies = @"Selfies";


static NSArray <NSString *>*  groupNames;

@implementation RITLPhotoStoreConfiguraion

+(void)initialize
{
    if (self == [RITLPhotoStoreConfiguraion class])
    {
    
        groupNames = @[NSLocalizedString(ConfigurationCameraRoll, @""),
                   NSLocalizedString(ConfigurationAllPhotos, @""),
                   NSLocalizedString(ConfigurationSlo_mo, @""),
                   NSLocalizedString(ConfigurationScreenshots, @""),
                   NSLocalizedString(ConfigurationVideos, @""),
                   NSLocalizedString(ConfigurationPanoramas, @""),
                   NSLocalizedString(ConfigurationRecentlyAdded, @""),
                   NSLocalizedString(ConfigurationSelfies, @"")];
    }
}

-(NSArray *)groupNamesConfig
{
    return groupNames;
}

-(void)setGroupNames:(NSArray<NSString *> *)newGroupNames
{
    groupNames = newGroupNames;
    
    [self localizeHandle];
}

//初始化方法
-(instancetype)initWithGroupNames:(NSArray<NSString *> *)groupNames
{
    if (self = [super init])
    {
        [self setGroupNames:groupNames];
    }
    
    return self;
}


+(instancetype)storeConfigWithGroupNames:(NSArray<NSString *> *)groupNames
{
    return [[self alloc]initWithGroupNames:groupNames];
}



/** 本地化语言处理 */
- (void)localizeHandle
{
    NSMutableArray <NSString *> * localizedHandle = [NSMutableArray arrayWithArray:groupNames];
    
    for (NSUInteger i = 0; i < localizedHandle.count; i++)
    {
        [localizedHandle replaceObjectAtIndex:i withObject:NSLocalizedString(localizedHandle[i], @"")];
    }
    
    groupNames = [NSArray arrayWithArray:localizedHandle];
}


@end



