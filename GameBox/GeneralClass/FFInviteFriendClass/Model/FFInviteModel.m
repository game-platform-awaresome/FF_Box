//
//  FFInviteModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/29.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFInviteModel.h"
#import "FFMapModel.h"
#import "FFDeviceInfo.h"
#import "FFUserModel.h"


static FFInviteModel *model = nil;
@implementation FFInviteModel

+ (instancetype)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [FFInviteModel new];
        }
    });
    return model;
}


- (void)refreshList {
    [FFNetWorkManager postRequestWithURL:Map.RANKING_LIST Params:nil Completion:^(NSDictionary *content, BOOL success) {
        REQUEST_STATUS;
        NSDictionary *data = content[@"data"];
        if (success && status.integerValue == 1) {
            self.todayList = [NSArray arrayWithArray:data[@"today"]];
            self.yesterDayList = [NSArray arrayWithArray:data[@"yesterday"]];
            if (self.completion) {
                self.completion(YES, [self cheackGotWithArray:self.yesterDayList]);
            }
        } else {
            if (self.completion) {
                self.completion(NO,0);
            }
            self.todayList = nil;
            self.yesterDayList = nil;
        }
    }];
}

- (void)gotInviteReward {
    NSString *sign = BOX_SIGN(@{@"uid":CURRENT_USER.uid}, @[@"uid"]);
    [FFNetWorkManager postRequestWithURL:Map.RECEIVE_REWARD Params:@{@"uid":CURRENT_USER.uid,@"sign":sign} Completion:^(NSDictionary *content, BOOL success) {
        REQUEST_STATUS;
        syLog(@"invite reward === %@", content);
        if (success && status.integerValue == 1) {
            if (self.rewardBlock) {
                self.rewardBlock(YES);
                [self refreshList];
            }
        } else {
            if (self.rewardBlock) {
                self.rewardBlock(NO);
            }
        }
    }];
}

- (void)getUserRankingListWithType:(NSString *)type {
    NSString *sign = BOX_SIGN(@{@"uid":CURRENT_USER.uid}, @[@"uid"]);
    [FFNetWorkManager postRequestWithURL:Map.RECEIVE_REWARD Params:@{@"uid":CURRENT_USER.uid,@"sign":sign} Completion:^(NSDictionary *content, BOOL success) {
        REQUEST_STATUS;
        syLog(@"invite reward === %@", content);
        if (success && status.integerValue == 1) {
            if (self.rewardBlock) {
                self.rewardBlock(YES);
                [self refreshList];
            }
        } else {
            if (self.rewardBlock) {
                self.rewardBlock(NO);
            }
        }
    }];
}

- (First_list_enum)cheackGotWithArray:(NSArray *)array {
    for (NSDictionary *dict in array) {
        NSString *uid = [NSString stringWithFormat:@"%@",dict[@"uid"]];
        NSString *got = [NSString stringWithFormat:@"%@",dict[@"got"]];
        if ([uid isEqualToString:SSKEYCHAIN_UID] && [got isEqualToString:@"0"]) {
            return YesterdatFirst;
        }
    }
    return TodayFirst;
}


+ (void)getNoticeWithBlock:(FFInviewNotesCompleteBlock)completion {
    [FFNetWorkManager postRequestWithURL:Map.RANKNOTICE Params:nil Completion:^(NSDictionary *content, BOOL success) {
        if (completion) {
            completion(success,content);
        }
    }];
}


@end











