#import <UIKit/UIKit.h>
@class TCGitUser;

@interface TCRootTableViewCell : UITableViewCell
@property (nonatomic, strong,setter = setUser:) TCGitUser * user;
+ (float)cellHeight;
@end
