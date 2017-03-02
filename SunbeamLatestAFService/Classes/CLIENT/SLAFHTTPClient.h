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
#import "SLAFHTTPSessionManager.h"

@interface SLAFHTTPClient : NSObject

/**
 Get/Post

 @param URI 统一资源定位符
 @param identifier 标识
 @param method 方法
 @param params 参数
 @param completion 回调
 @return 请求id
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
 @return 请求id
 */
- (NSNumber *) loadUploadTask:(NSString *) URI identifier:(NSString *) identifier method:(SLAF_REQUEST_METHOD) method params:(NSDictionary *) params uploadFiles:(NSMutableDictionary *) uploadFiles uploadProgressBlock:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock completion:(void (^)(SLAFResponse* response)) completion;

/**
 Download

 @param URI 统一资源定位符
 @param identifier 标识
 @param method 方法
 @param params 参数
 @param downloadUrl 下载地址
 @param downloadProgressBlock 下载进程
 @param completion 回调
 @return 请求id
 */
- (NSNumber *) loadDownloadTask:(NSString *) URI identifier:(NSString *) identifier method:(SLAF_REQUEST_METHOD) method params:(NSDictionary *) params downloadUrl:(NSString *) downloadUrl downloadProgressBlock:(void (^)(NSProgress *downloadProgress))downloadProgressBlock completion:(void (^)(SLAFResponse* response)) completion;

@end
