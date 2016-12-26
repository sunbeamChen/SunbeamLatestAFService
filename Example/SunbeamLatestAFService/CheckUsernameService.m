//
//  CheckUsernameService.m
//  SLAFTest
//
//  Created by sunbeam on 2016/12/23.
//  Copyright © 2016年 aerolite. All rights reserved.
//

#import "CheckUsernameService.h"

@implementation CheckUsernameService

- (NSString *)protocol
{
    return @"https://";
}

- (NSString *)domain
{
    return @"api.sherlock.aerolite.net";
}

- (NSString *)version
{
    return @"";
}

- (BOOL)useSSLCertificates
{
    return NO;
}

@end
