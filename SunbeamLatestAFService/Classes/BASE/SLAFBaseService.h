//
//  SLAFBaseService.h
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import <Foundation/Foundation.h>

@protocol SLAFServiceProtocol <NSObject>

// protocol（https://）
@property (nonatomic, copy, readonly) NSString* protocol;

// domain
@property (nonatomic, copy, readonly) NSString* domain;

// protocol version
@property (nonatomic, copy, readonly) NSString* version;

// use SSL certificates or not
@property (nonatomic, assign, readonly) BOOL useSSLCertificates;

@end

@interface SLAFBaseService : NSObject

// child delegate
@property (nonatomic, weak) id<SLAFServiceProtocol> child;

// protocol（https://）
@property (nonatomic, copy, readonly) NSString* protocol;

// domain
@property (nonatomic, copy, readonly) NSString* domain;

// protocol version（默认该version是在url链接中,header中version通过header params添加）
@property (nonatomic, copy, readonly) NSString* version;

// use SSL certificates or not
@property (nonatomic, assign, readonly) BOOL useSSLCertificates;

@end
