//
//  FFBTServerViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/10.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBTServerViewController.h"

@interface FFBTServerViewController ()

@end

@implementation FFBTServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kTABBAR_HEIGHT - kNAVIGATION_HEIGHT);
}

- (void)initDataSource {
    [super initDataSource];
}

#pragma mark - load data
- (void)refreshData {
    [self startWaiting];
    Reset_page;
    [FFGameModel GameServersWithType:BT_SERVERS Page:New_page Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            syLog(@"%s ==== %@",__func__,content);
        } else {

        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}





#pragma mark - getter





@end






