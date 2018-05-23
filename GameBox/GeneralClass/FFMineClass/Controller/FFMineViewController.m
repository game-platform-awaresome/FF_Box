//
//  FFMineViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFMineViewController.h"
#import "FFMineHeaderView.h"

#import "FFLoginViewController.h"

#import "FFControllerManager.h"
#import "FFMineViewModel.h"
#import "FFUserModel.h"

@interface FFMineViewController ()

@property (nonatomic, strong) FFMineHeaderView *headerView;


@property (nonatomic, strong) FFMineViewModel *viewModel;


@end

@implementation FFMineViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBGAlpha = @"0.0";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];

    self.navigationItem.title = @"个人中心";
    self.navigationItem.titleView = [UIView new];

    [self.view addSubview:self.headerView];

    [self resetTableView];
    [self.view addSubview:self.tableView];

    [self.rightButton setImage:[FFImageManager Mine_setting_image]];
    self.navigationItem.rightBarButtonItem = self.rightButton;
}

- (void)initDataSource {
    //添加登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondsToLoginSuccess:) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    WeakSelf;
    //登录
    [self.headerView setLoginBlock:^BOOL{
        [weakSelf pushViewController:[FFLoginViewController new]];
        return YES;
    }];
    //开通 VIP
    [self.headerView setOpenVip:^{
        [weakSelf openVip];
    }];
    //修改昵称
    [self.headerView setModifyNickName:^NSString *{
        return [NSString stringWithFormat:@"test"];
    }];
    //修改头像
    [self.headerView setModifyAratarBlock:^{
        syLog(@"修改头像");
    }];
    //金币中心
    [self.headerView setGoldCenter:^{
        [weakSelf respondsToGoleCenter];
    }];
    //平台币
    [self.headerView setPlatform:^{
        [weakSelf respondsToPlaftform];
    }];
}

#pragma mark - method
- (void)begainRefresData {

}

- (void)openVip {
    syLog(@"开通 VIP");
}

#pragma mmark - notification
- (void)respondsToLoginSuccess:(NSNotification *)noti {
    [self.headerView refreshUserInterface];
}

#pragma mark - refresh
- (void)refreshData {
    [self.headerView refreshUserInterface];
    [self.tableView.mj_header endRefreshing];
}
- (void)loadMoreData {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - responds
- (void)respondsToRightButton {
    Class FFSettingViewController = NSClassFromString(@"FFSettingViewController");
    id vc = [FFSettingViewController new];
    [self pushViewController:vc];
}

- (void)respondsToGoleCenter {
    Class GoldCenter = NSClassFromString(@"FFGoldCenterViewController");
    if (GoldCenter) {
        id vc = [[GoldCenter alloc] init];
        [self pushViewController:vc];
    } else {
        syLog(@"%s  error -> FFGoldCenterViewController not exist",__func__);
    }
}

- (void)respondsToPlaftform {
    Class GoldCenter = NSClassFromString(@"FFPlatformDetailViewController");
    if (GoldCenter) {
        id vc = [[GoldCenter alloc] init];
        [self pushViewController:vc];
    } else {
        syLog(@"%s  error -> FFPlatformDetailViewController not exist",__func__);
    }
}
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel sectionNumber];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel itemNumberWithSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - table veiw delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 24;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id vc = [self.viewModel didSelectRowAtIndexPath:indexPath];
    if (vc) {
        self.hidesBottomBarWhenPushed = YES;
        [self pushViewController:vc];
    }
}

#pragma mark - getter
- (FFMineViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [FFMineViewModel new];
    }
    return _viewModel;
}

- (FFMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 235)];
    }
    return _headerView;
}

- (void)resetTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 235, kSCREEN_WIDTH, kSCREEN_HEIGHT - kTABBAR_HEIGHT - 235) style:(UITableViewStyleGrouped)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header = self.refreshHeader;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}




@end
