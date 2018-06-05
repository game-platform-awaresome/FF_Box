//
//  FFGameDetailViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameDetailViewController.h"
#import "FFCurrentGameModel.h"
#import "FFGameDetailSectionModel.h"
#import "FFGameDetailHeaderView.h"

#import "FFGameDetailCell.h"
#import "FFWebViewController.h"

#define CELL_IDE @"FFGameDetailCell"

@interface FFGameDetailViewController ()

@property (nonatomic, strong) FFGameDetailHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray<FFGameDetailSectionModel *> *sectionArray;

@property (nonatomic, assign) BOOL isAnimation;

@end

@implementation FFGameDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [self resetTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initDataSource {
    self.sectionArray = [NSMutableArray arrayWithCapacity:6];
    for (int i = 0; i < 6; i++) {
        [self.sectionArray addObject:[FFGameDetailSectionModel initWithType:i]];
    }
    WeakSelf;
    [self.sectionArray[SecTionTypeActivity] setActivityBlock:^(NSDictionary *dict) {
        FFWebViewController *webVC = [[FFWebViewController alloc] init];
        webVC.webURL = dict[@"info_url"];
        weakSelf.hidesBottomBarWhenPushed = YES;
        [weakSelf pushViewController:webVC];
    }];
}

- (void)viewDidLayoutSubviews {
    self.tableView.frame = self.view.bounds;
}

- (void)refreshData {
    [super refreshData];
    self.headerView.imageArray = CURRENT_GAME.showImageArray;
    self.tableView.tableHeaderView = self.headerView;
    for (int i = 0; i < 6; i++) {
        [self.sectionArray[i] refreshDataWith:i];
        self.sectionArray[i].tableView = self.tableView;
    }

    [CURRENT_GAME getGameActivity];
    //刷新活动


    [self.tableView reloadData];
}

#pragma mark - objserve


#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionArray[section].sectionItemNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.sectionArray[indexPath.section].cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.sectionArray[indexPath.section] modelTableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.sectionArray[section].sectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sectionArray[section].sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.sectionArray[section].sectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.sectionArray[section].sectionFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.sectionArray[indexPath.section].openUp ? self.sectionArray[indexPath.section].openUpHeight : self.sectionArray[indexPath.section].normalHeight;
}


#pragma mark - setter


#pragma mark - getter
- (FFGameDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFGameDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.72)];
    }
    return _headerView;
}



- (void)resetTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0,0) style:(UITableViewStyleGrouped)];
    BOX_REGISTER_CELL;
    [self.tableView registerClass:NSClassFromString(@"FFSRcommentCell") forCellReuseIdentifier:@"FFSRcommentCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;


//    self.tableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
    } else {

    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}








@end










