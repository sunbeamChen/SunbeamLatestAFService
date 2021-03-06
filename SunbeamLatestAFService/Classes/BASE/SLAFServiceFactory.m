//
//  SLAFServiceFactory.m
//  Pods
//
//  Created by sunbeam on 2016/12/21.
//
//

#import "SLAFServiceFactory.h"

@interface SLAFServiceFactory()

@property (nonatomic, strong) NSMutableDictionary *SLAFServiceStorage;

@end

@implementation SLAFServiceFactory

+ (SLAFServiceFactory *) sharedSLAFServiceFactory
{
    static SLAFServiceFactory *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (SLAFBaseService<SLAFServiceProtocol> *) getSLAFService:(NSString *) identifier
{
    if (self.SLAFServiceStorage[identifier] == nil) {
        
        NSAssert(self.delegate != nil, @"SLAFServiceFactory delegate should not be nil");
        
        NSAssert([self.delegate respondsToSelector:@selector(getSLAFService:)], @"SLAFServiceFactory delegate selector [getSLAFService:] should not be nil");
        
        self.SLAFServiceStorage[identifier] = [self.delegate getSLAFService:identifier];
    }
    
    return self.SLAFServiceStorage[identifier];
}

#pragma mark - getters and setters
- (NSMutableDictionary *)SLAFServiceStorage
{
    if (_SLAFServiceStorage == nil) {
        _SLAFServiceStorage = [[NSMutableDictionary alloc] init];
    }
    return _SLAFServiceStorage;
}

@end
