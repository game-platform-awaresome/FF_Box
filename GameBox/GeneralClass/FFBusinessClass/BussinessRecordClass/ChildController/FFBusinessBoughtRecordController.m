//
//  FFBusinessBoughtRecordController.m
//  GameBox
//
//  Created by 燚 on 2018/6/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessBoughtRecordController.h"
#import "FFBusinessModel.h"

@interface FFBusinessBoughtRecordController ()

@end

@implementation FFBusinessBoughtRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initDataSource {
    [super initDataSource];
}

- (void)initUserInterface {
    [super initUserInterface];
}


- (void)refreshData {
    [self startWaiting];
    [FFBusinessModel userButRecordWithType:(FFBusinessUserBuyTypeAll) Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {

        }

        syLog(@"user recored === %@",content);
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];
}







@end











