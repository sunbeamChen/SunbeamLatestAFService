//
//  SLAFResponseConstructor.m
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import "SLAFResponseConstructor.h"
#import "SLAFServiceProperty.h"

@implementation SLAFResponseConstructor

+ (SLAFResponse *)constructSLAFResponse:(NSNumber *)requestId urlResponse:(NSURLResponse *)urlResponse responseObject:(id)responseObject error:(NSError *)error downloadFileUrl:(NSURL *)downloadFileUrl
{
    
    return [SLAFResponse getSLAFResponse:requestId responseObject:responseObject downloadFileUrl:downloadFileUrl error:[self getNetworkResponseErrorMessage:error]];
}

+ (NSError *) getNetworkResponseErrorMessage:(NSError *) error
{
    if (error) {
        NSInteger code = NETWORK_NOT_REACHABLE_ERROR;
        NSString* message = @"network is not reachable";
        
        //待改进，目前处理是：除了超时、服务器响应异常以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            code = NETWORK_TIMEOUT_ERROR;
            message = @"network request is timeout";
        } else if (error.code == NSURLErrorBadServerResponse) {
            code = BAD_SERVER_RESPONSE_ERROR;
            message = @"server response is error";
        }
        
        return [NSError errorWithDomain:SLAF_ERROR_DOMAIN code:code userInfo:@{NSLocalizedDescriptionKey:message}];
    }
    
    return nil;
}

@end
