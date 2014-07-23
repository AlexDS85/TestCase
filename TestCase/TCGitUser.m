#import "TCGitUser.h"
#import <AFNetworking.h>

@interface TCGitUser()
@end

@implementation TCGitUser
- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        _login = dic[@"login"];
        _profileUrl = [NSURL URLWithString:dic[@"html_url"]];
        _avatarUrl = [NSURL URLWithString:dic[@"avatar_url"]];
    }
    return self;
}


- (RACSignal*)avatar
{
    if (_avatarImage)
        return [RACSignal return:_avatarImage];
    
    return [RACSignal startEagerlyWithScheduler:[RACScheduler scheduler] block:^(id<RACSubscriber> subscriber) {
        [[self imageAtUrl:_avatarUrl] subscribeNext:^(UIImage* x) {
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        }];
        
    }];
    
}

- (RACSignal*)imageAtUrl:(NSURL*)imageURL
{
   return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
                @weakify(self)
                AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                                                                       success:^(UIImage *image) {
                       @strongify(self)
                       self.avatarImage = image;
                       [subscriber sendNext:image];
                       [subscriber sendCompleted];
                   }];
                [operation start];
                return [RACDisposable disposableWithBlock:^{
                }];
            }];
}
- (NSString*)description
{
    return [NSString stringWithFormat:@"{\nLogin:%@, \nProfileLink:%@,\nAvatarLink:%@\n}",_login,_profileUrl,_avatarUrl];
}

@end
