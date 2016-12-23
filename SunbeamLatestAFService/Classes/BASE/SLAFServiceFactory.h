//
//  SLAFServiceFactory.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>
#import "SLAFBaseService.h"

@protocol SLAFServiceFactoryProtocol <NSObject>

// 根据对应的service identifier获取对应的SLAFBaseService
- (SLAFBaseService<SLAFServiceProtocol> *) getSLAFService:(NSString *) identifier;

@end

@interface SLAFServiceFactory : NSObject

/**
 单例

 @return SLAFServiceFactory
 */
+ (SLAFServiceFactory *) sharedSLAFServiceFactory;

/**
 service factory 工厂代理
 */
@property (nonatomic, weak) id<SLAFServiceFactoryProtocol> delegate;

/**
 根据对应的service identifier获取对应的SLAFService

 @param identifier 请求唯一标识
 @return SLAFBaseService<SLAFServiceProtocol>
 */
- (SLAFBaseService<SLAFServiceProtocol> *) getSLAFService:(NSString *) identifier;

@end
