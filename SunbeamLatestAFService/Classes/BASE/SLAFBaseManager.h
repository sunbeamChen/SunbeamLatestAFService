//
//  SLAFBaseManager.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>
#import "SLAFServiceProperty.h"
#import "SLAFRequest.h"
#import "SLAFResponse.h"

@class SLAFBaseManager;

#pragma mark - API唯一标识
@protocol SLAFManagerProtocol <NSObject>

@required
// 统一资源标识符
- (NSString *) URI;

// 当前请求标识
- (NSString *) identifier;

// 当前请求方法
- (SLAF_REQUEST_METHOD) method;

@optional
// 请求完毕后，清除所有数据
- (void) cleanData;

@end

#pragma mark - 请求参数
@protocol SLAFRequestParams <NSObject>

@required
// 请求参数
- (NSDictionary *) requestParams;

@end

#pragma mark - 请求参数合法性检查
@protocol SLAFRequestParamsValidator <NSObject>

@optional
// 请求参数合法性检查
- (NSError *) requestParamsValidate;

@end

#pragma mark - 请求操作拦截器
@protocol SLAFRequestInterceptor <NSObject>

@optional
// 请求成功
- (void) interceptorForRequestSuccess:(SLAFBaseManager *) manager;

// 请求失败
- (void) interceptorForRequestFailed:(SLAFBaseManager *) manager;

@end

#pragma mark - 响应结果格式化
@protocol SLAFResponseDataFormatter <NSObject>

@optional
// 响应结果格式化(默认格式化为JSON格式)
- (id) responseDataFormat;

@end

#pragma mark - 响应结果格式化后合法性检查
@protocol SLAFResponseDataValidator <NSObject>

@optional
// 响应结果格式化后的数据进行合法性检查
- (BOOL) responseDataValidate;

@end

@interface SLAFBaseManager : NSObject

@property (nonatomic, weak) NSObject<SLAFManagerProtocol>* childManager;

@property (nonatomic, weak) id<SLAFRequestParams> requestParams;

@property (nonatomic, weak) id<SLAFRequestParamsValidator> requestParamsValidator;

@property (nonatomic, weak) id<SLAFRequestInterceptor> requestInterceptor;

@property (nonatomic, weak) id<SLAFResponseDataFormatter> responseDataFormatter;

@property (nonatomic, weak) id<SLAFResponseDataValidator> responseDataValidator;

@property (nonatomic, strong) SLAFRequest* managerRequest;

@property (nonatomic, strong) SLAFResponse* managerResponse;

// 数据请求入口
- (NSNumber *) loadDataTask:(void(^)(NSString* identifier, id responseObject, NSError* error)) completion;

// 上传请求入口
- (NSNumber *) loadUploadTask:(NSMutableDictionary *) uploadFiles uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgress completion:(void(^)(NSString* identfier, id responseObject, NSError* error)) completion;

// 下载请求入口
- (NSNumber *) loadDownloadTask:(void (^)(NSProgress *uploadProgress)) downloadProgress completion:(void(^)(NSString* identfier, NSURL* downloadFileurl, NSError* error)) completion;

@end
