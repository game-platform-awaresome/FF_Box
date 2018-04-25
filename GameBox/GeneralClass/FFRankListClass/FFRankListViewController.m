//
//  FFRankListViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFRankListViewController.h"

@interface FFRankListViewController ()


@property (nonatomic, strong) NSString *gameType;


@end

@implementation FFRankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
}

- (void)initDataSource {
    [super initDataSource];
    [self setGameType:@"2"];
}


#pragma mark - method
- (void)refreshData {
    self.currentPage = 1;
    [self startWaiting];
    [FFGameModel gameListWithPage:[NSString stringWithFormat:@"%lu",self.currentPage] GameType:self.gameType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];

        if (success) {
            self.showArray = [content[@"data"] mutableCopy];
            [self.tableView reloadData];
        } else {

        }

        if (self.showArray && self.showArray.count > 0) {
            self.tableView.backgroundView = nil;
        } else {
            self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    [FFGameModel gameListWithPage:[NSString stringWithFormat:@"%lu",++self.currentPage] GameType:self.gameType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            NSArray *dataArray = content[@"data"];
            if (dataArray.count > 0) {
                [self.showArray addObjectsFromArray:dataArray];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {

            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - setter
- (void)setGameType:(NSString *)gameType {
    _gameType = gameType;
}







@end








