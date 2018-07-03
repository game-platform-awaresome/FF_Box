//
//  FFReservationGameController.m
//  GameBox
//
//  Created by 燚 on 2018/6/5.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFReservationGameController.h"
#import "FFCustomizeCell.h"
#import "FFNotificationHandler.h"
#import "FFUserModel.h"

#define CELL_IDE @"FFCustomizeCell"

@interface FFReservationGameController () <FFCustomizeCellDelegate>

@end

@implementation FFReservationGameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"预约游戏";
}

- (FFBetaOrReservationType)type {
    return FFReservation;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFCustomizeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    [cell setValue:@3 forKey:@"selectionStyle"];
    [cell setValue:self.showArray[indexPath.row] forKey:@"dict"];
    cell.delegate = self;
    return cell;
}

#pragma mark - cell delegate
- (void)FFCustomizeCell:(FFCustomizeCell *)cell didSelectCellRowAtIndexPathWith:(NSDictionary *)dict {
    syLog(@"预约游戏");
    NSString *isReserved = [NSString stringWithFormat:@"%@",dict[@"is_reserved"]];
    if (isReserved.boolValue) {
        return;
    }
    NSString *time = [NSString stringWithFormat:@"%@",dict[@"newgame_time"]];
    NSString *gameID = [NSString stringWithFormat:@"%@",dict[@"id"]];
    NSString *gameName = [NSString stringWithFormat:@"%@",dict[@"gamename"]];

    if (![FFUserModel uid]) {
        return;
    }
    [self startWaiting];
    [FFGameModel reservaGameWithGameID:gameID Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            [self refreshData];
            [UIAlertController showAlertMessage:@"预约成功" dismissTime:0.7 dismissBlock:nil];
            [FFNotificationHandler addNotificationWithTitle:[NSString stringWithFormat:@"%@已经上线,快来体验吧!",gameName] Body:[NSString stringWithFormat:@"%@现已火热上线,百万玩家等你来战!",gameName] Time:time UserInfo:dict RequestIdentifier:[NSString stringWithFormat:@"Reserved-%@-%@",gameID,gameName] Repeat:NO Completion:^(BOOL success) {
                if (success) {
                    syLog(@"预约成功?");
                } else {
                    syLog(@"预约失败");
                    [UIAlertController showAlertMessage:@"请在设置中打开通知" dismissTime:0.7 dismissBlock:nil];
                }
            }];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
    }];
}




@end










