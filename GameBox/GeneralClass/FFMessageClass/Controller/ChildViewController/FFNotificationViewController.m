//
//  FFNotificationViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/23.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFNotificationViewController.h"
#import "FFBoxModel.h"
#import "FFOpenServerCell.h"

#define CELL_IDE @"FFOpenServerCell"

@interface FFNotificationViewController ()<UITableViewDelegate, UITableViewDataSource>



@end

@implementation FFNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}


- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor grayColor];
    self.tableView.mj_footer = nil;
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
    [self.tableView.mj_header beginRefreshing];
//    [self.tableView setEditing:YES animated:YES];
}

#pragma mark - method
- (void)refreshData {
    self.showArray = [[FFBoxModel allNotifications] mutableCopy];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)loadMoreData {

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FFOpenServerCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];

    cell.dict = self.showArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [FFBoxModel deleteNotificationWith:self.showArray[indexPath.row]];
        [self.showArray removeObjectAtIndex:indexPath.row];
//        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        [self.tableView reloadData];
        syLog(@"删除 %ld",(long)indexPath.row);

    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}







- (void)deleteAllNotification {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定清空所有开服通知吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [FFBoxModel deleteAllNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deletAllnotification" object:nil userInfo:nil];
        [self.tableView.mj_header beginRefreshing];
    }];
    UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:sureAct];
    [alertController addAction:cancelAct];

    [self presentViewController:alertController animated:YES completion:nil];
}




@end







