//
//  FFCurrentGameModel.h
//  GameBox
//
//  Created by 燚 on 2018/5/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicModel.h"
#import <UIKit/UIKit.h>


#define CURRENT_GAME [FFCurrentGameModel CurrentGame]

typedef void(^RefreshCompleteBlock)(BOOL success);
typedef void(^CommentListBlock)(NSDictionary *content, BOOL success);
typedef void(^GameCompletionBlck)(NSDictionary *content, BOOL success);

typedef void(^GameActivityCallBackBlock)(NSDictionary *content, BOOL success);

typedef void(^CommentNumberBlock)(NSString *commentNumber);
typedef void(^GiftNumberBlock)   (NSString *giftNumber);
typedef void(^GuideNumberBlock)  (NSString *guideNumberBlock);

typedef void(^AccountTransaction)(void);

@interface FFCurrentGameModel : FFBasicModel

/** 游戏活动回调 */
@property (nonatomic, strong) GameActivityCallBackBlock activityCallBackBlock;

/** 请求 game ID*/
@property (nonatomic, strong) NSString *request_game_id;


/** 游戏 ID */
@property (nonatomic, strong) NSString *game_id;
/** 游戏包名 */
@property (nonatomic, strong) NSString *game_bundle_name;
/** 游戏名称 */
@property (nonatomic, strong) NSString *game_name;
/** 游戏大小*/
@property (nonatomic, strong) NSString *game_size;
/** 游戏标签 */
@property (nonatomic, strong) NSString *game_label;
/** 游戏标签数组 */
@property (nonatomic, strong) NSArray<NSString *> *game_label_array;
/** 游戏 logo */
@property (nonatomic, strong) UIImage *game_logo_image;
/** 游戏 logo url */
@property (nonatomic, strong) NSString *game_logo_url;
/** gif url */
@property (nonatomic, strong) NSString *gif_url;
/** gif */
@property (nonatomic, strong) id gif_image;
/** gif model */
@property (nonatomic, strong) NSString *gif_model;
/** image array */
@property (nonatomic, strong) NSArray *showImageArray;
/** 游戏简介 */
@property (nonatomic, strong) NSString *game_introduction;
/** 游戏短简介 */
@property (nonatomic, strong) NSString *game_short_introduction;
/** 游戏特征 */
@property (nonatomic, strong) NSString *game_feature;
/** vip 价格 */
@property (nonatomic, strong) NSString *game_vip_amount;
/** 充值返利 */
@property (nonatomic, strong) NSString *game_rebate;
/** 收藏 */
@property (nonatomic, strong) NSString *game_is_collection;
/** 下载地址 */
@property (nonatomic, strong) NSString *game_download_url;
/** 玩家 QQ 群 */
@property (nonatomic, strong) NSString *player_qq_group;
/** 评论数 */
@property (nonatomic, strong) NSString *game_comment_number;
/** 下载数 */
@property (nonatomic, strong) NSString *game_download_number;
/** 游戏评分 */
@property (nonatomic, strong) NSString *game_score;
/** game tag */
@property (nonatomic, strong) NSString *game_tag;
/** 游戏类型 */
@property (nonatomic, strong) NSString *game_type;
/** 游戏类型数组 */
@property (nonatomic, strong) NSArray *game_type_array;
/** 游戏版本 */
@property (nonatomic, strong) NSString *game_version;
/** 用户是否评分 */
@property (nonatomic, strong) NSString *player_is_score;

/** 游戏详情页面的 "猜你喜欢" 功能*/
@property (nonatomic, strong) NSArray *like;
/** 回调信息 */
@property (nonatomic, strong) NSString *call_back_message;
/** 折扣 */ 
@property (nonatomic, strong) NSString *game_discount;

/** 是否显示交易 */
@property (nonatomic, strong) NSString *transaction_switch;
/** 交易数量 */
@property (nonatomic, strong) NSString *transaction_number;
/** 游戏排名,前10返回真实排名,10名以后显示0 */
@property (nonatomic, strong) NSString *top_number;


/** 评论数 block */
@property (nonatomic, strong) CommentNumberBlock commentNumberBlock;
/** 礼包数 block */
@property (nonatomic, strong) GiftNumberBlock    giftNumberBlock;
/** 攻略数 block */
@property (nonatomic, strong) GuideNumberBlock   guideNumberBlock;

/** 显示交易界面 */
@property (nonatomic, strong) AccountTransaction accountTransaction;

/** 新属性(H5)属性 */
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *app_clientkey;
@property (nonatomic, strong) NSString *h5_url;





/** 游戏信息单例 */
+ (instancetype)CurrentGame;
/** 根据游戏 id 刷新游戏数据 */
+ (instancetype)refreshCurrentGameWithGameID:(NSString *)gameID Completion:(RefreshCompleteBlock)block;
/** 根据游戏模型刷新数据 */
+ (instancetype)refreshCurrentGameWithGameModel:(FFCurrentGameModel *)gameModel Completion:(RefreshCompleteBlock)block;


#pragma mark - comment
/** 获取评论的数目 */
- (void)getCommentNumber;
/**
 * 发送评论
 * @pamra   text 内容
 * @pamra   toUID 回复评论的用户 uid, 不是回复的填写空
 * @pamra   is_fage 如果服务器有这个参数就传
 * @pamra   is_gameID 是否是游戏评论.
 */
- (void)sendCommentWithText:(NSString *)text
                      ToUid:(NSString *)toUid
                    is_fake:(NSString *)is_fake
                   isGameID:(NSString *)is_gameID
                 Completion:(CommentListBlock)completion;
/**
 * 删除评论
 */
- (void)deleteCommentWithCommentID:(NSString *)commentId
                        Completion:(GameCompletionBlck)completion;
/**
 * 评论赞的接口
 */
- (void)likeCommentWithCommentID:(NSString *)commentid
                      Completion:(GameCompletionBlck)completion;
/** 取消赞 */
- (void)cancelLikeCommentWithCommentID:(NSString *)commentid
                                  Type:(NSString *)type
                            Completion:(GameCompletionBlck)completion;

/** 请求游戏活动 */
- (void)getGameActivity;


/** 评论获取金币 */
+ (void)writeCommentGetCoinComoletion:(void(^)(NSDictionary *  content, BOOL success))completion;

/** 请求是否可以评论 */
- (void)gameCanCommentCompletion:(GameCompletionBlck)completion;




@end









