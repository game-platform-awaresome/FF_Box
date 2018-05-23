//
//  FFMyNewsModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/23.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMyNewsModel.h"
#import "FFMapModel.h"
#import "SYKeychain.h"
#import "FFDeviceInfo.h"

@implementation FFMyNewsModel


+ (void)getUserNewsWithPage:(NSString *)page CompleteBlock:(FFCompleteBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:@"2" forKey:@"comment_type"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"comment_type",@"channel",@"page"])) forKey:@"sign"];

    [FFNetWorkManager postRequestWithURL:[FFMapModel map].COMMENT_REPLY_LIST  Params:dict Completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];

}





/** 消息列表 */
+ (void)systemInfoListWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel"])) forKey:@"sign"];

    [FFNetWorkManager postRequestWithURL:[FFMapModel map].MESSAGE_LIST  Params:dict Completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 消息详情 */
+ (void)messageDetailWithMessageID:(NSString *)user_message_id Completion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:user_message_id forKey:@"user_message_id"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel",@"user_message_id"])) forKey:@"sign"];

    [FFNetWorkManager postRequestWithURL:[FFMapModel map].MESSAGE_INFO  Params:dict Completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}


/** 领取奖励 */
+ (void)receiveAwardWithMessAgeId:(NSString *)user_message_id WithUrl:(NSString *)url Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:user_message_id forKey:@"user_message_id"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel",@"user_message_id"])) forKey:@"sign"];

    [FFNetWorkManager postRequestWithURL:url Params:dict Completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

+ (void)deleteMessageWithMessageID:(NSString *)user_message_id Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:user_message_id forKey:@"user_message_id"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel",@"user_message_id"])) forKey:@"sign"];

    [FFNetWorkManager postRequestWithURL:[FFMapModel map].MESSAGE_DELETE  Params:dict Completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}



@end
















