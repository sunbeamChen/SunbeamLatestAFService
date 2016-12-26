//
//  SLAFHTTPClient.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>
#import "SLAFServiceProperty.h"
#import "SLAFResponse.h"

#define SLAF_SERVICE_VERSION @"0.1.12"

@interface SLAFHTTPClient : NSObject

/**
 session任务列表 {"requestId":NSURLSessionTask}
 */
@property (nonatomic, strong, readonly) NSMutableDictionary* sessionTaskQueue;

/**
 单例

 @return SLAFHTTPClient
 */
+ (SLAFHTTPClient *) sharedSLAFHTTPClient;

/**
 Get/Post

 @param URI 统一资源定位符
 @param identifier 标识
 @param method 方法
 @param params 参数
 @param completion 回调
 @return 当前请求唯一标识
 */
- (NSNumber *) loadDataTask:(NSString *) URI identifier:(NSString *) identifier method:(SLAF_REQUEST_METHOD) method params:(NSDictionary *) params completion:(void (^)(SLAFResponse* response)) completion;

/**
 Upload

 @param URI 统一资源定位符
 @param identifier 标识
 @param method 方法
 @param params 参数
 @param uploadProgressBlock 上传进程
 @param completion 回调
 @return 当前请求唯一标识
 */
- (NSNumber *) loadUploadTask:(NSString *) URI identifier:(NSString *) identifier method:(SLAF_REQUEST_METHOD) method params:(NSDictionary *) params uploadFiles:(NSMutableDictionary *) uploadFiles uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock completion:(void (^)(SLAFResponse* response)) completion;

/**
 Download

 @param URI 统一资源定位符
 @param identifier 标识
 @param method 方法
 @param params 参数
 @param downloadProgressBlock 下载进程
 @param completion 回调
 @return 当前请求唯一标识
 */
- (NSNumber *) loadDownloadTask:(NSString *) URI identifier:(NSString *) identifier method:(SLAF_REQUEST_METHOD) method params:(NSDictionary *) params downloadProgress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock completion:(void (^)(SLAFResponse* response)) completion;

/**
 取消所有网络请求
 */
- (void) cancelAllRequest;

/**
 取消指定requestId的网络请求

 @param requestId 请求唯一标识
 */
- (void) cancelRequest:(NSNumber *) requestId;

@end
