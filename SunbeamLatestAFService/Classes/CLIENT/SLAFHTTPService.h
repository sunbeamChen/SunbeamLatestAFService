//
//  SLAFHTTPService.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>
#import "SLAFRequest.h"

@interface SLAFHTTPService : NSObject

/**
 GET/POST

 @param slafRequest 请求
 @param completion 回调
 @return NSURLSessionTask
 */
- (id) loadDataTask:(SLAFRequest *) slafRequest completion:(void (^)(NSURLResponse* response, id responseObject,  NSError* error)) completion;

/**
 Upload

 @param slafRequest 请求
 @param uploadProgressBlock 上传进程
 @param completion 回调
 @return NSURLSessionTask
 */
- (id) loadUploadTask:(SLAFRequest *) slafRequest uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock completion:(void (^)(NSURLResponse* response, id responseObject,  NSError* error)) completion;

/**
 Download

 @param slafRequest 请求
 @param downloadProgressBlock 下载进程
 @param completion 回调
 @return NSURLSessionTask
 */
- (id) loadDownloadTask:(SLAFRequest *) slafRequest downloadProgress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock completion:(void (^)(NSURLResponse* response, NSURL* filePath, NSError* error)) completion;

@end
