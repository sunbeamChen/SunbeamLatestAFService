//
//  SLAFBaseManager.m
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import "SLAFBaseManager.h"
#import "SLAFServiceContext.h"
#import "SLAFServiceProperty.h"
#import "SLAFHTTPClient.h"

#define SAF_REQUEST_ID_DEFAULT 0

@interface SLAFBaseManager()

@end

@implementation SLAFBaseManager

- (instancetype)init
{
    if (self = [super init]) {
        if ([self conformsToProtocol:@protocol(SLAFManagerProtocol)]) {
            _childManager = (id<SLAFManagerProtocol>) self;
        } else {
            NSLog(@"%@不符合SLAFManagerProtocol", self);
        }
        _requestParams = nil;
        _requestParamsValidator = nil;
        _requestInterceptor = nil;
        _responseDataFormatter = nil;
        _responseDataValidator = nil;
        _managerRequest = nil;
        _managerResponse = nil;
    }
    
    return self;
}

/**
 实例资源释放
 */
- (void)dealloc
{
    [[SLAFHTTPClient sharedSLAFHTTPClient] cancelAllRequest];
    _managerRequest = nil;
    _managerResponse = nil;
}

/**
 数据请求入口

 @param completion 回调
 @return 请求id
 */
- (NSNumber *) loadDataTask:(void(^)(NSString* identifier, id responseObject, NSError* error)) completion
{
    // 网络检测等
    NSError* error = [self beforeRequest];
    if (error != nil) {
        // 请求失败处理
        completion(self.childManager.identifier, nil, error);
        return SAF_REQUEST_ID_DEFAULT;
    }
    // 获取请求参数
    NSDictionary* params = [self.requestParams requestParams];
    // 发起请求
    __weak __typeof__(self) weakSelf = self;
    if (self.childManager.method == GET || self.childManager.method == POST) {
        // get请求、post请求
        return [[SLAFHTTPClient sharedSLAFHTTPClient] loadDataTask:self.childManager.URI identifier:self.childManager.identifier method:self.childManager.method params:params completion:^(SLAFResponse *response) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            if (response.error == nil) {
                // 成功
                id jsonData = [strongSelf formatResponseData];
                completion(strongSelf.childManager.identifier, jsonData, nil);
                if (strongSelf.requestInterceptor && [strongSelf.requestInterceptor respondsToSelector:@selector(interceptorForRequestSuccess:)]) {
                    [strongSelf.requestInterceptor interceptorForRequestSuccess:strongSelf];
                }
            } else {
                // 失败
                completion(strongSelf.childManager.identifier, nil, response.error);
                if (strongSelf.requestInterceptor && [strongSelf.requestInterceptor respondsToSelector:@selector(interceptorForRequestFailed:)]) {
                    [strongSelf.requestInterceptor interceptorForRequestFailed:strongSelf];
                }
            }
        }];
    } else {
        completion(self.childManager.identifier, nil, [NSError errorWithDomain:SLAF_ERROR_DOMAIN code:REQUEST_METHOD_NOT_SUPPORT userInfo:@{NSLocalizedDescriptionKey:@"request method not support"}]);
        return SAF_REQUEST_ID_DEFAULT;
    }
}

// 上传请求入口
- (NSNumber *) loadUploadTask:(NSMutableDictionary *) uploadFiles uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgress completion:(void(^)(NSString* identfier, id responseObject, NSError* error)) completion
{
    // 网络检测等
    NSError* error = [self beforeRequest];
    if (error != nil) {
        // 请求失败处理
        completion(self.childManager.identifier, nil, error);
        return SAF_REQUEST_ID_DEFAULT;
    }
    // 获取请求参数
    NSDictionary* params = [self.requestParams requestParams];
    // 发起请求
    __weak __typeof__(self) weakSelf = self;
    // 上传
    return [[SLAFHTTPClient sharedSLAFHTTPClient] loadUploadTask:self.childManager.URI identifier:self.childManager.identifier method:self.childManager.method params:params uploadFiles:uploadFiles uploadProgress:uploadProgress completion:^(SLAFResponse *response) {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        if (response.error == nil) {
            // 成功
            id jsonData = [strongSelf formatResponseData];
            completion(strongSelf.childManager.identifier, jsonData, nil);
            if (strongSelf.requestInterceptor && [strongSelf.requestInterceptor respondsToSelector:@selector(interceptorForRequestSuccess:)]) {
                [strongSelf.requestInterceptor interceptorForRequestSuccess:strongSelf];
            }
        } else {
            // 失败
            completion(strongSelf.childManager.identifier, nil, response.error);
            if (strongSelf.requestInterceptor && [strongSelf.requestInterceptor respondsToSelector:@selector(interceptorForRequestFailed:)]) {
                [strongSelf.requestInterceptor interceptorForRequestFailed:strongSelf];
            }
        }
    }];
}

