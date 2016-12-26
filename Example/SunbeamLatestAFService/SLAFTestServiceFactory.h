//
//  SLAFTestServiceFactory.h
//  SLAFTest
//
//  Created by sunbeam on 2016/12/26.
//  Copyright © 2016年 aerolite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLAFTestServiceFactory : NSObject

/**
 *  单例
 */
+ (SLAFTestServiceFactory *) sharedSLAFTestServiceFactory;

- (void) initSLAFTestServiceFactory;

@end
