
#import "TCRootTableViewCell.h"
#import "TCGitUser.h"
#import <TTTAttributedLabel.h>


#define IMAGE_SIZE      92
#define IMAGE_PADDING   2
@interface TCRootTableViewCell()<TTTAttributedLabelDelegate>
@property(nonatomic, strong) TTTAttributedLabel * profileLink;
@property(nonatomic, strong) UIImageView * avatar;
@property(nonatomic, strong) UILabel * login;


@end

@implementation TCRootTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _profileLink = TTTAttributedLabel.new;
        _profileLink.translatesAutoresizingMaskIntoConstraints = NO;
        _profileLink.autoresizingMask = UIViewAutoresizingNone;
        _profileLink.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_profileLink];
        _profileLink.delegate = self;
        
        _avatar = UIImageView.new;
        _avatar.translatesAutoresizingMaskIntoConstraints = NO;
        _avatar.autoresizingMask = UIViewAutoresizingNone;
        [self.contentView addSubview:_avatar];
        
        _login = UILabel.new;
        _login.translatesAutoresizingMaskIntoConstraints = NO;
        _login.autoresizingMask = UIViewAutoresizingNone;
        [self.contentView addSubview:_login];
        
        NSDictionary * views = @{@"avatar":_avatar,@"loginLabel":_login, @"profileLink":_profileLink};
        NSDictionary * metrics = @{@"size":@(IMAGE_SIZE),@"padding":@(IMAGE_PADDING)};
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[avatar]-(padding)-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[loginLabel(35)]-0-[profileLink]-0-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[avatar(size)]-6-[loginLabel]-10-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[avatar(size)]-6-[profileLink]-10-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
        
        
    }
    return self;
}

+ (float)cellHeight
{
    return 2*IMAGE_PADDING + IMAGE_SIZE;
}

- (void)setUser:(TCGitUser *)newUser
{
    _user = newUser;
    [_login setText:_user.login];
    _profileLink.text = [_user.profileUrl absoluteString];
    [_profileLink addLinkToURL:_user.profileUrl withRange:NSMakeRange(0, [_profileLink.text length])];

    
    if (_user.avatarImage)
        [_avatar setImage:_user.avatarImage];
    else
    {
        [_avatar setImage:[TCRootTableViewCell defaultAvatar]];
        __block UIActivityIndicatorView * activity;
        [[[[_user avatar] initially:^{
            activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.contentView addSubview:activity];
            activity.autoresizingMask = UIViewAutoresizingNone;
            activity.translatesAutoresizingMaskIntoConstraints = NO;
            [activity constrain:[NSString stringWithFormat:@"centerX=left+%d",(int)(IMAGE_SIZE*0.5+IMAGE_PADDING)] to:self.contentView];
            [activity constrain:@"centerY=centerY" to:self.contentView];
            [activity startAnimating];
 
        }]finally:^{
            [activity stopAnimating];
            [activity removeFromSuperview];
        }] subscribeNext:^(UIImage* x) {
            [_avatar setImage:x];
        }];
    }
}

+ (UIImage*)defaultAvatar
{
    return [UIImage imageNamed:@"defaultUser"];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}

@end
