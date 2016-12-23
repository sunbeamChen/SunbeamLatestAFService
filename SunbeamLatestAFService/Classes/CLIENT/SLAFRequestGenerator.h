//
//  SLAFRequestGenerator.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>
#import "../BASE/SLAFServiceProperty.h"
#import "SLAFRequest.h"

@interface SLAFRequestGenerator : NSObject

// 产生SLAFRequest实例
+ (SLAFRequest *) generateSLAFRequest:(SLAF_REQUEST_METHOD) method identifier:(NSString *) identifier URI:(NSString *) URI requestParams:(NSDictionary *) requestParams uploadFiles:(NSMutableDictionary *) uploadFiles;

@end
