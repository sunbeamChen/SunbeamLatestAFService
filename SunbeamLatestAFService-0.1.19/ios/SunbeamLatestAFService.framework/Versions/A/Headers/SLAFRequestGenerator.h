//
//  SLAFRequestGenerator.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>
#import "SLAFServiceProperty.h"
#import "SLAFRequest.h"

@interface SLAFRequestGenerator : NSObject

/**
 SLAFRequest构造

 @param method 请求方法
 @param identifier 当前请求服务标识
 @param URI 请求资源定位符
 @param requestParams 请求参数
 @param uploadFiles 上传文件字典
 @return SLAFRequest
 */
+ (SLAFRequest *) generateSLAFRequest:(SLAF_REQUEST_METHOD) method identifier:(NSString *) identifier URI:(NSString *) URI requestParams:(NSDictionary *) requestParams uploadFiles:(NSMutableDictionary *) uploadFiles downloadUrl:(NSString *) downloadUrl;

@end
