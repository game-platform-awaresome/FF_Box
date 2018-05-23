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
#import "FFImageManager.h"
#import "FFUserModel.h"
#import <FFTools/FFTools.h>

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
        cell.imageView.image = dict[@"subimage"];
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

- (id)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *urlStrig = [NSString stringWithFormat:@"https://ipa.185sy.com/ios/fix/ios_app_%@.mobileconfig",Channel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStrig]];
        return nil;
    } else {
        if (!CURRENT_USER.isLogin) {
            [UIAlertController showAlertMessage:@"尚未登录" dismissTime:0.7 dismissBlock:nil];
            return nil;
        }
        Class pushClass = NSClassFromString(self.showArray[indexPath.section][indexPath.row]);
        if (pushClass) {
            id vc = [[pushClass alloc] init];
            if (vc) {
                return vc;
            } else {
                syLog(@"%s error vc  -> %@",__func__,self.showArray[indexPath.section][indexPath.row]);
                return nil;
            }
        }
        syLog(@"%s error name -> %@",__func__,self.showArray[indexPath.section][indexPath.row]);
        return nil;
    }
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
                                                          @"subimage":[FFImageManager Mine_flash_back]},

                       @"FFSignInViewController":       @{@"title":@"签到",@"subTitle":@"+5金币,坚持有惊喜",
                                                          @"subimage":[FFImageManager Mine_sign_in]},
                       @"FFEvervDayComment":             @{@"title":@"每日评论",@"subTitle":@"+3到10金币,每日一次",
                                                           @"subimage":[FFImageManager Mine_everyday_comment]},
                       @"FFDrivePostStatusViewController":@{@"title":@"每日发车",@"subTitle":@"每次成功发车可获得5-30金币",
                                                            @"subimage":[FFImageManager Mine_everyday_drive]},
                       @"FFInviteFriendViewController":  @{@"title":@"邀请好友",@"subTitle":@"最高奖励2000金币/人",
                                                           @"subimage":[FFImageManager Mine_invite_firend]},
                       @"FFInviteRankListViewController":@{@"title":@"邀请排行榜",@"subTitle":@"",
                                                           @"subimage":[FFImageManager Mine_invite_list]},

                       @"FFExchangeCoinController":      @{@"title":@"金币兑换",
                                                           @"subimage":[FFImageManager Mine_gold_exchange]},
                       @"FFLotteryViewController":       @{@"title":@"金币抽奖",
                                                           @"subimage":[FFImageManager Mine_gold_lottery]},
                       @"FFGoldDetailViewController":    @{@"title":@"金币明细",
                                                           @"subimage":[FFImageManager Mine_gold_list]},
                       @"FFPlatformDetailViewController":@{@"title":@"平台币明细",@"subTitle":@"平台币可在游戏中消费",
                                                           @"subimage":[FFImageManager Mine_platform_list]},

                       @"FFRRebateViewController":       @{@"title":@"返利申请",@"subTitle":@"充值有奖,元宝/钻石返还",
                                                           @"subimage":[FFImageManager Mine_rebate_apply]},
                       @"FFTransferServerViewController":@{@"title":@"转游申请",
                                                           @"subimage":[FFImageManager Mine_transfer_game]},

                       @"FFMyPackageViewController":     @{@"title":@"我的礼包",
                                                           @"subimage":[FFImageManager MIne_package],},
                       @"FFMyCollectionViewController":  @{@"title":@"我的收藏",
                                                           @"subimage":[FFImageManager Mine_collection]},
                       @"FFRActivityViewController":     @{@"title":@"活动中心",
                                                           @"subimage":[FFImageManager Mine_activiity_center]},

                       @"FFMyNewsViewController":        @{@"title":@"我的消息",
                                                           @"subimage":[FFImageManager Mine_message]},
                       @"FFCustomerServiceViewController":@{@"title":@"客服中心", @"subTitle":@"寻求帮助,问题反馈",
                                                            @"subimage":[FFImageManager Mine_customer_service]},

                       @"FFChangePasswordViewController":@{@"title":@"修改密码",
                                                           @"subimage":[FFImageManager Mine_modify_password]},
                       @"FFBindMobileViewController":    @{@"title":@"绑定手机",
                                                           @"subimage":[FFImageManager Mine_binding_phone]},
                       @"FFAboutViewController":         @{@"title":@"关于我们",
                                                           @"subimage":[FFImageManager Mine_about_us]},

                       @"FFUnBindMobileViewController":   @{@"title":@"解绑手机",
                                                            @"subimage":[FFImageManager Mine_binding_phone]},

                       } mutableCopy];
    }
    return _infoDict;
}



@end

