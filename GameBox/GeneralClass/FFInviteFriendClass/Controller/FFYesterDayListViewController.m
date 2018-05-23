//
//  FFYesterDayListViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/29.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFYesterDayListViewController.h"

@interface FFYesterDayListViewController ()

@end

@implementation FFYesterDayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
    [self.tableView reloadData];
}

- (FFinviteListModel)inviteListModel {
    return yesterday;
}













@end
