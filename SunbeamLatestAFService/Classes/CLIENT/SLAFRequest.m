//
//  SLAFRequest.m
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import "SLAFRequest.h"

@interface SLAFRequest()

- (instancetype) initSLAFRequest:(SLAF_REQUEST_METHOD) method request:(NSMutableURLRequest *) request urlString:(NSString *) urlString useSSLCertificates:(BOOL) useSSLCertificates headerParams:(NSMutableDictionary *) headerParams urlParams:(NSMutableDictionary *) urlParams bodyParams:(NSMutableDictionary *) bodyParams uploadFiles:(NSDictionary *) uploadFiles;

@end

@implementation SLAFRequest

- (instancetype)initSLAFRequest:(SLAF_REQUEST_METHOD)method request:(NSMutableURLRequest *)request urlString:(NSString *)urlString useSSLCertificates:(BOOL)useSSLCertificates headerParams:(NSMutableDictionary *)headerParams urlParams:(NSMutableDictionary *)urlParams bodyParams:(NSMutableDictionary *)bodyParams uploadFiles:(NSDictionary *) uploadFiles
{
    if (self = [super init]) {
        self.method = method;
        self.request = request;
        self.urlString = urlString;
        self.useSSLCertificates = useSSLCertificates;
        self.headerParams = headerParams;
        self.urlParams = urlParams;
        self.bodyParams = bodyParams;
        self.uploadFiles = uploadFiles;
    }
    
    return self;
}

+ (SLAFRequest *) getSLAFRequest:(SLAF_REQUEST_METHOD) method request:(NSMutableURLRequest *) request urlString:(NSString *) urlString useSSLCertificates:(BOOL) useSSLCertificates headerParams:(NSMutableDictionary *) headerParams urlParams:(NSMutableDictionary *) urlParams bodyParams:(NSMutableDictionary *) bodyParams uploadFiles:(NSDictionary *) uploadFiles
{
    return [[SLAFRequest alloc] initSLAFRequest:method request:request urlString:urlString useSSLCertificates:useSSLCertificates headerParams:headerParams urlParams:urlParams bodyParams:bodyParams uploadFiles:uploadFiles];
}

@end
