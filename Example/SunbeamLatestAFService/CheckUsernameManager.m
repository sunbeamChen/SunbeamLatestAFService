//
//  CheckUsernameManager.m
//  SLAFTest
//
//  Created by sunbeam on 2016/12/23.
//  Copyright © 2016年 aerolite. All rights reserved.
//

#import "CheckUsernameManager.h"

@interface CheckUsernameManager() <SLAFManagerProtocol, SLAFRequestParams, SLAFRequestParamsValidator, SLAFRequestInterceptor, SLAFResponseDataFormatter, SLAFResponseDataValidator>

@property (nonatomic, copy) NSString* username;

@end

@implementation CheckUsernameManager

- (instancetype)init
{
    if (self = [super init]) {
        self.childManager = self;
        self.requestParams = self;
        self.requestParamsValidator = self;
        self.requestInterceptor = self;
        self.responseDataFormatter = self;
        self.responseDataValidator = self;
    }
    
    return self;
}

- (instancetype)initCheckUsernameManager:(NSString *)username
{
    if (self = [self init]) {
        self.username = username;
    }
    
    return self;
}

// 统一资源标识符
- (NSString *) URI
{
    return @"/check/reg";
}

// 当前请求标识
- (NSString *) identifier
{
    return @"sherlock_private_api_service_checkUsernameRegistOrNot";
}

// 当前请求方法
- (SLAF_REQUEST_METHOD) method
{
    return POST;
}

// 请求参数
- (NSDictionary *) generatorRequestParams
{
    return @{@"slaf_request_header_params_dict":@{@"APIVER":@"1.0"},@"slaf_request_body_dict":@{@"mobile":self.username}};
}

// 请求参数合法性检查
- (NSError *) requestParamsValidate
{
    return nil;
}

// 请求成功
- (void) interceptorForRequestSuccess:(SLAFBaseManager *) manager
{
    NSLog(@"请求成功");
}

// 请求失败
- (void) interceptorForRequestFailed:(SLAFBaseManager *) manager
{
    NSLog(@"请求失败");
}

@end
