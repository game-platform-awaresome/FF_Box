//
//  FFMineViewModel.m
//  GameBox
//
//  Created by 燚 on 2018/5/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFMineViewModel.h"
#import "FFColorManager.h"
#import "FFDeviceInfo.h"

@implementation FFMineInfoModel


@end

@interface FFMineViewModel ()

/** 显示数组 */
@property (nonatomic, strong) NSMutableArray<NSArray *> *showArray;

@property (nonatomic, strong) NSDictionary *infoDict;

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *cellModelArray;


@end

@implementation FFMineViewModel


#pragma mark - instantype method
- (NSUInteger)sectionNumber {
    return self.showArray.count;
}

- (NSUInteger)itemNumberWithSection:(NSUInteger)section {
    return self.showArray[section].count;
}

- (NSDictionary *)cellInfoWithIndexpath:(NSIndexPath *)indexPath {
    return self.infoDict[self.showArray[indexPath.section][indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMineCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"NewMineCell"];
    }

    NSDictionary *dict = [self cellInfoWithIndexpath:indexPath];

    cell.textLabel.text = dict[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    if (indexPath.section == 0) {
        cell.detailTextLabel.text = @"";
    } else {
        if (dict[@"attributeString"]) {
            cell.detailTextLabel.attributedText = dict[@"attributeString"];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        } else {
            cell.detailTextLabel.text = dict[@"subTitle"];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (dict[@"subimage"]) {
        cell.imageView.image = [UIImage imageNamed:dict[@"subimage"]];
    } else {
        cell.imageView.image = nil;
        syLog(@"no image === T@%@",dict);
    }

    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, cell.frame.size.height - 1, kSCREEN_WIDTH, 1);
    layer.backgroundColor = [FFColorManager backgroundColor].CGColor;
    [cell.contentView.layer addSublayer:layer];
    return cell;
}

#pragma mark -  method
- (BOOL)is185 {
    return [Channel isEqualToString:@"185"];
}

#pragma mark - getter
- (NSMutableArray<NSArray *> *)showArray {
    if (!_showArray) {
        _showArray = \
        [self is185] ? \
        [@[@[@"FFResignViewController"],
        @[@"FFSignInViewController",@"FFEvervDayComment",@"FFDrivePostStatusViewController", @"FFInviteFriendViewController",@"FFInviteRankListViewController"],
        @[@"FFExchangeCoinController",@"FFLotteryViewController",@"FFGoldDetailViewController", @"FFPlatformDetailViewController"],
        @[@"FFRRebateViewController",@"FFTransferServerViewController"],
        @[@"FFMyPackageViewController",@"FFMyCollectionViewController",@"FFRActivityViewController"],
        @[@"FFMyNewsViewController",@"FFCustomerServiceViewController"],
        @[@"FFChangePasswordViewController",@"FFBindMobileViewController",@"FFAboutViewController"]] mutableCopy] :\
                                                      \
        [@[@[@"FFResignViewController"],
        @[@"FFSignInViewController",@"FFEvervDayComment",@"FFDrivePostStatusViewController", @"FFInviteFriendViewController"],
        @[@"FFExchangeCoinController",@"FFLotteryViewController",@"FFGoldDetailViewController", @"FFPlatformDetailViewController"],
        @[@"FFRRebateViewController",@"FFTransferServerViewController"],
        @[@"FFMyPackageViewController",@"FFMyCollectionViewController",@"FFRActivityViewController"],
        @[@"FFMyNewsViewController",@"FFCustomerServiceViewController"],
        @[@"FFChangePasswordViewController",@"FFBindMobileViewController"]] mutableCopy];
    }
    return _showArray;
}

- (NSMutableArray<NSMutableArray *> *)cellModelArray {
    if (!_cellModelArray) {
        _cellModelArray = [NSMutableArray arrayWithCapacity:self.showArray.count];
        for (NSArray *array in self.showArray) {
            NSMutableArray *add1Array = [NSMutableArray arrayWithCapacity:array.count];
            for (NSString *string in array) {
                NSDictionary *dict = self.infoDict[string];
                FFMineInfoModel *model = [[FFMineInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [add1Array addObject:model];
            }
            [_cellModelArray addObject:add1Array];
        }
    }
    return _cellModelArray;
}



- (NSDictionary *)infoDict {
    if (!_infoDict) {
        _infoDict = [@{@"FFResignViewController":       @{@"title":@"闪退修复",
                                                          @"subimage":@"Mine_subimage_Fix"},

                       @"FFSignInViewController":       @{@"title":@"签到",@"subTitle":@"+5金币,坚持有惊喜",
                                                          @"subimage":@"Mine_subimage_sign"},
                       @"FFEvervDayComment":             @{@"title":@"每日评论",@"subTitle":@"+3到10金币,每日一次",
                                                           @"subimage":@"Mine_subimage_comment"},
                       @"FFDrivePostStatusViewController":@{@"title":@"每日发车",@"subTitle":@"每次成功发车可获得5-30金币",
                                                            @"subimage":@"Mine_subimage_Post_Status"},
                       @"FFInviteFriendViewController":  @{@"title":@"邀请好友",@"subTitle":@"最高奖励2000金币/人",
                                                           @"subimage":@"Mine_subimage_invite"},
                       @"FFInviteRankListViewController":@{@"title":@"邀请排行榜",@"subTitle":@"",
                                                           @"subimage":@"Mine_subimage_invite"},

                       @"FFExchangeCoinController":      @{@"title":@"金币兑换",
                                                           @"subimage":@"Mine_subimage_changecoin"},
                       @"FFLotteryViewController":       @{@"title":@"金币抽奖",
                                                           @"subimage":@"Mine_subimage_lottery"},
                       @"FFGoldDetailViewController":    @{@"title":@"金币明细",
                                                           @"subimage":@"Mine_subimage_coindetail"},
                       @"FFPlatformDetailViewController":@{@"title":@"平台币明细",@"subTitle":@"平台币可在游戏中消费",
                                                           @"subimage":@"Mine_subimage_coindetail"},

                       @"FFRRebateViewController":       @{@"title":@"返利申请",@"subTitle":@"充值有奖,元宝/钻石返还",
                                                           @"subimage":@"Mine_subimage_rebateapply"},
                       @"FFTransferServerViewController":@{@"title":@"转游申请",
                                                           @"subimage":@"Mine_subimage_transfergame"},

                       @"FFMyPackageViewController":     @{@"title":@"我的礼包",
                                                           @"subimage":@"Mine_subimage_mypackage",},
                       @"FFMyCollectionViewController":  @{@"title":@"我的收藏",
                                                           @"subimage":@"Mine_subimage_mycollection"},
                       @"FFRActivityViewController":     @{@"title":@"活动中心",
                                                           @"subimage":@"Mine_subimage_activity"},

                       @"FFMyNewsViewController":        @{@"title":@"我的消息",
                                                           @"subimage":@"Mine_subimage_mynews"},
                       @"FFCustomerServiceViewController":@{@"title":@"客服中心",@"subTitle":@"寻求帮助,问题反馈",@"subimage":@"Mine_subimage_customercenter"},

                       @"FFChangePasswordViewController":@{@"title":@"修改密码",
                                                           @"subimage":@"Mine_subimage_changepassword"},
                       @"FFBindMobileViewController":    @{@"title":@"绑定手机",
                                                           @"subimage":@"Mine_subimage_bindinphone"},
                       @"FFAboutViewController":         @{@"title":@"关于我们",
                                                           @"subimage":@"Mine_subimage_aboutus"},

                       @"FFUnBindMobileViewController":   @{@"title":@"解绑手机",
                                                            @"subimage":@"Mine_subimage_bindinphone"},

                       } mutableCopy];
    }
    return _infoDict;
}



@end

