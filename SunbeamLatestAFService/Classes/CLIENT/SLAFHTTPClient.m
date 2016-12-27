//
//  SLAFHTTPClient.m
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import "SLAFHTTPClient.h"
#import "SLAFHTTPService.h"
#import "SLAFRequestGenerator.h"
#import "SLAFResponseConstructor.h"

@interface SLAFHTTPClient()

/**
 请求id
 */
@property (nonatomic, strong) NSNumber* requestId;

/**
 session任务列表 {"requestId":NSURLSessionTask}
 */
@property (nonatomic, strong) NSMutableDictionary* sessionTaskQueue;

@end

@implementation SLAFHTTPClient

/**
 单例实现

 @return SLAFHTTPClient
 */
+ (SLAFHTTPClient *) sharedSLAFHTTPClient
{
    static SLAFHTTPClient *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        NSLog(@"\n==========================================\nSunbeam Latest AFService version is %@\n==========================================", SLAF_SERVICE_VERSION);
    });
    return sharedInstance;
}

- (NSNumber *)loadDataTask:(NSString *)URI identifier:(NSString *)identifier method:(SLAF_REQUEST_METHOD)method params:(NSDictionary *)params completion:(void (^)(SLAFResponse *))completion
{
    SLAFRequest* request = [SLAFRequestGenerator generateSLAFRequest:method identifier:identifier URI:URI requestParams:params uploadFiles:nil];
    NSNumber* requestId = [self generateRequestId];
    NSLog(@"\n==========================================begin>>>https GET/POST请求序号:%@\nhttps GET/POST请求url：%@\nhttps GET/POST请求header：%@\nhttps GET/POST请求body：%@", requestId, request.urlString, request.request.allHTTPHeaderFields, [[NSString alloc] initWithData:request.request.HTTPBody encoding:NSUTF8StringEncoding]);
    self.sessionTaskQueue[requestId] = [[[SLAFHTTPService alloc] init] loadDataTask:request completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (response) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
            NSLog(@"\n==========================================response>>>https GET/POST请求序号:%@\nhttps GET/POST请求响应status code：%@, error：%@", requestId, @(httpResponse.statusCode), error);
        } else {
            NSLog(@"\n==========================================response>>>https GET/POST请求序号:%@\nhttps GET/POST请求响应error：%@", requestId, error);
        }
        //NSLog(@"\nhttps GET/POST请求响应原始数据：%@", responseObject);
        
        NSURLSessionDataTask* dataTask = self.sessionTaskQueue[requestId];
        if (dataTask == nil) {
            // 请求已被取消
            return ;
        } else {
            [self.sessionTaskQueue removeObjectForKey:requestId];
        }
        // 根据返回结果构造SLAFResponse
        SLAFResponse* slafResponse = [SLAFResponseConstructor constructSLAFResponse:requestId urlResponse:response responseObject:responseObject error:error downloadFileUrl:nil];
        completion(slafResponse);
    }];
    return requestId;
}

- (NSNumber *)loadUploadTask:(NSString *)URI identifier:(NSString *)identifier method:(SLAF_REQUEST_METHOD)method params:(NSDictionary *)params uploadFiles:(NSMutableDictionary *) uploadFiles uploadProgress:(void (^)(NSProgress *))uploadProgressBlock completion:(void (^)(SLAFResponse *))completion
{
    SLAFRequest* request = [SLAFRequestGenerator generateSLAFRequest:method identifier:identifier URI:URI requestParams:params uploadFiles:uploadFiles];
    NSNumber* requestId = [self generateRequestId];
    self.sessionTaskQueue[requestId] = [[[SLAFHTTPService alloc] init] loadUploadTask:request uploadProgress:uploadProgressBlock completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSURLSessionDataTask* dataTask = self.sessionTaskQueue[requestId];
        if (dataTask == nil) {
            // 请求已被取消
            return ;
        } else {
            [self.sessionTaskQueue removeObjectForKey:requestId];
        }
        // 根据返回结果构造SLAFResponse
        SLAFResponse* slafResponse = [SLAFResponseConstructor constructSLAFResponse:requestId urlResponse:response responseObject:responseObject error:error downloadFileUrl:nil];
        completion(slafResponse);
    }];
    return requestId;
}

- (NSNumber *)loadDownloadTask:(NSString *)URI identifier:(NSString *)identifier method:(SLAF_REQUEST_METHOD)method params:(NSDictionary *)params downloadProgress:(void (^)(NSProgress *))downloadProgressBlock completion:(void (^)(SLAFResponse *))completion
{
    SLAFRequest* request = [SLAFRequestGenerator generateSLAFRequest:method identifier:identifier URI:URI requestParams:params uploadFiles:nil];
    NSNumber* requestId = [self generateRequestId];
    self.sessionTaskQueue[requestId] = [[[SLAFHTTPService alloc] init] loadDownloadTask:request downloadProgress:downloadProgressBlock completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSURLSessionDataTask* dataTask = self.sessionTaskQueue[requestId];
        if (dataTask == nil) {
            // 请求已被取消
            return ;
        } else {
            [self.sessionTaskQueue removeObjectForKey:requestId];
        }
        // 根据返回结果构造SLAFResponse
        SLAFResponse* slafResponse = [SLAFResponseConstructor constructSLAFResponse:requestId urlResponse:response responseObject:nil error:error downloadFileUrl:filePath];
        completion(slafResponse);
    }];
    return requestId;
}

- (void)cancelAllRequest
{
    for (NSNumber* requestId in [self.sessionTaskQueue allKeys]) {
        [self cancelRequest:requestId];
    }
}

- (void)cancelRequest:(NSNumber *)requestId
{
    NSURLSessionTask* sessionTask = [self.sessionTaskQueue objectForKey:requestId];
    if (sessionTask) {
        [sessionTask cancel];
        [self.sessionTaskQueue removeObjectForKey:requestId];
    }
}

#pragma mark - private methods
- (NSNumber *)generateRequestId
{
    @synchronized (self) {
        if (_requestId == nil) {
            _requestId = @(1);
        } else {
            if ([_requestId integerValue] == NSIntegerMax) {
                _requestId = @(1);
            } else {
                _requestId = @([_requestId integerValue] + 1);
            }
        }
        
        return _requestId;
    }
}

- (NSMutableDictionary *)sessionTaskQueue
{
    if (_sessionTaskQueue == nil) {
        _sessionTaskQueue = [[NSMutableDictionary alloc] init];
    }
    
    return _sessionTaskQueue;
}

@end
