//
//  FFRecommentViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFRecommentViewController.h"

@interface FFRecommentViewController ()

@property (nonatomic, assign) NSUInteger currentPage;

@end

@implementation FFRecommentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.tableView.mj_header beginRefreshing];
}

- (void)initUserInterface {
    [super initUserInterface];
}

- (void)initDataSource {
    [super initDataSource];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - method
- (void)refreshData {
    [self startWaiting];
    _currentPage = 1;
    [FFGameModel recommentGameListWithPage:[NSString stringWithFormat:@"%lu",_currentPage] Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
//            self.carouselView.rollingArray = content[@"data"][@"banner"];
            self.showArray = [content[@"data"][@"gamelist"] mutableCopy];
            [self.tableView reloadData];
        } else {

        }

        if (self.showArray && self.showArray.count > 0) {
            self.tableView.backgroundView = nil;
        } else {
            self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

//        if (self.carouselView.rollingArray.count > 0) {
//            self.tableView.tableHeaderView = weakSelf.carouselView;
//        } else {
//            self.tableView.tableHeaderView = nil;
//        }

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    [FFGameModel recommentGameListWithPage:[NSString stringWithFormat:@"%lu",++_currentPage] Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            NSMutableArray *array = [content[@"data"][@"gamelist"] mutableCopy];
            if (array.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.showArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        } else {
            [self.tableView.mj_footer endRefreshing];
        }

        if (self.showArray && self.showArray.count > 0) {
            self.tableView.backgroundView = nil;
        } else {
            self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }
    }];
}




@end
