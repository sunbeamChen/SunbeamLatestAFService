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
    // 是否使用SSL Certificates进行验证，取值为YES时，APP MainBundle中必须存在 appSSLCertificate.cer 文件，取值为NO时，不需要有该文件
    return YES;
}

@end
