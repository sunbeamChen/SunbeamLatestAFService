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

// 构造SLAFResponse实例
+ (SLAFResponse *) constructSLAFResponse:(NSNumber *) requestId urlResponse:(NSURLResponse *) urlResponse responseObject:(id) responseObject error:(NSError *) error downloadFileUrl:(NSURL *) downloadFileUrl;

@end
