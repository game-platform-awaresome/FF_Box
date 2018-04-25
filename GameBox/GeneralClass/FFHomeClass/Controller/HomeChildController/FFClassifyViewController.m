//
//  FFClassifyViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/19.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFClassifyViewController.h"

@interface FFClassifyViewController ()

@end

@implementation FFClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma amrk - method
- (void)refreshData {
    [self.tableView.mj_header endRefreshing];
}

- (void)loadMoreData {

}


#pragma mark - setter


#pragma mark - getter






@end





