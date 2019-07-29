/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Basic demonstration of how to use the SystemConfiguration Reachablity APIs.
 */

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>



/// Deprecated: 避免与其他的枚举冲突,将在后面的版本删除
//typedef enum : NSInteger {
//    NotReachable = 0,
//    ReachableViaWiFi,
//    ReachableViaWWAN
//} AppleNetworkStatus;
//
//

typedef enum : NSInteger {
    AppleNotReachable = 0,
    AppleReachableViaWiFi,
    AppleReachableViaWWAN
} AppleNetworkStatus;

#pragma mark IPv6 Support
//Reachability fully support IPv6.  For full details, see ReadMe.md.


extern NSString *AppleReachabilityChangedNotification;


@interface AppleReachability : NSObject

/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;


#pragma mark reachabilityForLocalWiFi
//reachabilityForLocalWiFi has been removed from the sample.  See ReadMe.md for more information.
//+ (instancetype)reachabilityForLocalWiFi;

/*!
 * Start listening for reachability notifications on the current run loop.
 */
- (BOOL)startNotifier;
- (void)stopNotifier;

- (AppleNetworkStatus)currentReachabilityStatus;

/*!
 * WWAN may be available, but not active until a connection has been established. WiFi may require a connection for VPN on Demand.
 */
- (BOOL)connectionRequired;

@end


