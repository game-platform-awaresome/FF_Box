//
//  FFRebateModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/15.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRebateModel.h"
#import "FFMapModel.h"
#import "SYKeychain.h"
#import "FFDeviceInfo.h"

@implementation FFRebateModel

/** 返利滚动标题 */
+ (void)rebateScrollTitleWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    [FFNetWorkManager postRequestWithURL:[FFMapModel map].REBATE_NOTICE Params:nil Completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 可以返利列表 */
+ (void)applyRebateListWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    NSArray *array = @[@"uid"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //渠道ID
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    //设备ID
    [dict setObject:BOX_SIGN(dict, array) forKey:@"sign"];
    [FFNetWorkManager postRequestWithURL:[FFMapModel map].REBATE_INFO Params:dict Completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 返利记录 */
- (void)loadNewRebateRecordWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    self.currentPage = 1;
    [self rebateRecordWithPage:[NSString stringWithFormat:@"%ld",self.currentPage] Completion:completion];
}

- (void)loadMoreRebateRecordWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    self.currentPage++;
    [self rebateRecordWithPage:[NSString stringWithFormat:@"%ld",self.currentPage] Completion:completion];
}

- (void)rebateRecordWithPage:(NSString *)page
                  Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {

    NSArray *array = @[@"uid",@"page"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:page forKey:@"page"];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:BOX_SIGN(dict, array) forKey:@"sign"];

    [FFNetWorkManager postRequestWithURL:[FFMapModel map].REBATE_RECORD Params:dict Completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 返利须知 */
+ (void)rebateNoticeWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    [FFNetWorkManager postRequestWithURL:[FFMapModel map].REBATE_KNOW Params:nil Completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 申请返利 */
+ (void)rebateApplyWithAppID:(NSString *)appid RoleName:(NSString *)rolename RoleID:(NSString *)roleid ServerID:(NSString *)serverID Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:appid forKey:@"appid"];
    [dict setObject:rolename forKey:@"rolename"];
    [dict setObject:roleid forKey:@"roleid"];
    [dict setObject:serverID forKey:@"serverID"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"appid",@"rolename",@"roleid",@"serverID"])) forKey:@"sign"];

    [FFNetWorkManager postRequestWithURL:[FFMapModel map].REBATE_APPLY Params:dict Completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];


}


@end