// 下载请求入口
- (NSNumber *) loadDownloadTask:(void (^)(NSProgress *uploadProgress)) downloadProgress completion:(void(^)(NSString* identfier, NSURL* downloadFileurl, NSError* error)) completion
{
    // 网络检测等
    NSError* error = [self beforeRequest];
    if (error != nil) {
        // 请求失败处理
        completion(self.childManager.identifier, nil, error);
        return SAF_REQUEST_ID_DEFAULT;
    }
    // 获取请求参数
    NSDictionary* params = [self.requestParams requestParams];
    // 发起请求
    __weak __typeof__(self) weakSelf = self;
    // 下载
    return [[SLAFHTTPClient sharedSLAFHTTPClient] loadDownloadTask:self.childManager.URI identifier:self.childManager.identifier method:self.childManager.method params:params downloadProgress:downloadProgress completion:^(SLAFResponse *response) {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        if (response.error == nil) {
            // 成功
            completion(strongSelf.childManager.identifier, response.downloadFileUrl, nil);
            if (strongSelf.requestInterceptor && [strongSelf.requestInterceptor respondsToSelector:@selector(interceptorForRequestSuccess:)]) {
                [strongSelf.requestInterceptor interceptorForRequestSuccess:strongSelf];
            }
        } else {
            // 失败
            completion(strongSelf.childManager.identifier, nil, response.error);
            if (strongSelf.requestInterceptor && [strongSelf.requestInterceptor respondsToSelector:@selector(interceptorForRequestFailed:)]) {
                [strongSelf.requestInterceptor interceptorForRequestFailed:strongSelf];
            }
        }
    }];
}

#pragma mark - private method
/**
 检测网络参数等

 @return NSError
 */
- (NSError *) beforeRequest
{
    // 判断网络是否正常
    if (![[SLAFServiceContext sharedSLAFServiceContext] networkIsReachable])
    {
        return [NSError errorWithDomain:SLAF_ERROR_DOMAIN code:NETWORK_NOT_REACHABLE_ERROR userInfo:@{NSLocalizedDescriptionKey:@"network is not reachable"}];
    }
    // 判断当前是否有网络请求正在执行(取决于是否支持多个请求同时执行)
    if ([[SLAFHTTPClient sharedSLAFHTTPClient].sessionTaskQueue count] > 0)
    {
        //TODO:该处采取的策略是阻止新的请求，另外一种策略是取消旧的请求，执行新的请求(待实际测试判断)
        
        return [NSError errorWithDomain:SLAF_ERROR_DOMAIN code:REQUEST_RUNING_ERROR userInfo:@{NSLocalizedDescriptionKey:@"network request is busy"}];
    }
    // 判断网络请求参数是否合法，错误会返回NSError（由外部判断后返回）
    return [self.requestParamsValidator requestParamsValidate];
}

/**
 格式化响应数据

 @param formatter 格式化方法
 @return json
 */
- (id) formatResponseData
{
    // 如果formatter不为空，则默认外部进行格式化处理
    if (self.responseDataFormatter && [self.responseDataFormatter respondsToSelector:@selector(responseDataFormat)]) {
        return [self.responseDataFormatter responseDataFormat];
    }
    if (self.managerResponse.responseObject == nil || [self.managerResponse.responseObject length] == 0) {
        return nil;
    }
    NSError* error = nil;
    NSDictionary* returnDictionary = [NSJSONSerialization JSONObjectWithData:self.managerResponse.responseObject options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"网络请求数据NSJSONReadingAllowFragments格式化失败：%@", error);
        return nil;
    }
    return returnDictionary;
}

@end
