//
//  SLAFResponseConstructor.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>
#import "SLAFResponse.h"

@interface SLAFResponseConstructor : NSObject

/**
 构造SLAFResponse实例

 @param requestId 请求id
 @param urlResponse 请求响应实例
 @param responseObject 请求响应数据
 @param error 错误描述
 @param downloadFileUrl 下载文件本地地址
 @return SLAFResponse
 */
+ (SLAFResponse *) constructSLAFResponse:(NSNumber *) requestId urlResponse:(NSURLResponse *) urlResponse responseObject:(id) responseObject error:(NSError *) error downloadFileUrl:(NSURL *) downloadFileUrl;

@end
