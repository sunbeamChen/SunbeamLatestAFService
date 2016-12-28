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

@property (nonatomic, strong) NSNumber* requestId;

@property (nonatomic, strong) NSMutableDictionary* sessionTaskQueue;

@end

@implementation SLAFHTTPClient

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
            return ;
        } else {
            [self.sessionTaskQueue removeObjectForKey:requestId];
        }
        SLAFResponse* slafResponse = [SLAFResponseConstructor constructSLAFResponse:requestId urlResponse:response responseObject:responseObject error:error downloadFileUrl:nil];
        completion(slafResponse);
    }];
    
    return requestId;
}

- (NSNumber *)loadUploadTask:(NSString *)URI identifier:(NSString *)identifier method:(SLAF_REQUEST_METHOD)method params:(NSDictionary *)params uploadFiles:(NSMutableDictionary *) uploadFiles uploadProgressBlock:(void (^)(NSProgress *))uploadProgressBlock completion:(void (^)(SLAFResponse *))completion
{
    SLAFRequest* request = [SLAFRequestGenerator generateSLAFRequest:method identifier:identifier URI:URI requestParams:params uploadFiles:uploadFiles];
    
    NSNumber* requestId = [self generateRequestId];
    self.sessionTaskQueue[requestId] = [[[SLAFHTTPService alloc] init] loadUploadTask:request uploadProgressBlock:uploadProgressBlock completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSURLSessionDataTask* dataTask = self.sessionTaskQueue[requestId];
        if (dataTask == nil) {
            return ;
        } else {
            [self.sessionTaskQueue removeObjectForKey:requestId];
        }
        SLAFResponse* slafResponse = [SLAFResponseConstructor constructSLAFResponse:requestId urlResponse:response responseObject:responseObject error:error downloadFileUrl:nil];
        completion(slafResponse);
    }];
    
    return requestId;
}

- (NSNumber *)loadDownloadTask:(NSString *)URI identifier:(NSString *)identifier method:(SLAF_REQUEST_METHOD)method params:(NSDictionary *)params downloadProgressBlock:(void (^)(NSProgress *))downloadProgressBlock completion:(void (^)(SLAFResponse *))completion
{
    SLAFRequest* request = [SLAFRequestGenerator generateSLAFRequest:method identifier:identifier URI:URI requestParams:params uploadFiles:nil];
    
    NSNumber* requestId = [self generateRequestId];
    self.sessionTaskQueue[requestId] = [[[SLAFHTTPService alloc] init] loadDownloadTask:request downloadProgressBlock:downloadProgressBlock completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSURLSessionDataTask* dataTask = self.sessionTaskQueue[requestId];
        if (dataTask == nil) {
            return ;
        } else {
            [self.sessionTaskQueue removeObjectForKey:requestId];
        }
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
