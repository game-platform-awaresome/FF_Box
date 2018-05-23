//
//  FFNewsViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/23.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFNewsViewController.h"
#import "FFMyNewsModel.h"
#import "FFMyNewsCell.h"
#import "FFReplyToCommentController.h"
#import "FFGameModel.h"


#define CELL_IDE @"FFMyNewsCell"

#define MODEL FFMyNewsModel

@interface FFNewsViewController ()



@end

@implementation FFNewsViewController

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
    self.view.layer.masksToBounds = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - method
- (void)refreshData {

    Reset_page;
    [self startWaiting];
    [MODEL getUserNewsWithPage:New_page CompleteBlock:^(NSDictionary *content, BOOL success) {
        [self stopWaiting];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        if (success) {
            self.showArray = [content[@"data"][@"list"] mutableCopy];
        } else {
            self.showArray = nil;
            BOX_MESSAGE(@"暂无数据");
        }
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    [self startWaiting];
    [MODEL getUserNewsWithPage:New_page CompleteBlock:^(NSDictionary *content, BOOL success) {
        [self stopWaiting];
        if (success) {
            //            syLog(@"contetn $ %@",content);
            NSArray *array = content[@"data"][@"list"];
            if (array == nil ||array.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.showArray addObjectsFromArray:array];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];

    [self.tableView.mj_footer endRefreshing];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFMyNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];

    cell.dict = self.showArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.showArray[indexPath.row];
    FFReplyToCommentController *replyController = [[FFReplyToCommentController alloc] init];
    replyController.commentDict = dict;
    replyController.completion = ^(NSDictionary *content, BOOL success) {
        [self.navigationController popViewControllerAnimated:YES];
        if (success) {
            [UIAlertController showAlertMessage:@"回复成功" dismissTime:0.7 dismissBlock:nil];
        } else {
            [UIAlertController showAlertMessage:@"回复失败,请稍后尝试" dismissTime:0.7 dismissBlock:nil];
        }
    };
//    CURRENT_GAME.game_id = [NSString stringWithFormat:@"%@",dict[@"dynamics_id"]];
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:replyController animated:YES];

}






@end






