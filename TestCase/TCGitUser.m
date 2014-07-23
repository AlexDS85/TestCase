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
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"{\nLogin:%@, \nProfileLink:%@}",_login,_profileUrl];
}

@end
