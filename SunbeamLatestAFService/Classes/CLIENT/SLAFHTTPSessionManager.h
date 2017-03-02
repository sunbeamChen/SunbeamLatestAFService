//
//  SLAFHTTPSessionManager.h
//  Pods
//
//  Created by sunbeam on 2017/3/2.
//
//

#import <Foundation/Foundation.h>

#define SLAF_SERVICE_VERSION @"0.1.20"

@interface SLAFHTTPSessionManager : NSObject

/**
 session任务列表 {"requestId":NSURLSessionTask}
 */
@property (nonatomic, strong) NSMutableDictionary* sessionTaskQueue;

/**
 单例
 
 @return SLAFHTTPClient
 */
+ (SLAFHTTPSessionManager *) sharedSLAFHTTPSessionManager;

/**
 获取请求id(自增长)

 @return 请求id
 */
- (NSNumber *) generateRequestId;

/**
 当前是否有请求正在运行

 @return yes/no
 */
- (BOOL) requestIsRunning;

/**
 停止运行所有网络请求
 */
- (void) cancelAllRequest;

/**
 停止运行指定requestId的网络请求
 
 @param requestId 请求id
 */
- (void) cancelRequest:(NSNumber *) requestId;

/**
 移除所有网络请求对象
 */
- (void) removeAllRequest;

/**
 移除指定requestId的请求对象

 @param requestId 请求id
 */
- (void) removeRequest:(NSNumber *) requestId;

@end
