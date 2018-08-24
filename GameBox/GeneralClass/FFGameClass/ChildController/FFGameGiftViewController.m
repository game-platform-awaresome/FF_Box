//
//  FFGameGiftViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameGiftViewController.h"
#import "FFCurrentGameModel.h"
#import "FFpackageCell.h"
#import <FFTools/FFTools.h>
#import "FFGiftDetailController.h"

#define CELL_IDE @"FFpackageCell"

@interface FFGameGiftViewController ()<FFpackageCellDelegate>

@end

@implementation FFGameGiftViewController

- (void)viewWillAppear:(BOOL)animated {
    if (self.canRefresh) {
        [self refreshData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.mj_footer = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    BOX_REGISTER_CELL;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)refreshData {
    [FFGameModel gameGiftWithGameID:CURRENT_GAME.game_id Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        syLog(@"game gitf -==== %@",content);
        if (success) {
            self.showArray = [content[@"data"][@"list"] mutableCopy];
            [self.tableView reloadData];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFpackageCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.dict = self.showArray[indexPath.row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.gameLogo
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.parentViewController.parentViewController.hidesBottomBarWhenPushed = YES;
    [self pushViewController:[FFGiftDetailController detail:self.showArray[indexPath.row]]];

}

#pragma mark - cell delegate
- (void)FFpackageCell:(FFpackageCell *)cell select:(NSInteger)idx {
    syLog(@"领取礼包");
    NSString *str = self.showArray[idx][@"card"];

    if ([str isKindOfClass:[NSNull class]]) {
        [FFGameModel getGameGiftWithPackageID:cell.dict[@"id"] Completion:^(NSDictionary * _Nonnull content, BOOL success) {
            if (success) {
                NSMutableDictionary *dict = [self.showArray[idx] mutableCopy];
                [dict setObject:content[@"data"] forKey:@"card"];
                [self.showArray replaceObjectAtIndex:idx withObject:dict];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
                [UIAlertController showAlertMessage:@"领取成功" dismissTime:0.7 dismissBlock:nil];
            } else {
                [UIAlertController showAlertMessage:@"领取失败" dismissTime:0.7 dismissBlock:nil];
            }
        }];

    } else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
        [UIAlertController showAlertMessage:@"已复制礼包兑换码" dismissTime:0.7 dismissBlock:nil];
    }
}



@end
