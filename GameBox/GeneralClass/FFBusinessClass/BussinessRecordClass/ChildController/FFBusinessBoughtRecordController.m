//
//  FFBusinessBoughtRecordController.m
//  GameBox
//
//  Created by 燚 on 2018/6/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessBoughtRecordController.h"
#import "FFBusinessModel.h"
#import "FFBusinessSellRecordCell.h"

#define CELL_IDE @"FFBusinessSellRecordCell"

@interface FFBusinessBoughtRecordController ()


@end

@implementation FFBusinessBoughtRecordController


- (void)refreshData {
    [self startWaiting];
    [FFBusinessModel userButRecordWithType:(FFBusinessUserBuyTypeAll) Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            NSArray *array = CONTENT_DATA;
            if ([array isKindOfClass:[NSArray class]]) {
                self.showArray = array.mutableCopy;
            } else {
                [UIAlertController showAlertMessage:@"暂无购买记录" dismissTime:0.7 dismissBlock:nil];
            }
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
        syLog(@"user sell === %@",content);
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    [self.refreshFooter endRefreshingWithNoMoreData];
}




#pragma mark - getter
- (BOOL)isBuy {
    return YES;
}





@end











