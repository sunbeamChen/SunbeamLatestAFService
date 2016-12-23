//
//  SLAFBaseService.m
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import "SLAFBaseService.h"

@implementation SLAFBaseService

- (instancetype)init
{
    if (self = [super init]) {
        if ([self conformsToProtocol:@protocol(SLAFServiceProtocol)]) {
            self.child = (id<SLAFServiceProtocol>) self;
        }
    }
    return self;
}

- (NSString *)protocol
{
    return self.child.protocol;
}

- (NSString *)domain
{
    return self.child.domain;
}

- (NSString *)version
{
    return self.child.version;
}

- (BOOL)useSSLCertificates
{
    return self.child.useSSLCertificates;
}

@end
