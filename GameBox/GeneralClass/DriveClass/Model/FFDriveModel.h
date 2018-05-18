//
//  FFDriveModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/8.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFBasicModel.h"

typedef enum : NSUInteger {
    hotDynamic = 1,
    allDynamic,
    throughDynamic,
    attentionDynamic,
    CheckUserDynamic
} DynamicType;

typedef enum : NSUInteger {
    dislike = 0,
    like
} LikeOrDislike;

typedef enum : NSUInteger {
    timeType = 1,
    hotType
} CommentType;

typedef enum : NSUInteger {
    attention = 1,
    cancel
} AttentionType;

typedef enum : NSUInteger {
    myAttention = 1,
    myFans
} FansOrAttention;

typedef enum : NSUInteger {
    fieldSimple = 1,
    fieldDetail
} FieldType;

typedef enum : NSUInteger {
    newComments = 1,
    newLikeOfComment,
    newLikeofDynamic,
} MyNewsType;

typedef void (^FFCompleteBlock)(NSDictionary *content, BOOL success);



@interface FFDriveModel : FFBasicModel

/** 发状态 */
//+ (void)postDynamicWith:(NSString *)content Images:(NSArray *)imgs Complete:(CompleteBlock)completion;


/** get dynamic */
+ (void)getDynamicWithType:(DynamicType)type Page:(NSString *)page CheckUid:(NSString *)buid Complete:(FFCompleteBlock)completion;


/** 发布动态 */
+ (void)userUploadPortraitWithContent:(NSString *)content
                                Image:(NSArray *)images
                           Completion:(FFCompleteBlock)completion;

/** 删除动态 */
+ (void)userDeletePortraitWithDynamicsID:(NSString *)dynamicsID
                              Completion:(FFCompleteBlock)completion;


/** 赞或者踩动态 */
+ (void)userLikeOrDislikeWithDynamicsID:(NSString *)dynamics_id
                                   type:(LikeOrDislike)type
                               Complete:(FFCompleteBlock)completion;

/** 取消动态赞或者踩 */
+ (void)userCancelLikeOrDislikeWithDynamicsID:(NSString *)dynamics_id
                                         type:(LikeOrDislike)type
                                     Complete:(FFCompleteBlock)completion;

/** 请求评论(请求动态详情) */
+ (void)userComeentListWithDynamicsID:(NSString *)dynamicsID
                                 type:(CommentType)type
                                 page:(NSString *)page
                             Complete:(FFCompleteBlock)completion;

/** 发送评论 */
+ (void)userSendCommentWithjDynamicsID:(NSString *)dynamicsID
                                 ToUid:(NSString *)toUid
                               Comment:(NSString *)comment
                              Complete:(FFCompleteBlock)completion;

/** 赞或者踩评论 */
+ (void)userLikeOrDislikeComment:(NSString *)comment_id
                            Type:(LikeOrDislike)type
                        Complete:(FFCompleteBlock)completion;

/** 取消评论的赞 */ 
+ (void)userCancelLikeOrDislikeComment:(NSString *)comment_id
                                  Type:(LikeOrDislike)type
                              Complete:(FFCompleteBlock)completion;

/** 删除评论 */
+ (void)userDeleteCommentWith:(NSString *)comment_id
                     Complete:(FFCompleteBlock)completion;

/** 关注用户 */
+ (void)userAttentionWith:(NSString *)attentionUid
                     Type:(AttentionType)type
                 Complete:(FFCompleteBlock)completion;

/** 分享动态 */
+ (void)userSharedDynamics:(NSString *)Dynamics
                  Complete:(FFCompleteBlock)completion;

/** 关注 / 粉丝*/
+ (void)userFansAndAttettionWithUid:(NSString *)uid
                               Page:(NSString *)page
                               Type:(FansOrAttention)type
                           Complete:(FFCompleteBlock)completion;

/** 用户信息 */
+ (void)userInfomationWithUid:(NSString *)uid
                    fieldType:(FieldType)type
                     Complete:(FFCompleteBlock)completion;

/** 编辑用户信息 */
+ (void)userEditInfoMationWithNickName:(NSString *)nick_name
                                   sex:(NSString *)sex
                               address:(NSString *)address
                                  desc:(NSString *)desc
                                 birth:(NSString *)birth
                                    qq:(NSString *)qq
                                 email:(NSString *)email
                              Complete:(FFCompleteBlock)completion;

+ (void)userEditInfoMationWIthDict:(NSDictionary *)dict
                          Complete:(FFCompleteBlock)completion;


/** 我的新消息数量 */
+ (void)myNewNumbersComplete:(FFCompleteBlock)completion;

/** 我的消息 */
+ (void)myNewsWithType:(MyNewsType)type
                  page:(NSString *)page
              Complete:(FFCompleteBlock)completion;





@end













