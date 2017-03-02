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

@property (nonatomic, assign, readwrite) BOOL networkIsReachable;

@property (nonatomic, assign, readwrite) SLAF_NETWORK_STATUS networkStatus;

@property (nonatomic, strong) NetworkStatusChangeBlock networkStatusChangeBlock;

@end

@implementation SLAFServiceContext

+ (SLAFServiceContext *) sharedSLAFServiceContext
{
    static SLAFServiceContext *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.networkStatus = UNKNOWN;
        // 设置网络请求默认超时时间
        self.timeoutInterval = 10.0;
        // 设置网络请求默认策略
        self.requestRunningStrategy = RUNNING_ALL;
        // 开启网络监听
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        __weak __typeof__(self) weakSelf = self;
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    strongSelf.networkStatus = UNKNOWN;
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    strongSelf.networkStatus = NOT_REACHABLE;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    strongSelf.networkStatus = REACHABLE_VIA_WWAN;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    strongSelf.networkStatus = REACHABLE_VIA_WIFI;
                    break;
                default:
                    break;
            }
            // 发送通知
            NSNotification *notificationPost = [NSNotification notificationWithName:SLAF_NETWORK_STATUS_CHANGED_NOTIFICATION_NAME object:strongSelf userInfo:nil];
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

- (void) startListenNetworkStatusChange:(void(^)(SLAF_NETWORK_STATUS networkStatus)) networkStatusChangeBlock
{
    self.networkStatusChangeBlock = networkStatusChangeBlock;
}

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
