
#import "TCRootTableViewCell.h"
#import "TCGitUser.h"
#import <TTTAttributedLabel.h>

#define IMAGE_PADDING   10
@interface TCRootTableViewCell()<TTTAttributedLabelDelegate>
@property(nonatomic, strong) TTTAttributedLabel * profileLink;
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
        _profileLink.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_profileLink];
        _profileLink.delegate = self;
        
        _login = UILabel.new;
        _login.translatesAutoresizingMaskIntoConstraints = NO;
        _login.autoresizingMask = UIViewAutoresizingNone;
        [self.contentView addSubview:_login];
        
        NSDictionary * views = @{@"loginLabel":_login, @"profileLink":_profileLink};
        NSDictionary * metrics = @{@"padding":@(IMAGE_PADDING)};
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[loginLabel(25)]-0-[profileLink]-0-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[loginLabel]-(padding)-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[profileLink]-(padding)-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
    }
    return self;
}

+ (float)cellHeight
{
    return 50;
}

- (void)setUser:(TCGitUser *)newUser
{
    _user = newUser;
    [_login setText:_user.login];
    _profileLink.text = [_user.profileUrl absoluteString];
    [_profileLink addLinkToURL:_user.profileUrl withRange:NSMakeRange(0, [_profileLink.text length])];
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
