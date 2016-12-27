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

// use SSL certificates or not（是否使用SSL Certificates进行验证，取值为YES时，APP MainBundle中必须存在 appSSLCertificate.cer 文件，取值为NO时，不需要有该文件）
@property (nonatomic, assign, readonly) BOOL useSSLCertificates;

@end
