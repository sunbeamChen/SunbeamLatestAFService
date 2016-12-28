//
//  SLAFResponse.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>

@interface SLAFResponse : NSObject

@property (nonatomic, strong) NSNumber* requestId;

@property (nonatomic, strong) id responseObject;

@property (nonatomic, strong) NSURL* downloadFileUrl;

@property (nonatomic, strong) NSError* error;

/**
 构造SLAFResponse实例

 @param requestId 请求id
 @param responseObject 请求响应数据
 @param downloadFileUrl 下载文件本地地址
 @param error 错误描述
 @return SLAFResponse
 */
+ (SLAFResponse *) getSLAFResponse:(NSNumber *) requestId responseObject:(id) responseObject downloadFileUrl:(NSURL *) downloadFileUrl error:(NSError *) error;

@end
