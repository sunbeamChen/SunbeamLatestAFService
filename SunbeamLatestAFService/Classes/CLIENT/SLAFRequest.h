//
//  SLAFRequest.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>
#import "../BASE/SLAFServiceProperty.h"

@interface SLAFRequest : NSObject

// 请求类型
@property (nonatomic, assign) SLAF_REQUEST_METHOD method;

// 请求实例
@property (nonatomic, strong) NSMutableURLRequest* request;

// 请求url
@property (nonatomic, copy) NSString* urlString;

// security ssl cer file path
@property (nonatomic, assign) BOOL useSSLCertificates;

// header请求参数
@property (nonatomic, strong) NSMutableDictionary* headerParams;

// url请求参数
@property (nonatomic, strong) NSMutableDictionary* urlParams;

// body请求参数
@property (nonatomic, strong) NSMutableDictionary* bodyParams;

// upload文件上传地址 {'fileKey':'localFilePath'}
@property (nonatomic, strong) NSDictionary* uploadFiles;

// 获取请求实例对象
+ (SLAFRequest *) getSLAFRequest:(SLAF_REQUEST_METHOD) method request:(NSMutableURLRequest *) request urlString:(NSString *) urlString useSSLCertificates:(BOOL) useSSLCertificates headerParams:(NSMutableDictionary *) headerParams urlParams:(NSMutableDictionary *) urlParams bodyParams:(NSMutableDictionary *) bodyParams uploadFiles:(NSDictionary *) uploadFiles;

@end
