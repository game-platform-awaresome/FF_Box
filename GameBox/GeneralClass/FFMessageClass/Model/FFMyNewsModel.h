//
//  FFMyNewsModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/23.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FFCompleteBlock)(NSDictionary *content, BOOL success);

@interface FFMyNewsModel : NSObject

/** 获取用户最新回复 */ 
+ (void)getUserNewsWithPage:(NSString *)page
              CompleteBlock:(FFCompleteBlock)completion;


/** 消息列表 */
+ (void)systemInfoListWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 消息详情 */
+ (void)messageDetailWithMessageID:(NSString *)user_message_id Completion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 领取奖励 */
+ (void)receiveAwardWithMessAgeId:(NSString *)user_message_id WithUrl:(NSString *)url Completion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 删除消息 */
+ (void)deleteMessageWithMessageID:(NSString *)user_message_id Completion:(void (^)(NSDictionary * content, BOOL success))completion;



@end








