//
//  SLAFViewController.m
//  SunbeamLatestAFService
//
//  Created by 陈训 on 12/21/2016.
//  Copyright (c) 2016 陈训. All rights reserved.
//

#import "SLAFViewController.h"
#import <SunbeamLatestAFService/SunbeamLatestAFService.h>
#import "SLAFTestServiceFactory.h"
#import "CheckUsernameManager.h"

@interface SLAFViewController ()

@end

@implementation SLAFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SLAFServiceContext sharedSLAFServiceContext].timeoutInterval = 5.0;
    [SLAFServiceContext sharedSLAFServiceContext].requestRunningStrategy = RUNNING_ALL;
    [[SLAFTestServiceFactory sharedSLAFTestServiceFactory] initSLAFTestServiceFactory];
	
    __block NSNumber* request1 = [[[CheckUsernameManager alloc] initCheckUsernameManager:@"15860746397"] loadDataTask:^(NSString *identifier, id responseObject, NSError *error) {
        NSLog(@"%@请求响应返回，identifier：%@，responseObject：%@，error：%@", request1, identifier, responseObject, error);
    }];
    
    __block NSNumber* request2 = [[[CheckUsernameManager alloc] initCheckUsernameManager:@"15860746397"] loadDataTask:^(NSString *identifier, id responseObject, NSError *error) {
        NSLog(@"%@请求响应返回，identifier：%@，responseObject：%@，error：%@", request2, identifier, responseObject, error);
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSNumber* request3 = [[[CheckUsernameManager alloc] initCheckUsernameManager:@"15860746397"] loadDataTask:^(NSString *identifier, id responseObject, NSError *error) {
            NSLog(@"%@请求响应返回，identifier：%@，responseObject：%@，error：%@", request3, identifier, responseObject, error);
        }];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSNumber* request3 = [[[CheckUsernameManager alloc] initCheckUsernameManager:@"15860746397"] loadDataTask:^(NSString *identifier, id responseObject, NSError *error) {
            NSLog(@"%@请求响应返回，identifier：%@，responseObject：%@，error：%@", request3, identifier, responseObject, error);
        }];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSNumber* request3 = [[[CheckUsernameManager alloc] initCheckUsernameManager:@"15860746397"] loadDataTask:^(NSString *identifier, id responseObject, NSError *error) {
            NSLog(@"%@请求响应返回，identifier：%@，responseObject：%@，error：%@", request3, identifier, responseObject, error);
        }];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
