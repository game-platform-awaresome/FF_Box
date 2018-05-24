//
//  FFMyPrizeViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/28.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMyPrizeViewController.h"
#import "FFUserModel.h"
#import "FFMyprizeCell.h"

#define CELL_IDE @"FFMyprizeCell"

@interface FFMyPrizeViewController () <UITableViewDelegate>

@end

@implementation FFMyPrizeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"我的奖品";
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame));
    self.tableView.mj_footer = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
}

- (void)refreshData {
    [FFUserModel myPrizeCompletion:^(NSDictionary *content, BOOL success) {
        syLog(@"my prize === %@",content);
        if (success) {
            self.showArray = content[@"data"];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFMyprizeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.dict = self.showArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 59, kSCREEN_WIDTH, 1);
    layer.backgroundColor = BACKGROUND_COLOR.CGColor;
    [cell.contentView.layer addSublayer:layer];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BACKGROUND_COLOR;
    view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 30);

    UILabel *timeTitle = [[UILabel alloc] init];
    timeTitle.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 3, 30);
    timeTitle.text = @"时间";
    timeTitle.textAlignment = NSTextAlignmentCenter;
    timeTitle.center = CGPointMake(kSCREEN_WIDTH / 3, 15);
    [view addSubview:timeTitle];

    UILabel *detail = [[UILabel alloc] init];
    detail.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 3, 30);
    detail.text = @"奖品";
    detail.textAlignment = NSTextAlignmentCenter;
    detail.center = CGPointMake(kSCREEN_WIDTH / 6 * 5, 15);
    [view addSubview:detail];

    return view;
}




@end







