#import <Foundation/Foundation.h>


@interface TCCore : NSObject
+ (instancetype)sharedCore;
- (RACSignal*)users;
@end
