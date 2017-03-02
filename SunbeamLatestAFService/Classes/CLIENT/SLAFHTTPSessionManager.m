//
//  SLAFHTTPSessionManager.m
//  Pods
//
//  Created by sunbeam on 2017/3/2.
//
//

#import "SLAFHTTPSessionManager.h"

@interface SLAFHTTPSessionManager()

@property (nonatomic, strong) NSNumber* requestId;

@end

@implementation SLAFHTTPSessionManager

+ (SLAFHTTPSessionManager *)sharedSLAFHTTPSessionManager
{
    static SLAFHTTPSessionManager *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        NSLog(@"\n==========================================\nSunbeam Latest AFService version is %@\n==========================================", SLAF_SERVICE_VERSION);
    });
    
    return sharedInstance;
}

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

- (BOOL)requestIsRunning
{
    @synchronized (self.sessionTaskQueue) {
        if ([self.sessionTaskQueue count] > 0) {
            return YES;
        }
        
        return NO;
    }
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
        // 此处如果调用cancle，则会导致响应失败，需要处理
        [sessionTask cancel];
        [self.sessionTaskQueue removeObjectForKey:requestId];
    }
}

- (void)removeAllRequest
{
    [self.sessionTaskQueue removeAllObjects];
}

- (void)removeRequest:(NSNumber *)requestId
{
    NSURLSessionTask* sessionTask = [self.sessionTaskQueue objectForKey:requestId];
    if (sessionTask) {
        [self.sessionTaskQueue removeObjectForKey:requestId];
    }
}

#pragma mark - private methods
- (NSMutableDictionary *)sessionTaskQueue
{
    if (_sessionTaskQueue == nil) {
        _sessionTaskQueue = [[NSMutableDictionary alloc] init];
    }
    
    return _sessionTaskQueue;
}

@end
