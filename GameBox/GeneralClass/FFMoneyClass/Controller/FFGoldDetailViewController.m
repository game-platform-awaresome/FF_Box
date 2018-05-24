//
//  FFGoldDetailViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFGoldDetailViewController.h"
#import "FFCoinDetailCell.h"
#import "FFUserModel.h"

#define CELL_IDE @"FFCoinDetailCell"

@interface FFGoldDetailViewController () <UITableViewDelegate>



@end

@implementation FFGoldDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"1.0";
    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_black_color]];
    [self.navigationController.navigationBar setBarTintColor:[FFColorManager navigation_bar_white_color]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"金币明细";
     self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
    [self.tableView.mj_header beginRefreshing];
}


- (void)refreshData {
    Reset_page;
    [self startWaiting];
    [FFUserModel coinDetailWithPage:New_page Completion:^(NSDictionary *content, BOOL success) {
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
    [self startWaiting];
    [FFUserModel coinDetailWithPage:Next_page Completion:^(NSDictionary *content, BOOL success) {
        [self stopWaiting];
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
    FFCoinDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.dict = self.showArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.showArray.count == 0) {
        return 0;
    }
    return 80;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 80)];
    view.backgroundColor = BACKGROUND_COLOR;
    UILabel *remindeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 33)];
    remindeLabel.text = @"温馨提示:签到,每日好评,金币抽奖都可获得金币";
    remindeLabel.textColor = [UIColor redColor];
    remindeLabel.textAlignment = NSTextAlignmentCenter;
    remindeLabel.font = [UIFont systemFontOfSize:14];
//    [remindeLabel sizeToFit];
    [view addSubview:remindeLabel];
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 33, kSCREEN_WIDTH, 44)];
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
