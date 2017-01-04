//
//  SLAFRequest.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>
#import "SLAFServiceProperty.h"

@interface SLAFRequest : NSObject

@property (nonatomic, assign) SLAF_REQUEST_METHOD method;

@property (nonatomic, strong) NSMutableURLRequest* request;

@property (nonatomic, copy) NSString* urlString;

@property (nonatomic, assign) BOOL useSSLCertificates;

@property (nonatomic, strong) NSDictionary* headerParams;

@property (nonatomic, strong) NSDictionary* urlParams;

@property (nonatomic, strong) NSDictionary* bodyParams;

@property (nonatomic, strong) NSMutableDictionary* uploadFiles;

@property (nonatomic, copy) NSString* downloadUrl;

/**
 构造SLAFRequest对象

 @param method 请求方法
 @param request 请求实例
 @param urlString 请求url
 @param useSSLCertificates 是否使用安全策略
 @param headerParams 请求参数header
 @param urlParams 请求参数url
 @param bodyParams 请求参数body
 @param uploadFiles 上传文件字典{'fileKey':'localFilePath'}
 @param downloadUrl 下载文件的地址
 @return SLAFRequest
 */
+ (SLAFRequest *) getSLAFRequest:(SLAF_REQUEST_METHOD) method request:(NSMutableURLRequest *) request urlString:(NSString *) urlString useSSLCertificates:(BOOL) useSSLCertificates headerParams:(NSDictionary *) headerParams urlParams:(NSDictionary *) urlParams bodyParams:(NSDictionary *) bodyParams uploadFiles:(NSMutableDictionary *) uploadFiles downloadUrl:(NSString *) downloadUrl;

@end
