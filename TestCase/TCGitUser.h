
#import <Foundation/Foundation.h>

@interface TCGitUser : NSObject
@property(nonatomic, strong) NSString* login;
@property(nonatomic, strong) NSURL * profileUrl;
@property(nonatomic, strong) NSURL * avatarUrl;
@property(nonatomic, strong) UIImage* avatarImage;
- (id)initWithDictionary:(NSDictionary*)dic;
- (RACSignal*)avatar;
@end
