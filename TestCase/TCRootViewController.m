#import "TCRootViewController.h"
#import "TCGitUser.h"
#import "TCRootTableViewCell.h"


static NSString * cellIdentifier = @"TCGitUserCell";
@interface TCRootViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSArray * users;

@end

@implementation TCRootViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        _tableView = UITableView.new;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.autoresizingMask = UIViewAutoresizingNone;
        [self.view addSubview:_tableView];
        
        NSString * strLayout;
        NSDictionary * views;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7)
        {
            strLayout = @"V:|-0-[topGuide]-0-[tableView]-0-|";
            views = @{@"topGuide":self.topLayoutGuide,@"tableView":_tableView};
        }
        else
        {
            strLayout = @"V:|-0-[tableView]-0-|";
            views = @{@"tableView":_tableView};
        }
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:strLayout
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[TCRootTableViewCell class] forCellReuseIdentifier:cellIdentifier];

    _tableView.alpha = 0;
    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activity];

    activity.translatesAutoresizingMaskIntoConstraints = NO;
    activity.autoresizingMask = UIViewAutoresizingNone;
    [activity constrain:@"centerX=centerX" to:self.view];
    [activity constrain:@"centerY = centerY" to:self.view];
    
    [activity startAnimating];
    [self.view bringSubviewToFront:activity];

    [[TCCore.sharedCore users] subscribeNext:^(NSArray* x) {
        _users = x;
    } completed:^{
        [activity stopAnimating];
        [activity removeFromSuperview];
        [self.tableView reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            _tableView.alpha = 1;
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCGitUser * user = _users[indexPath.row];
    TCRootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setUser:user];
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TCRootTableViewCell cellHeight];
}

- (void)loadOnScreenImages
{
    for (NSIndexPath *indexPath in [self.tableView indexPathsForVisibleRows])
    {
        TCGitUser * user = _users[indexPath.row];
        if (!user.avatarImage)
            [user avatar];
    }

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadOnScreenImages];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadOnScreenImages];
}
@end
