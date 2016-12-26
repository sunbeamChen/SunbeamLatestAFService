//
//  SLAFServiceProperty.h
//  Pods
//
//  Created by sunbeam on 2016/12/22.
//
//

#ifndef SLAFServiceProperty_h
#define SLAFServiceProperty_h

// API请求类型
typedef enum : NSUInteger {
    GET         = 0,    // get
    POST        = 1,    // post
    DOWNLOAD    = 2,    // 下载
    UPLOAD      = 3,    // 上传
} SLAF_REQUEST_METHOD;

// error domain
#define SLAF_ERROR_DOMAIN @"slaf_error_domain"

// 网络请求系统错误
typedef enum : NSUInteger {
    DEFAULT_ERROR               = -1,   // 默认发起请求
    NETWORK_TIMEOUT_ERROR       = -2,   // 网络请求超时 "network request is timeout"
    BAD_SERVER_RESPONSE_ERROR   = -3,   // 服务器响应有误 "server response is error"
    NETWORK_NOT_REACHABLE_ERROR = -4,   // 网络不可达 "network is not reachable"
    REQUEST_RUNING_ERROR        = -5,   // 当前正在进行网络请求 "network request is busy"
    REQUEST_METHOD_NOT_SUPPORT  = -6,   // 当前请求方法不支持 "request method not support"
    REQUEST_SUCCESS             = 0,    // 网络请求成功
} SLAF_NETWORK_SYSTEM_ERROR;

// 请求超时默认设置
#define SLAFRequestTimeoutInterval 10.0f

// 设置NSMutableURLRequest header中参数，例如版本号APIVersion,系统默认的 "Content-Type"
#define SLAFRequestHeaderParamsKey @"slaf_request_header_params_dict"

// 设置NSMutableURLRequest url链接后使用 ? 后接的参数
#define SLAFRequestUrlParamsKey @"slaf_request_url_dict"

// 设置NSMutableURLRequest body中请求参数
#define SLAFRequestBodyParamsKey @"slaf_request_body_dict"

#endif /* SLAFServiceProperty_h */
