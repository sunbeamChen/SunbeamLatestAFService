//
//  SLAFServiceContext.m
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import "SLAFServiceContext.h"
#import <AFNetworking/AFNetworking.h>
#import "SLAFServiceProperty.h"

typedef void(^NetworkStatusChangeBlock)(SLAF_NETWORK_STATUS networkStatus);

@interface SLAFServiceContext()

/**
 网络是否可达
 */
@property (nonatomic, assign, readwrite) BOOL networkIsReachable;

/**
 当前网络状态
 */
@property (nonatomic, assign, readwrite) SLAF_NETWORK_STATUS networkStatus;

/**
 网络状态改变回调
 */
@property (nonatomic, strong) NetworkStatusChangeBlock networkStatusChangeBlock;

@end

@implementation SLAFServiceContext

/**
 单例实现
 
 @return SLAFServiceContext
 */
+ (SLAFServiceContext *) sharedSLAFServiceContext
{
    static SLAFServiceContext *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 SLAFServiceContext初始化相关操作

 @return SLAFServiceContext
 */
- (instancetype)init
{
    if (self = [super init]) {
        self.networkStatus = UNKNOWN;
        // 开启网络监听
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        __weak __typeof__(self) weakSelf = self;
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    self.networkStatus = UNKNOWN;
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    self.networkStatus = NOT_REACHABLE;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    self.networkStatus = REACHABLE_VIA_WWAN;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    self.networkStatus = REACHABLE_VIA_WIFI;
                    break;
                default:
                    break;
            }
            // 发送通知
            NSNotification *notificationPost = [NSNotification notificationWithName:SLAF_NETWORK_STATUS_CHANGED_NOTIFICATION_NAME object:self userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotification:notificationPost];
            });
            // 回调block
            if (strongSelf.networkStatusChangeBlock) {
                strongSelf.networkStatusChangeBlock(strongSelf.networkStatus);
            }
        }];
    }
    
    return self;
}

/**
 监听网络状态改变
 
 @param networkStatusChangeBlock 网络状态改变回调
 */
- (void) startListenNetworkStatusChange:(void(^)(SLAF_NETWORK_STATUS networkStatus)) networkStatusChangeBlock
{
    self.networkStatusChangeBlock = networkStatusChangeBlock;
}

/**
 设置SLAF service factory代理
 
 @param SLAFServiceFactoryDelegate SLAFServiceFactoryDelegate
 */
- (void) setSLAFServiceFactoryDelegate:(id<SLAFServiceFactoryProtocol>) SLAFServiceFactoryDelegate
{
    [SLAFServiceFactory sharedSLAFServiceFactory].delegate = SLAFServiceFactoryDelegate;
}

- (BOOL)networkIsReachable
{
    if (self.networkStatus == NOT_REACHABLE) {
        return NO;
    }
    
    return YES;
}

@end
