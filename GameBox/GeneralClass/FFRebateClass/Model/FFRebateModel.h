//
//  FFRebateModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/15.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicModel.h"

@interface FFRebateModel : FFBasicModel

/** 返利滚动信息 */
+ (void)rebateScrollTitleWithCompletion:(void (^)(NSDictionary *content, BOOL success))completion;

/** 可以返利列表 */
+ (void)applyRebateListWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 返利记录 */
- (void)loadNewRebateRecordWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

 /** 更多返利记录 */
- (void)loadMoreRebateRecordWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 返利须知 */
+ (void)rebateNoticeWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 申请返利 */
+ (void)rebateApplyWithAppID:(NSString *)appid
                    RoleName:(NSString *)rolename
                      RoleID:(NSString *)roleid
                    ServerID:(NSString *)serverID
                  Completion:(void (^)(NSDictionary * content, BOOL success))completion;


@end
