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

#import "FFRepairViewController.h"

@interface FFMineViewController ()

@property (nonatomic, strong) FFMineHeaderView *headerView;


@property (nonatomic, strong) FFMineViewModel *viewModel;

@property (nonatomic, assign) BOOL isShowRepaire;


@end

@implementation FFMineViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBGAlpha = @"0.0";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setBarTintColor:[FFColorManager navigation_bar_black_color]];
    self.navigationController.navigationBar.hidden = NO;

//    [self presentViewController:[FFRepairViewController showRepairView] animated:YES completion:nil];

    if (!_isShowRepaire) {
        [FFRepairViewController showRepairView];
        _isShowRepaire = YES;
    }

    [self respondsToLoginSuccess:nil];
    
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
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.headerView.frame) - kTABBAR_HEIGHT);
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_footer = nil;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.rightButton setImage:[FFImageManager Mine_setting_image]];
//    self.navigationItem.rightBarButtonItem = self.rightButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[FFImageManager Mine_setting_image] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];
}

- (void)initDataSource {
    //添加登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondsToLoginSuccess:) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    WeakSelf;
    //登录
    [self.headerView setLoginBlock:^BOOL{
        //    NSString *message = [NSString stringWithFormat:@"开始游戏_%@",CURRENT_GAME.game_name];

        m185Statistics(@"个人中心_登录", -1);
        [weakSelf pushViewController:[FFLoginViewController new]];
        return YES;
    }];
    //开通 VIP
    [self.headerView setOpenVip:^{
        //    NSString *message = [NSString stringWithFormat:@"开始游戏_%@",CURRENT_GAME.game_name];

        m185Statistics(@"个人中心_开通 VIP", -1);

        [weakSelf openVip];
    }];
    //修改昵称
    [self.headerView setModifyNickName:^NSString *{
        return [NSString stringWithFormat:@"test"];
    }];
    //显示个人信息详情
    [self.headerView setModifyAratarBlock:^{
        [weakSelf showDetailInfo];
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
    NSString *className = CURRENT_USER.isLogin ? @"FFOpenVipViewController" : @"FFLoginViewController";
    Class ViewController = NSClassFromString(className);
    if (ViewController) {
        id vc = [[ViewController alloc] init];
        [self pushViewController:vc];
    } else {
        syLog(@"%s error -> %@ not exist",__func__,className);
    }
}

- (void)showDetailInfo {
//    FFDriveMineViewController
    Class ViewController = NSClassFromString(@"FFDriveMineViewController");
    if (ViewController) {
        id vc = [[ViewController alloc] init];
        [vc setValue:CURRENT_USER.uid forKey:@"uid"];
        [self pushViewController:vc];
    } else {
        syLog(@"%s error -> %@ not exist",__func__,@"FFDriveMineViewController");
    }
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
    syLog(@"设置???");
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
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self.viewModel viewForHeaderInSection];
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
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 235, kSCREEN_WIDTH, kSCREEN_HEIGHT - kTABBAR_HEIGHT - 235) style:(UITableViewStyleGrouped)];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    self.tableView.showsVerticalScrollIndicator = YES;
//    self.tableView.showsHorizontalScrollIndicator = NO;
//    self.tableView.tableFooterView = [UIView new];
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
//    self.tableView.sectionHeaderHeight = 0;
//    self.tableView.sectionFooterHeight = 0;
//    self.tableView.tableFooterView = [UIView new];
//    self.tableView.mj_header = self.refreshHeader;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
}




@end
