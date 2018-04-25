//
//  FFGameGuideViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/19.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameGuideViewController.h"

@interface FFGameGuideViewController ()

@end

@implementation FFGameGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.showsVerticalScrollIndicator = YES;
}

- (void)initDataSource {
    [super initDataSource];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma amrk - method
- (void)refreshData {
    self.currentPage = 1;
    [FFGameModel gameGuideListWithPage:New_page Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        syLog(@"game guide list === %@",content);
        if (success) {
            self.showArray = [content[@"data"][@"list"] mutableCopy];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {

}

#pragma mark - getter







@end
