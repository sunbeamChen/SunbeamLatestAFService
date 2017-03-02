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

@end

@implementation SLAFHTTPClient

- (NSNumber *)loadDataTask:(NSString *)URI identifier:(NSString *)identifier method:(SLAF_REQUEST_METHOD)method params:(NSDictionary *)params completion:(void (^)(SLAFResponse *))completion
{
    SLAFRequest* request = [SLAFRequestGenerator generateSLAFRequest:method identifier:identifier URI:URI requestParams:params uploadFiles:nil downloadUrl:nil];
    
    NSNumber* requestId = [[SLAFHTTPSessionManager sharedSLAFHTTPSessionManager] generateRequestId];
    NSLog(@"\n==========================================begin>>>https GET/POST请求序号:%@\nhttps GET/POST请求url：%@\nhttps GET/POST请求header：%@\nhttps GET/POST请求body：%@", requestId, request.urlString, request.request.allHTTPHeaderFields, [[NSString alloc] initWithData:request.request.HTTPBody encoding:NSUTF8StringEncoding]);
    [SLAFHTTPSessionManager sharedSLAFHTTPSessionManager].sessionTaskQueue[requestId] = [[[SLAFHTTPService alloc] init] loadDataTask:request completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (response) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
            NSLog(@"\n==========================================response>>>https GET/POST请求序号:%@\nhttps GET/POST请求响应status code：%@, error：%@", requestId, @(httpResponse.statusCode), error);
        } else {
            NSLog(@"\n==========================================response>>>https GET/POST请求序号:%@\nhttps GET/POST请求响应error：%@", requestId, error);
        }
        //NSLog(@"\nhttps GET/POST请求响应原始数据：%@", responseObject);

        SLAFResponse* slafResponse = [SLAFResponseConstructor constructSLAFResponse:requestId urlResponse:response responseObject:responseObject error:error downloadFileUrl:nil];
        completion(slafResponse);
        
        [[SLAFHTTPSessionManager sharedSLAFHTTPSessionManager] removeRequest:requestId];
    }];
    
    return requestId;
}

- (NSNumber *)loadUploadTask:(NSString *)URI identifier:(NSString *)identifier method:(SLAF_REQUEST_METHOD)method params:(NSDictionary *)params uploadFiles:(NSMutableDictionary *) uploadFiles uploadProgressBlock:(void (^)(NSProgress *))uploadProgressBlock completion:(void (^)(SLAFResponse *))completion
{
    SLAFRequest* request = [SLAFRequestGenerator generateSLAFRequest:method identifier:identifier URI:URI requestParams:params uploadFiles:uploadFiles downloadUrl:nil];
    
    NSNumber* requestId = [[SLAFHTTPSessionManager sharedSLAFHTTPSessionManager] generateRequestId];
    [SLAFHTTPSessionManager sharedSLAFHTTPSessionManager].sessionTaskQueue[requestId] = [[[SLAFHTTPService alloc] init] loadUploadTask:request uploadProgressBlock:uploadProgressBlock completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        SLAFResponse* slafResponse = [SLAFResponseConstructor constructSLAFResponse:requestId urlResponse:response responseObject:responseObject error:error downloadFileUrl:nil];
        completion(slafResponse);
        
        [[SLAFHTTPSessionManager sharedSLAFHTTPSessionManager] removeRequest:requestId];
    }];
    
    return requestId;
}

- (NSNumber *)loadDownloadTask:(NSString *)URI identifier:(NSString *)identifier method:(SLAF_REQUEST_METHOD)method params:(NSDictionary *)params downloadUrl:(NSString *) downloadUrl downloadProgressBlock:(void (^)(NSProgress *))downloadProgressBlock completion:(void (^)(SLAFResponse *))completion
{
    SLAFRequest* request = [SLAFRequestGenerator generateSLAFRequest:method identifier:identifier URI:URI requestParams:params uploadFiles:nil downloadUrl:downloadUrl];
    
    NSNumber* requestId = [[SLAFHTTPSessionManager sharedSLAFHTTPSessionManager] generateRequestId];
    [SLAFHTTPSessionManager sharedSLAFHTTPSessionManager].sessionTaskQueue[requestId] = [[[SLAFHTTPService alloc] init] loadDownloadTask:request downloadProgressBlock:downloadProgressBlock completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        SLAFResponse* slafResponse = [SLAFResponseConstructor constructSLAFResponse:requestId urlResponse:response responseObject:nil error:error downloadFileUrl:filePath];
        completion(slafResponse);
        
        [[SLAFHTTPSessionManager sharedSLAFHTTPSessionManager] removeRequest:requestId];
    }];
    
    return requestId;
}

@end
