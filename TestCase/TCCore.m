#import <AFNetworking/AFNetworking.h>
#import "TCCore.h"
#import "TCGitUser.h"

@interface TCCore()
@property (nonatomic, strong) AFHTTPClient *httpClient;
@end

@implementation TCCore
+ (instancetype)sharedCore
{
    static TCCore *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = self.new;
    });
    return sharedInstance;
}

- (id) init
{
    if (self = [super init]) {
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.github.com/"]];
        [_httpClient setParameterEncoding:AFJSONParameterEncoding];
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
        
        

    }
    return self;
}

- (RACSignal*)users
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        
        NSMutableURLRequest *request = [[TCCore sharedCore].httpClient requestWithMethod:@"GET"
                                                                                   path:@"users"
                                                                             parameters:nil];
        
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSMutableArray * arrUsers = NSMutableArray.new;
            if ([JSON isKindOfClass:[NSArray class]])
                [JSON enumerateObjectsUsingBlock:^(NSDictionary* dic, NSUInteger idx, BOOL *stop) {
                    TCGitUser* gitUser = [[TCGitUser alloc] initWithDictionary:dic];
                    [arrUsers addObject:gitUser];
                }];
                                                                                                
            [subscriber sendNext:arrUsers];
            [subscriber sendCompleted];
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"error happened %@", [error debugDescription]);
            }];
        
        
            
        
            [operation start];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}
@end
