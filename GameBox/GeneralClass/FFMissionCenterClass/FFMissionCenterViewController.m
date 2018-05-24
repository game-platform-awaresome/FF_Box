//
//  FFMissionCenterViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFMissionCenterViewController.h"
#import "FFMissionCell.h"

#define CELL_IDE @"FFMissionCell"


typedef enum : NSUInteger {
    CellIndexTypeSignin = 0,
    CellIndexTypeComment,
    CellIndexTypeDrive,
    CellIndexTypeInvite,
    CellIndexTypeInviteList,
    CellIndexTypeGoldLottary,
    CellIndexTypeGoldExchange,
    CellIndexTypeVip
} CellIndexType;


@interface FFMissionCenterViewController ()


@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) NSMutableDictionary *dataDict;

@property (nonatomic, strong) NSDictionary *setDict;

@end

@implementation FFMissionCenterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"0.0";
    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_white_color]];
    [self refreshData];
}


- (void)initDataSource {
    self.showArray = [self.dataDict allKeys].mutableCopy;
    BOX_REGISTER_CELL;
}

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.scrollEnabled = NO;
    self.navigationItem.title = @"任务中心";
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH / 2, 30)];
    titleLabel.text = @"任务中心";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [FFColorManager navigation_bar_white_color];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
}

- (void)refreshData {
    [self startWaiting];
    [FFGameModel missionCenterInfoCompletion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            syLog(@"mission center === %@",content);
            self.setDict = content[@"data"];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        [self.tableView reloadData];
    }];
}


#pragma mark - table view delegate ande data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFMissionCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.detailTextLabel.textColor = [FFColorManager textColorMiddle];
    NSDictionary *dict = self.dataDict[@(indexPath.row)];
    cell.dict = dict;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSCREEN_HEIGHT * 0.66 / self.showArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *className = nil;
    switch (indexPath.row) {
        case CellIndexTypeSignin:       className = @"FFSignInViewController"; break;
        case CellIndexTypeComment:      className = @"FFEverydayCommentController"; break;
        case CellIndexTypeDrive:        className = @"FFDrivePostStatusViewController"; break;
        case CellIndexTypeInvite:       className = @"FFInviteFriendViewController"; break;
        case CellIndexTypeInviteList:   className = @"FFInviteRankListViewController"; break;
        case CellIndexTypeGoldLottary:  className = @"FFLotteryViewController"; break;
        case CellIndexTypeGoldExchange: className = @"FFExchangeCoinController"; break;
        case CellIndexTypeVip:          className = @"FFOpenVipViewController"; break;
        default:
            break;
    }

    Class ViewController = NSClassFromString(className);
    if (ViewController) {
        id vc = [[ViewController alloc] init];
        [self pushViewController:vc];
    } else {
        syLog(@"%s error -> %@ not exist",__func__,className);
    }

}


#pragma mark - setter
- (void)setSetDict:(NSDictionary *)setDict {
    if ([setDict isKindOfClass:[NSDictionary class]]) {
        _setDict = setDict;
        [self setDriveBonus:setDict[@"drive_bonus"]];
        [self setLotteryBonus:setDict[@"lottery_bonus"]];
        [self setpl_coin:setDict[@"pl_coin"]];
        [self setrank_recom_top:setDict[@"rank_recom_top"]];
        [self setrecom_top:setDict[@"recom_top"]];
        [self setSignString:setDict[@"sign_day_bonus"]];
        [self setCompletion:setDict[@"task"]];
    }
}

- (void)setDriveBonus:(NSString *)drive_bonus {
    if (drive_bonus.length < 1) {
        return;
    }
    NSString *string = [NSString stringWithFormat:@"每日首次发车成功奖励%@金币",drive_bonus];
    [self refreshTableViewWith:CellIndexTypeDrive WithAttributeString:[self attributeStringWithTotalString:string subString:drive_bonus]];
}

- (void)setLotteryBonus:(NSString *)lottery_bonus {
    lottery_bonus = [NSString stringWithFormat:@"%@",lottery_bonus];
    if (lottery_bonus.length < 1) {
        return;
    }
    NSString *string = [NSString stringWithFormat:@"最高得到%@金币",lottery_bonus];
    [self refreshTableViewWith:CellIndexTypeGoldLottary WithAttributeString:[self attributeStringWithTotalString:string subString:lottery_bonus]];
}

- (void)setpl_coin:(NSString *)string {
    string = [NSString stringWithFormat:@"%@",string];
    if (string.length < 1) {
        return;
    }
    NSString *Rstring = [NSString stringWithFormat:@"最高得到%@金币",string];
    [self refreshTableViewWith:CellIndexTypeComment WithAttributeString:[self attributeStringWithTotalString:Rstring subString:string]];
}

- (void)setplatform_coin_ratio:(NSString *)string {
    string = [NSString stringWithFormat:@"%@",string];
    if (string.length < 1) {
        return;
    }
    NSString *Rstring = [NSString stringWithFormat:@"最高得到%@金币",string];
    [self refreshTableViewWith:CellIndexTypeGoldExchange WithAttributeString:[self attributeStringWithTotalString:Rstring subString:string]];
}

