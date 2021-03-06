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
    
    NSURLSessionDataTask* dataTask = [sessionManager dataTaskWithRequest:slafRequest.request completionHandler:completion];
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionUploadTask *)loadUploadTask:(SLAFRequest *)slafRequest uploadProgressBlock:(void (^)(NSProgress *))uploadProgressBlock completion:(void (^)(NSURLResponse *, id, NSError *))completion
{
    AFURLSessionManager* sessionManager = [self getHttpSessionManager:slafRequest.useSSLCertificates];
    
    NSURLSessionUploadTask* uploadTask = [sessionManager uploadTaskWithStreamedRequest:slafRequest.request progress:uploadProgressBlock completionHandler:completion];
    [uploadTask resume];
    
    return uploadTask;
}

- (NSURLSessionDownloadTask *)loadDownloadTask:(SLAFRequest *)slafRequest downloadProgressBlock:(void (^)(NSProgress *))downloadProgressBlock completion:(void (^)(NSURLResponse *, NSURL *, NSError *))completion
{
    AFURLSessionManager* sessionManager = [self getHttpSessionManager:slafRequest.useSSLCertificates];
    
    NSURLSessionDownloadTask* downloadTask = [sessionManager downloadTaskWithRequest:slafRequest.request progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:completion];
    [downloadTask resume];
    
    return downloadTask;
}

/**
 根据是否使用证书认证获取SessionManager

 @param useSSLCertificates 是否使用SSL证书
 @return AFURLSessionManager
 */
- (AFURLSessionManager *)getHttpSessionManager:(BOOL) useSSLCertificates
{
    if (_httpSessionManager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _httpSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        _httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        if (useSSLCertificates) {
            _httpSessionManager.securityPolicy = [self getCustomSecurityPolicy];
        } else {
            _httpSessionManager.securityPolicy = [self getDefaultSecurityPolicy];
        }
    }
    
    return _httpSessionManager;
}

/**
 获取默认的安全策略，当useSSLCertificates=NO

 @return AFSecurityPolicy
 */
- (AFSecurityPolicy *) getDefaultSecurityPolicy
{
    AFSecurityPolicy* securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = NO;
    securityPolicy.validatesDomainName = NO;
    
    return securityPolicy;
}

/**
 获取自定义的安全策略，当useSSLCertificates=YES
 默认所有的cer文件从MainBundle中加载

 @return AFSecurityPolicy
 */
- (AFSecurityPolicy *) getCustomSecurityPolicy
{
    NSSet* pinnedCertificates = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:pinnedCertificates];
    [securityPolicy setAllowInvalidCertificates:NO];
    securityPolicy.validatesDomainName = YES;
    
    return securityPolicy;
}

@end
