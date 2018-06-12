//
//  FFBusinessSelectAccountViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/12.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessSelectAccountViewController.h"

@interface FFBusinessSelectAccountViewController ()

@end

@implementation FFBusinessSelectAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)initUserInterface {
    [super initUserInterface];
    [self.leftButton setImage:[FFImageManager General_back_black]];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    self.tableView.mj_footer = nil;
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);

    self.navigationItem.title = @"选择账号";
}

- (void)refreshData {
    [self.refreshHeader endRefreshing];
}





@end