- (void)setrank_recom_top:(NSString *)string {
    string = [NSString stringWithFormat:@"%@",string];
    if (string.length < 1) {
        return;
    }
    NSString *Rstring = [NSString stringWithFormat:@"最高奖励%@金币",string];
    [self refreshTableViewWith:CellIndexTypeInviteList WithAttributeString:[self attributeStringWithTotalString:Rstring subString:string]];
}

- (void)setrecom_top:(NSString *)string {
    string = [NSString stringWithFormat:@"%@",string];
    if (string.length < 1) {
        return;
    }
    NSString *Rstring = [NSString stringWithFormat:@"最高奖励%@金币/每人",string];
    [self refreshTableViewWith:CellIndexTypeInvite WithAttributeString:[self attributeStringWithTotalString:Rstring subString:string]];
}

- (void)setSignString:(id)sender {
    if ([sender isKindOfClass:[NSDictionary class]]) {
        NSString *string1 = [NSString stringWithFormat:@"%@",sender[@"normal"]];
        NSString *string2 = [NSString stringWithFormat:@"%@",sender[@"vip_extra"]];
        NSString *Rstring = [NSString stringWithFormat:@"签到+%@金币,vip额外+%@金币",string1,string2];
        NSRange range1 = [Rstring rangeOfString:string1];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:Rstring];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[FFColorManager blue_dark] range:range1];
        range1 = [Rstring rangeOfString:string2];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[FFColorManager blue_dark] range:range1];
        [self refreshTableViewWith:CellIndexTypeSignin WithAttributeString:attributeString];
    }
}

- (NSMutableAttributedString *)attributeStringWithTotalString:(NSString *)totalStirng subString:(NSString *)subString {
    NSRange range1 = [totalStirng rangeOfString:subString];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:totalStirng];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[FFColorManager blue_dark] range:range1];
    return attributeString;
}

- (void)refreshTableViewWith:(NSUInteger)idx WithAttributeString:(NSMutableAttributedString *)attributeString {
    NSMutableDictionary *mutableDict = [self.dataDict[@(idx)] mutableCopy];
    [mutableDict setObject:attributeString forKey:@"subTitle"];
    [self.dataDict setObject:mutableDict forKey:@(idx)];
    [self refreshTableViewWith:idx];
}

- (void)refreshTableViewWith:(NSUInteger)idx {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
}

- (void)setCompletion:(NSDictionary *)completionDict {
    for (NSUInteger i = 1; i < 5; i++) {
        NSString * complete = [NSString stringWithFormat:@"%@",completionDict[[NSString stringWithFormat:@"%lu",i]]];
        [self refhresTableViewWith:(i - 1) WithComplete:complete];
    }
}

- (void)refhresTableViewWith:(NSUInteger)idx WithComplete:(NSString *)complete {
    NSMutableDictionary *mutableDict = [self.dataDict[@(idx)] mutableCopy];
    [mutableDict setObject:complete forKey:@"complete"];
    [self.dataDict setObject:mutableDict forKey:@(idx)];
    [self refreshTableViewWith:idx];
}

#pragma mark - getter
- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT * 0.34)];
        _headerView.image = [FFImageManager Mission_header];
    }
    return _headerView;
}


- (NSMutableDictionary *)dataDict {
    if (!_dataDict) {
        _dataDict = @{@0:@{@"title":@"签到",@"subTitle":@"签到+5金币,vip额外+66金币",
                           @"complete":@"0",@"image":[FFImageManager Mission_sign_in]},
                      @1:@{@"title":@"每日评论",@"subTitle":@"每日首次评论奖励3-10金币",
                           @"complete":@"0",@"image":[FFImageManager Mission_comment]},
                      @2:@{@"title":@"每日发车",@"subTitle":@"每日首次发车成功奖励5-30金币",
                           @"complete":@"0",@"image":[FFImageManager Mission_drive]},
                      @3:@{@"title":@"邀请好友",@"subTitle":@"邀请最高奖励2000金币/人",
                           @"complete":@"0",@"image":[FFImageManager Mission_invite]},
                      @4:@{@"title":@"排行榜",@"subTitle":@"最高奖励1000金币",
                           @"complete":@"3",@"image":[FFImageManager Mission_invite_list]},
                      @5:@{@"title":@"金币抽奖",@"subTitle":@"最高得到500金币",
                           @"complete":@"3",@"image":[FFImageManager Mission_gold_lottary]},
                      @6:@{@"title":@"金币兑换",@"subTitle":@"赶紧换平台币来玩游戏吧",
                           @"complete":@"3",@"image":[FFImageManager Mission_gold_exchange]},
                      @7:@{@"title":@"成为VIP",@"subTitle":@"成为VIP可以获得更多每日金币",
                           @"complete":@"3",@"image":[FFImageManager Mission_vip]}}.mutableCopy;
    }
    return _dataDict;
}








@end











