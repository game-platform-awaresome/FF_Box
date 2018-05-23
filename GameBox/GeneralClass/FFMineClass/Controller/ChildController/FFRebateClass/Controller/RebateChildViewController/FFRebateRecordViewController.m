//
//  FFRebateRecordViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/2.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRebateRecordViewController.h"
#import "FFRebateRecordCell.h"
#import "FFRebateModel.h"

#define CELL_IDE @"FFRebateRecordCell"

@interface FFRebateRecordViewController ()

@property (nonatomic, strong) FFRebateModel *model;

@end

@implementation FFRebateRecordViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = self.view.bounds;
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
}

- (void)initDataSource {
    [super initDataSource];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData {
    WeakSelf;
    [self.model loadNewRebateRecordWithCompletion:^(NSDictionary *content, BOOL success) {
        syLog(@"rebate record === %@",content);
        if (success) {
            weakSelf.showArray = [content[@"data"][@"rebate"] mutableCopy];
            [weakSelf.tableView reloadData];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    WeakSelf;
    [self.model loadMoreRebateRecordWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSArray *array = content[@"data"][@"rebate"];
            if (array.count > 0) {
                [weakSelf.showArray addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_footer endRefreshing];
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFRebateRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];

    cell.dict = self.showArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}





#pragma mark - getter
- (FFRebateModel *)model {
    if (!_model) {
        _model = [[FFRebateModel alloc] init];
    }
    return _model;
}













@end




























