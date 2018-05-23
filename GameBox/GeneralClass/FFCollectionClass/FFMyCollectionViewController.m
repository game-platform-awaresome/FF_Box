//
//  FFMyCollectionViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFMyCollectionViewController.h"
#import "FFUserModel.h"
#import "FFGameViewController.h"


@interface FFMyCollectionViewController ()

@end

@implementation FFMyCollectionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"1.0";
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame));
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"我的收藏";
}


- (void)refreshData {
    Reset_page;
    [FFUserModel myCollectionGameWithPage:New_page Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            syLog(@"my collectino == %@",content);
            NSArray *array = content[@"data"];
            self.showArray = [array mutableCopy];
            [self.tableView reloadData];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    [FFUserModel myCollectionGameWithPage:Next_page Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSArray *array = content[@"data"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            BOX_MESSAGE(content[@"msg"]);
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}


@end
