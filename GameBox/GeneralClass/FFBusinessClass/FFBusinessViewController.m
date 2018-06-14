//
//  FFBusinessViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/8.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessViewController.h"
#import "FFBusinessModel.h"
#import "FFBusinessTableViewCell.h"
#import "FFBusinessHeaderView.h"

#define CELL_IDE @"FFBusinessTableViewCell"
#define Button_tag 10086
#define Button_Height 30
#define Select_Heigth 44

@interface FFBusinessViewController ()

@property (nonatomic, strong) UIBarButtonItem *userCenter;
@property (nonatomic, strong) UIBarButtonItem *searchButton;

@property (nonatomic, strong) FFBusinessHeaderView *headerView;

@property (nonatomic, strong) UIView *sectionButtonView;
@property (nonatomic, strong) UIView *sectionSelectView;


@end

static FFBusinessViewController *_controller = nil;

@implementation FFBusinessViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [FFBusinessModel sharedModel];
    [self setUserCenterButtonTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _controller = self;
    [self customNavLine];
}

- (void)initDataSource {
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"账号交易";
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT - kTABBAR_HEIGHT);
    self.navigationItem.rightBarButtonItem = self.userCenter;
    self.navigationItem.leftBarButtonItem = self.searchButton;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)refreshData {
    Reset_page;
    [self startWaiting];
    [FFBusinessModel productListWithGameName:@"" Page:New_page System:0 OrderType:(FFBusinessOrderTypeTime) OrderMethod:(FFBusinessOrderMethodDescending) Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        syLog(@"product === %@",content);
        if (success) {
            self.showArray = [CONTENT_DATA[@"list"] mutableCopy];
        }

        [self.tableView reloadData];
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];

}

- (void)loadMoreData {
    [self.refreshFooter endRefreshing];
}

- (void)begainRefresData {
    [self refreshData];
}

#pragma mark - table view data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.backgroundColor = [FFColorManager navigation_bar_white_color];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return Button_Height + Select_Heigth;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, Button_Height + Select_Heigth)];
    view.backgroundColor = [FFColorManager navigation_bar_white_color];


    [view addSubview:self.sectionButtonView];
    [view addSubview:self.sectionSelectView];
    return view;
}



#pragma mark - responds
- (void)respondsToLeftButton {
    if (currentUser() -> uid) {
        pushViewController(@"FFBusinessUserCenterViewController");
    } else  {
        pushViewController(@"FFBusinessLoginViewController");
    }
}

- (void)respondsToRightButton {
    pushViewController(@"FFBusinessSearchViewController");
}

- (void)respondsToButton:(UIButton *)sender {
    clickButton(sender.tag - Button_tag);
}

void clickButton(long idx) {
    syLog(@"点击 按钮 == %ld",idx);
    [_controller pushViewControllerWith:idx];
}

- (void)pushViewControllerWith:(NSUInteger)idx {
    switch (idx) {
        case 0: {pushViewController(@"FFBusinessNoticeViewController");} break;
        case 1: {pushViewController(@"FFBusinessSelectAccountViewController");} break;
        case 2: {pushViewController(@"FFBusinessRecordViewController");} break;
        case 3: {pushViewController(@"FFBusinessCustomerServiceViewController");} break;
        default: break;
    }
}

#pragma mark - setter
- (void)setUserCenterButtonTitle {
    if (currentUser() -> uid) {
        NSMutableString *username = [FFBusinessModel username].mutableCopy;
        [username replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        [self.userCenter setTitle:username];
    } else {
        [self.userCenter setTitle:@"登录"];
    }
}

#pragma mark - getter
- (UIBarButtonItem *)userCenter {
    if (!_userCenter) {
        _userCenter = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
//        [_userCenter setTintColor:[FFColorManager textColorMiddle]];
    }
    return _userCenter;
}

- (UIBarButtonItem *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIBarButtonItem alloc] initWithImage:[FFImageManager Home_search_image] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];
    }
    return _searchButton;
}

- (FFBusinessHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFBusinessHeaderView alloc] init];
    }
    return _headerView;
}

- (UIView *)sectionButtonView {
    if (!_sectionButtonView) {
        _sectionButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, Button_Height)];
        NSArray *titleArray = @[@"交易须知",@"我要卖号",@"交易记录",@"联系客服"];
        for (int i = 0 ; i < 4; i++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.tag = Button_tag + i;
            [button addTarget:self action:@selector(respondsToButton:) forControlEvents:(UIControlEventTouchUpInside)];
            button.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 4 - 5, Button_Height);
            button.frame = CGRectMake(kSCREEN_WIDTH / 4 * i, 0, kSCREEN_WIDTH / 4, Button_Height);
            [button setTitle:titleArray[i] forState:(UIControlStateNormal)];
            [button setTitleColor:[FFColorManager textColorMiddle] forState:(UIControlStateNormal)];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_sectionButtonView addSubview:button];

            CALayer *layer = [[CALayer alloc] init];
            layer.frame = CGRectMake(0, Button_Height - 0.5, kSCREEN_WIDTH, 0.5);
            layer.backgroundColor = [FFColorManager view_separa_line_color].CGColor;
            [_sectionButtonView.layer addSublayer:layer];
        }
    }
    return _sectionButtonView;
}

- (UIView *)sectionSelectView {
    if (!_sectionSelectView) {
        _sectionSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, Button_Height, kSCREEN_WIDTH, Select_Heigth)];


        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, Select_Heigth - 0.5, kSCREEN_WIDTH, 0.5);
        layer.backgroundColor = [FFColorManager view_separa_line_color].CGColor;
        [_sectionSelectView.layer addSublayer:layer];
    }
    return _sectionSelectView;
}



@end










