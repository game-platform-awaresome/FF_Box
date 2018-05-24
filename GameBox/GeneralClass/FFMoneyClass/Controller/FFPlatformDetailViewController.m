//
//  FFPlatformDetailViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFPlatformDetailViewController.h"
#import "FFPlatformCell.h"
#import "FFUserModel.h"

#define CELL_IDE @"FFPlatformCell"

@interface FFPlatformDetailViewController ()



@end

@implementation FFPlatformDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"平台币明细";
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData {
    Reset_page;
    [self startWaiting];
    [FFUserModel coinPlatformDetailWithPage:New_page Completion:^(NSDictionary *content, BOOL success) {
        [self stopWaiting];
        if (success) {
            self.showArray = [content[@"data"][@"list"] mutableCopy];
            [self.tableView reloadData];
        } else {
            BOX_MESSAGE(content[@"msg"]);

        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    [self stopWaiting];
    [FFUserModel coinPlatformDetailWithPage:Next_page Completion:^(NSDictionary *content, BOOL success) {
        STOP_NET_WORK;
        if (success) {
            NSArray *array = content[@"data"][@"list"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            } else {
                BOX_MESSAGE(@"只能查看最近7天的记录");
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFPlatformCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.dict = self.showArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.showArray.count == 0) {
        return 0;
    }
    return kSCREEN_WIDTH * 0.13;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.13)];
    view.backgroundColor = BACKGROUND_COLOR;

    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    labelView.backgroundColor = [UIColor whiteColor];
    [labelView addSubview:[self creatLabelWithIndex:0 title:@"时间"]];
    [labelView addSubview:[self creatLabelWithIndex:1 title:@"收支类型"]];
    [labelView addSubview:[self creatLabelWithIndex:2 title:@"数量变更"]];
    [labelView addSubview:[self creatLabelWithIndex:3 title:@"余额"]];

    [view addSubview:labelView];

    return view;
}

- (UILabel *)creatLabelWithIndex:(NSInteger)index title:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH / 4 * index + 1, 0, kSCREEN_WIDTH / 4 - 2, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    return label;
}







@end
