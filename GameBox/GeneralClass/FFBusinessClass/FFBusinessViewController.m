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

@interface FFBusinessViewController ()

@property (nonatomic, strong) UIBarButtonItem *userCenter;
@property (nonatomic, strong) UIBarButtonItem *searchButton;

@property (nonatomic, strong) FFBusinessHeaderView *headerView;

@end

@implementation FFBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataSource {
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
    self.showArray = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""].mutableCopy;
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"账号交易";
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT - kTABBAR_HEIGHT);
    self.navigationItem.leftBarButtonItem = self.userCenter;
    self.navigationItem.rightBarButtonItem = self.searchButton;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)refreshData {
    [self.refreshHeader endRefreshing];
}

- (void)loadMoreData {
    [self.refreshFooter endRefreshing];
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
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    view.backgroundColor = [FFColorManager navigation_bar_black_color];

    return view;
}

void clickButton(long idx) {
    syLog(@"点击 按钮 == %ld",idx);
}

#pragma mark - responds
- (void)respondsToLeftButton {
    if (currentUser() -> uid) {

    } else  {
        pushViewController(@"FFBusinessLoginViewController");
    }
}

- (void)respondsToRightButton {
    syLog(@"搜索");
    
}

#pragma mark - getter
- (UIBarButtonItem *)userCenter {
    if (!_userCenter) {
        _userCenter = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
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





@end










