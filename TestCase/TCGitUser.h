
#import <Foundation/Foundation.h>

@interface TCGitUser : NSObject
@property(nonatomic, strong) NSString* login;
@property(nonatomic, strong) NSURL * profileUrl;
- (id)initWithDictionary:(NSDictionary*)dic;
@end
