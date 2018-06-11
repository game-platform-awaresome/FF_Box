//
//  FFBusinessViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/8.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessViewController.h"

@interface FFBusinessViewController ()




@end

@implementation FFBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"账号交易";
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT - kTABBAR_HEIGHT);
}

- (void)refreshData {
    [self.refreshHeader endRefreshing];
}

- (void)loadMoreData {
    [self.refreshFooter endRefreshing];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    view.backgroundColor = [FFColorManager blue_dark];

    return view;
}










@end










