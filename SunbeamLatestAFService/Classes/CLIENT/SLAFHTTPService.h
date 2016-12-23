//
//  SLAFHTTPService.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "SLAFRequest.h"

@interface SLAFHTTPService : NSObject

/**
 GET/POST

 @param request 请求
 @param completion 回调
 @return 当前请求唯一标识
 */
- (NSURLSessionDataTask *) loadDataTask:(SLAFRequest *) slafRequest completion:(void (^)(NSURLResponse* response, id responseObject,  NSError* error)) completion;

/**
 Upload

 @param request 请求
 @param uploadProgressBlock 上传进程
 @param completion 回调
 @return 当前请求唯一标识
 */
- (NSURLSessionUploadTask *) loadUploadTask:(SLAFRequest *) slafRequest uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock completion:(void (^)(NSURLResponse* response, id responseObject,  NSError* error)) completion;

/**
 Download

 @param request 请求
 @param downloadProgressBlock 下载进程
 @param completion 回调
 @return 当前请求唯一标识
 */
- (NSURLSessionDownloadTask *) loadDownloadTask:(SLAFRequest *) slafRequest downloadProgress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock completion:(void (^)(NSURLResponse* response, NSURL* filePath, NSError* error)) completion;

@end
