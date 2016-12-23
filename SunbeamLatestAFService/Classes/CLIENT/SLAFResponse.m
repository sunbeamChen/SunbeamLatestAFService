//
//  SLAFResponse.m
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import "SLAFResponse.h"

@interface SLAFResponse()

- (instancetype) initSLAFResponse:(NSNumber *) requestId responseObject:(id) responseObject downloadFileUrl:(NSURL *) downloadFileUrl error:(NSError *) error;

@end

@implementation SLAFResponse

- (instancetype) initSLAFResponse:(NSNumber *) requestId responseObject:(id) responseObject downloadFileUrl:(NSURL *) downloadFileUrl error:(NSError *) error
{
    if (self = [super init]) {
        self.requestId = requestId;
        self.responseObject = responseObject;
        self.downloadFileUrl = downloadFileUrl;
        self.error = error;
    }
    
    return self;
}

+ (SLAFResponse *) getSLAFResponse:(NSNumber *) requestId responseObject:(id) responseObject downloadFileUrl:(NSURL *) downloadFileUrl error:(NSError *) error
{
    return [[SLAFResponse alloc] initSLAFResponse:requestId responseObject:responseObject downloadFileUrl:downloadFileUrl error:error];
}

@end
