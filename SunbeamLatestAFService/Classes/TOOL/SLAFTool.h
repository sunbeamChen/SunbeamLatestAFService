//
//  SLAFTool.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>

@interface SLAFTool : NSObject

/**
 url 参数

 @param urlParamsDictionary url字典
 @return url(使用&符号连接的参数)
 */
+ (NSString *) urlParamsString:(NSDictionary *) urlParamsDictionary;

/**
 url参数
 
 @param urlParamsArray 参数数组
 @return url(使用&符号连接参数的url)
 */
+ (NSString *) paramsString:(NSArray *) urlParamsArray;

/**
 参数构造

 @param urlParamsDictionary url字典
 @return url数组(使用=符号连接的参数数组)
 */
+ (NSArray *) transformedUrlParamsArray:(NSDictionary *) urlParamsDictionary;

@end
