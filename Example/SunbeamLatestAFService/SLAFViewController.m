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
    [[SLAFTestServiceFactory sharedSLAFTestServiceFactory] initSLAFTestServiceFactory];
	
    [[[CheckUsernameManager alloc] initCheckUsernameManager:@"15860746397"] loadDataTask:^(NSString *identifier, id responseObject, NSError *error) {
        NSLog(@"请求响应返回，identifier：%@，responseObject：%@，error：%@", identifier, responseObject, error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
