//
//  SLAFHTTPService.m
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import "SLAFHTTPService.h"
#import <AFNetworking/AFNetworking.h>

@interface SLAFHTTPService()

@property (nonatomic, strong) AFURLSessionManager* httpSessionManager;

@end

@implementation SLAFHTTPService

- (instancetype)init
{
    if (self = [super init]) {
        _httpSessionManager = nil;
    }
    return self;
}

- (NSURLSessionDataTask *)loadDataTask:(SLAFRequest *)slafRequest completion:(void (^)(NSURLResponse *, id, NSError *))completion
{
    AFURLSessionManager* sessionManager = [self getHttpSessionManager:slafRequest.useSSLCertificates];
    return [sessionManager dataTaskWithRequest:slafRequest.request completionHandler:completion];
}

- (NSURLSessionUploadTask *)loadUploadTask:(SLAFRequest *)slafRequest uploadProgress:(void (^)(NSProgress *))uploadProgressBlock completion:(void (^)(NSURLResponse *, id, NSError *))completion
{
    AFURLSessionManager* sessionManager = [self getHttpSessionManager:slafRequest.useSSLCertificates];
    return [sessionManager uploadTaskWithStreamedRequest:slafRequest.request progress:uploadProgressBlock completionHandler:completion];
}

- (NSURLSessionDownloadTask *)loadDownloadTask:(SLAFRequest *)slafRequest downloadProgress:(void (^)(NSProgress *))downloadProgressBlock completion:(void (^)(NSURLResponse *, NSURL *, NSError *))completion
{
    AFURLSessionManager* sessionManager = [self getHttpSessionManager:slafRequest.useSSLCertificates];
    return [sessionManager downloadTaskWithRequest:slafRequest.request progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:completion];
}

- (AFURLSessionManager *)getHttpSessionManager:(BOOL) useSSLCertificates
{
    if (_httpSessionManager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _httpSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        if (useSSLCertificates) {
            _httpSessionManager.securityPolicy = [self getCustomSecurityPolicy];
        } else {
            _httpSessionManager.securityPolicy = [self getDefaultSecurityPolicy];
        }
    }
    
    return _httpSessionManager;
}

- (AFSecurityPolicy *) getDefaultSecurityPolicy
{
    AFSecurityPolicy* securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = NO;
    securityPolicy.validatesDomainName = NO;
    
    return securityPolicy;
}

- (AFSecurityPolicy *) getCustomSecurityPolicy
{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setAllowInvalidCertificates:NO];
    securityPolicy.validatesDomainName = YES;
    
    return securityPolicy;
}

@end
