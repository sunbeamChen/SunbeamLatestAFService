//
//  SLAFServiceContext.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>
#import "SLAFServiceFactory.h"

// 网络类型
typedef enum : NSUInteger {
    UNKNOWN             = -1,   // 未知
    NOT_REACHABLE       = 0,    // 不可达
    REACHABLE_VIA_WWAN  = 1,    // 蜂窝流量
    REACHABLE_VIA_WIFI  = 2,    // wifi
} SLAF_NETWORK_STATUS;

// 网络状态发生变化时发送notification
#define SLAF_NETWORK_STATUS_CHANGED_NOTIFICATION_NAME @"slaf_network_status_changed_notification"

@interface SLAFServiceContext : NSObject

/**
 单例

 @return SLAFServiceContext
 */
+ (SLAFServiceContext *) sharedSLAFServiceContext;

/**
 网络请求超时时间设置
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 网络是否可达
 */
@property (nonatomic, assign, readonly) BOOL networkIsReachable;

/**
 当前网络状态
 */
@property (nonatomic, assign, readonly) SLAF_NETWORK_STATUS networkStatus;

/**
 监听网络状态改变

 @param networkStatusChangeBlock 网络状态改变回调
 */
- (void) startListenNetworkStatusChange:(void(^)(SLAF_NETWORK_STATUS networkStatus)) networkStatusChangeBlock;

/**
 设置SLAF service factory代理

 @param serviceFactoryDelegate SLAFServiceFactoryDelegate
 */
- (void) setSLAFServiceFactoryDelegate:(id<SLAFServiceFactoryProtocol>) SLAFServiceFactoryDelegate;

@end
