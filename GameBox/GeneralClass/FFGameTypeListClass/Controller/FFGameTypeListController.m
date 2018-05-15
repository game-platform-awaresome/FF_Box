//
//  FFGameTypeController.m
//  GameBox
//
//  Created by 燚 on 2018/5/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameTypeListController.h"

@interface FFGameTypeListController ()



@end

@implementation FFGameTypeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
}

#pragma mark - method
- (void)refreshData {
    self.currentPage = 1;
    [self startWaiting];
    [FFGameModel gameListWithPage:New_page ServerType:self.gameServerType GameType:self.gameType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];

        syLog(@"???????????????? == %@",content);
        if (success) {
            self.showArray = [content[@"data"] mutableCopy];
        } else {

        }

        if (self.showArray && self.showArray.count > 0) {
            self.tableView.backgroundView = nil;
        } else {
            self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    [FFGameModel gameListWithPage:Next_page ServerType:self.gameServerType GameType:self.gameType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
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

#pragma mark - getter
- (FFGameServersType)gameServerType {
    return BT_SERVERS;
}

- (NSString *)gameType {
    return @"1";
}

@end
