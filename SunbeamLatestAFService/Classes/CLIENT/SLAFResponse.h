//
//  SLAFResponse.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>

@interface SLAFResponse : NSObject

// 请求id
@property (nonatomic, strong) NSNumber* requestId;

// 响应数据
@property (nonatomic, strong) id responseObject;

// download文件下载地址
@property (nonatomic, strong) NSURL* downloadFileUrl;

// 响应错误码
@property (nonatomic, assign) NSError* error;

// 获取响应实例对象
+ (SLAFResponse *) getSLAFResponse:(NSNumber *) requestId responseObject:(id) responseObject downloadFileUrl:(NSURL *) downloadFileUrl error:(NSError *) error;

@end
