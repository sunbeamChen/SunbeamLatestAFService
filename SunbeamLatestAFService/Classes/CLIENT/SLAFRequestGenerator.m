//
//  SLAFRequestGenerator.m
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import "SLAFRequestGenerator.h"
#import <AFNetworking/AFNetworking.h>
#import "SLAFServiceFactory.h"
#import "SLAFServiceProperty.h"
#import "SLAFServiceContext.h"
#import "SLAFTool.h"

@implementation SLAFRequestGenerator

+ (SLAFRequest *) generateSLAFRequest:(SLAF_REQUEST_METHOD) method identifier:(NSString *) identifier URI:(NSString *) URI requestParams:(NSDictionary *) requestParams uploadFiles:(NSMutableDictionary *) uploadFiles
{
    SLAFBaseService* service = [[SLAFServiceFactory sharedSLAFServiceFactory] getSLAFService:identifier];
    
    NSDictionary* headerParams = [requestParams objectForKey:SLAFRequestHeaderParamsKey];
    NSDictionary* urlParams = [requestParams objectForKey:SLAFRequestUrlParamsKey];
    NSDictionary* bodyParams = [requestParams objectForKey:SLAFRequestBodyParamsKey];
    NSString* urlString = nil;
    if (urlParams == nil) {
        urlString = [NSString stringWithFormat:@"%@%@%@%@", service.protocol, service.domain, service.version, URI];
    } else {
        urlString = [NSString stringWithFormat:@"%@%@%@%@?%@", service.protocol, service.domain, service.version, URI, [SLAFTool urlParamsString:urlParams]];
    }
    
    NSMutableURLRequest* mutableRequest = nil;
    switch (method) {
        case GET:
        {
            mutableRequest = [[self getHttpJsonRequestSerializer] requestWithMethod:@"GET" URLString:urlString parameters:bodyParams error:nil];
            break;
        }
        case POST:
        {
            mutableRequest = [[self getHttpJsonRequestSerializer] requestWithMethod:@"POST" URLString:urlString parameters:bodyParams error:nil];
            break;
        }
        case DOWNLOAD:
        {
            mutableRequest = [[self getHttpRequestSerializer] requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
            break;
        }
        case UPLOAD:
        {
            mutableRequest = [[self getHttpRequestSerializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (NSString* fileKey in [uploadFiles allKeys]) {
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:[uploadFiles objectForKey:fileKey]] name:fileKey error:nil];
                }
            } error:nil];
            break;
        }
            
        default:
            break;
    }
    
    if (headerParams != nil && [headerParams count] > 0) {
        for (NSString* key in [headerParams allKeys]) {
            [mutableRequest addValue:[headerParams objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    return [SLAFRequest getSLAFRequest:method request:mutableRequest urlString:urlString useSSLCertificates:service.useSSLCertificates headerParams:headerParams urlParams:urlParams bodyParams:bodyParams uploadFiles:uploadFiles];
}

#pragma mark - get request serializer
+ (AFHTTPRequestSerializer *)getHttpJsonRequestSerializer
{
    AFHTTPRequestSerializer* jsonRequestSerializer = [AFJSONRequestSerializer serializer];
    jsonRequestSerializer.timeoutInterval = [SLAFServiceContext sharedSLAFServiceContext].timeoutInterval = nil ? SLAFRequestTimeoutInterval : [SLAFServiceContext sharedSLAFServiceContext].timeoutInterval;
    jsonRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    [jsonRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return jsonRequestSerializer;
}

+ (AFHTTPRequestSerializer *)getHttpRequestSerializer
{
    AFHTTPRequestSerializer* httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    httpRequestSerializer.timeoutInterval = [SLAFServiceContext sharedSLAFServiceContext].timeoutInterval = nil ? SLAFRequestTimeoutInterval : [SLAFServiceContext sharedSLAFServiceContext].timeoutInterval;
    httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    return httpRequestSerializer;
}

@end
