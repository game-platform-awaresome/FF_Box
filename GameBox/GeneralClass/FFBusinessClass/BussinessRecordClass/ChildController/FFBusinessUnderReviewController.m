//
//  FFBusinessUnderReviewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessUnderReviewController.h"
#import "FFBusinessSellRecordCell.h"

#define CELL_IDE @"FFBusinessSellRecordCell"

@interface FFBusinessUnderReviewController ()<FFBusinessSellRecordCellDelegate>

@end

@implementation FFBusinessUnderReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initDataSource {
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
}


- (void)initUserInterface {
    [super initUserInterface];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}


- (void)refreshData {
    Reset_page;
    [self startWaiting];
    [FFBusinessModel userSellRecordWithPage:New_page Type:self.type Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            NSArray *array = CONTENT_DATA[@"list"];
            self.showArray = array.mutableCopy;
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
    [self startWaiting];
    [FFBusinessModel userSellRecordWithPage:Next_page Type:self.type Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            NSArray *array = CONTENT_DATA[@"list"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.refreshFooter endRefreshing];
                [self.tableView reloadData];
            } else {
                [self.refreshFooter endRefreshingWithNoMoreData];
            }
        } else {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - table view data source and delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFBusinessSellRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    cell.dict = self.showArray[indexPath.row];
    cell.type = self.type;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - cell delelgate
- (void)FFBusinessSellRecordCell:(FFBusinessSellRecordCell *)cell clickButtonWithInfo:(id)info {
    syLog(@"点击 cell 按钮");
    switch (self.type) {
        case FFBusinessUserSellTypeUnderReview: {

            break;
        }
        case FFBusinessUserSellTypeSelling: {
            //售卖中, 下架操作/
            [UIAlertController showAlertControllerWithViewController:self alertControllerStyle:(UIAlertControllerStyleAlert) title:@"确定下架商品吗" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle: nil otherButtonTitles:@[@"确定"] CallBackBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self DropOffProductWith:cell.dict];
                }
            }];
            break;
        }
        case FFBusinessUserSellTypeSold: {

            break;
        }
        case FFBusinessUserSellTypeTransacton: {

            break;
        }
        case FFBusinessUserSellTypeCancel: {

            break;
        }

        default:
            break;
    }
}

#pragma mark - method
- (void)DropOffProductWith:(NSDictionary *)dict {
    syLog(@"下架商品");
    [FFBusinessModel dropOffProductWithID:[NSString stringWithFormat:@"%@",dict[@"id"]] Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        success ? [UIAlertController showAlertMessage:@"下架成功" dismissTime:0.7 dismissBlock:^{
            [self refreshData];
        }] : [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
    }];
}


#pragma mark - getter
- (FFBusinessUserSellType)type {
    return FFBusinessUserSellTypeUnderReview;
}



@end


