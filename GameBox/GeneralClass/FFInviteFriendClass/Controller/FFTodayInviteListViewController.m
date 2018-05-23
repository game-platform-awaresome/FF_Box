//
//  FFTodayInviteListViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/29.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFTodayInviteListViewController.h"

#import "FFInviteListCell.h"

#define CELL_IDE @"FFInviteListCell"

@interface FFTodayInviteListViewController () <UITableViewDelegate>

@end

@implementation FFTodayInviteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)initUserInterface {
    [super initUserInterface];
    [self.view addSubview:self.tableView];
     self.tableView.mj_header = self.refreshHeader;
    self.tableView.mj_footer = nil;
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
}

- (void)refreshData {
    [[FFInviteModel sharedModel] refreshList];
}

- (void)loadMoreData {

}

- (void)begainRefresData {
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FFInviteListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.dict = self.showArray[indexPath.row];
    cell.gotModel = self.inviteListModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.showArray[indexPath.row];
    NSString *uid = dict[@"uid"];
    NSString *got = [NSString stringWithFormat:@"%@",dict[@"got"]];
    if ([uid isEqualToString:SSKEYCHAIN_UID] && [got isEqualToString:@"0"]) {
        syLog(@"领取邀请奖励");
        [[FFInviteModel sharedModel] gotInviteReward];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];

    UILabel *label1 = [self creatLabelWithTitle:@"排行"];
    label1.frame = CGRectMake(15, 7, 44, 30);
    [label1 sizeToFit];
    label1.center = CGPointMake(label1.center.x, 22);
    [view addSubview:label1];

    UILabel *label2 = [self creatLabelWithTitle:@"用户信息"];
    label2.frame = CGRectMake(100, 7, 44, 30);
    [label2 sizeToFit];
    label2.center = CGPointMake(label2.center.x, 22);
    [view addSubview:label2];

    UILabel *label3 = [self creatLabelWithTitle:@"邀请人数"];
    label3.frame = CGRectMake(kSCREEN_WIDTH * 0.55, 7, 44, 30);
    [label3 sizeToFit];
    label3.center = CGPointMake(label3.center.x, 22);
    [view addSubview:label3];

    UILabel *label4 = [self creatLabelWithTitle:@"奖励金币"];
    label4.frame = CGRectMake(kSCREEN_WIDTH - 60, 7, 44, 30);
    [label4 sizeToFit];
    label4.center = CGPointMake(label4.center.x, 22);
    [view addSubview:label4];

    CALayer *line = [[CALayer alloc] init];
    line.frame = CGRectMake(0, 43, kSCREEN_WIDTH, 1);
    line.backgroundColor = [UIColor lightGrayColor].CGColor;

    [view.layer addSublayer:line];
    view.backgroundColor = [UIColor whiteColor];

    return view;
}


- (UILabel *)creatLabelWithTitle:(NSString *)title {
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = title;
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor blackColor];
    return label1;
}


- (FFinviteListModel)inviteListModel {
    return today;
}




@end










