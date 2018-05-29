//
//  FFClassifyDetailViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFClassifyDetailViewController.h"

@interface FFClassifyDetailViewController ()

@property (nonatomic, strong) NSString *classifyID;

@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation FFClassifyDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_isRefresh) {
        self.showArray = nil;
        [self.tableView reloadData];
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initUserInterface {
    [super initUserInterface];
}

- (void)initDataSource {
    [super initDataSource];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
}

- (void)refreshData {
    Reset_page;
    if (self.classifyID == nil) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    [self startWaiting];



    [FFGameModel gameclassifyWithClassifyID:self.classifyID Page:New_page ServerType:self.gameServersType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        _isRefresh = YES;
        syLog(@"refresh data");
        if (success) {
            self.showArray = [content[@"data"] mutableCopy];
        } else {
            self.showArray = nil;
        }
        [self.tableView reloadData];

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    [FFGameModel gameclassifyWithClassifyID:self.classifyID Page:New_page ServerType:self.gameServersType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            NSMutableArray *array = [content[@"data"] mutableCopy];
            if (array == nil || array.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.showArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    syLog(@"set dict === %@",dict);
    if (dict != nil && ![dict[@"id"] isEqualToString:_dict[@"id"]]) {
        _dict = dict;
        self.navigationItem.title = dict[@"name"];
        self.classifyID = dict[@"id"];
        _isRefresh = NO;
    }
}



@end




