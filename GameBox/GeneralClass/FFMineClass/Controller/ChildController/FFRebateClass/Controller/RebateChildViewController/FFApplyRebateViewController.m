//
//  FFApplyRebateViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/2.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFApplyRebateViewController.h"
#import "RebateTableViewCell.h"
#import "FFRebateModel.h"
#import "FFApplyRebateModel.h"
#import <FFTools/FFTools.h>

#define CELL_IDE @"RebateTableViewCell"

@interface FFApplyRebateViewController ()<UITableViewDelegate, RebateTableViewCellDelegate>

@property (nonatomic, strong) NSDictionary *currentDict;
@property (nonatomic, assign) BOOL applying;

@property (nonatomic, strong) NSArray *testArray;

@end

@implementation FFApplyRebateViewController

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
    self.tableView.mj_footer = nil;
    BOX_REGISTER_CELL;
}

- (void)initDataSource {
    [super initDataSource];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData {
    [FFRebateModel applyRebateListWithCompletion:^(NSDictionary *content, BOOL success) {
        syLog(@"apply rebate == %@",content);
        if (success) {
            self.showArray = [FFApplyRebateModel modelArrayWithData:content[@"data"]];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    [self.tableView.mj_footer endRefreshing];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    RebateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    FFApplyRebateModel *model = self.showArray[indexPath.row];

    cell.model = model;

    cell.delegate = self;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//    RebateTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    FFApplyRebateModel *model = self.showArray[indexPath.row];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:model.userArray.count];
    [model.userArray enumerateObjectsUsingBlock:^(FFApplyUserModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleArray addObject:obj.all];
    }];

    [UIAlertController showAlertControllerWithViewController:self alertControllerStyle:(UIAlertControllerStyleActionSheet) title:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"选择返利的账号" otherButtonTitles:titleArray CallBackBlock:^(NSInteger btnIndex) {
        if (btnIndex == 0 || btnIndex == 1) {

        } else {
            syLog(@"%lu",btnIndex - 2);
            model.currentUserModel = model.userArray[btnIndex - 2];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
        }
    }];



//    if (_currentDict == self.showArray[indexPath.row]) {
//        return;
//    } else {
//        _currentDict = self.showArray[indexPath.row];
//    }
//
//    if (_applying) {
//        return;
//    }
//    _applying = YES;
//
//
//    [FFRebateModel rebateApplyWithAppID:_currentDict[@"appid"] RoleName:_currentDict[@"rolename"] RoleID:_currentDict[@"roleid"] Completion:^(NSDictionary *content, BOOL success) {
//
//        _applying = NO;
//        _currentDict = nil;
//        if (success) {
//            BOX_MESSAGE(@"申请成功");
//            [self.tableView.mj_header beginRefreshing];
//        } else {
//            BOX_MESSAGE(content[@"msg"]);
//        }
//
//    }];
}


#pragma mark - apply
- (void)RebateTableViewCell:(RebateTableViewCell *)cell clickApplyButtonWithUserModel:(FFApplyUserModel *)model {
    if (_applying) {
        return;
    }
    _applying = YES;
    [FFRebateModel rebateApplyWithAppID:cell.model.appID RoleName:model.roleName RoleID:model.roleID ServerID:model.serverID Completion:^(NSDictionary *content, BOOL success) {
            _applying = NO;
            _currentDict = nil;
            if (success) {
                [UIAlertController showAlertMessage:@"申请成功" dismissTime:0.7 dismissBlock:nil];
                [self.tableView.mj_header beginRefreshing];
            } else {
                [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
            }
        [self refreshData];
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.showArray.count == 0) {
        return 0;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    view.backgroundColor = [UIColor whiteColor];
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 43, kSCREEN_WIDTH, 1);
    layer.backgroundColor = BACKGROUND_COLOR.CGColor;
    [view.layer addSublayer:layer];

    UILabel *label1 = [self creatLabelWithTitle:@"游戏/区服" Frame:CGRectMake(0, 0, kSCREEN_WIDTH / 3, 44)];
    [view addSubview:label1];

    UILabel *label2 = [self creatLabelWithTitle:@"角色名" Frame:CGRectMake(kSCREEN_WIDTH / 3, 0, kSCREEN_WIDTH / 3, 44)];
    [view addSubview:label2];

    UILabel *label3 = [self creatLabelWithTitle:@"元宝或钻石" Frame:CGRectMake(kSCREEN_WIDTH / 3 * 2, 0, kSCREEN_WIDTH / 3, 44)];
    [view addSubview:label3];


    return view;
}


- (UILabel *)creatLabelWithTitle:(NSString *)title Frame:(CGRect )frame {
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    return label;
}




@end

















