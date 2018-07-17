//
//  FFGameModel.h
//  GameBox
//
//  Created by 燚 on 2018/4/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFNetWorkManager.h"


typedef enum : NSUInteger {
    BT_SERVERS = 1,
    ZK_SERVERS,
    H5_SERVERS
} FFGameServersType;

typedef enum : NSUInteger {
    FFOpenServerTypeToday = 1,
    FFOpenServerTypeTomorrow,
    FFOpenServerTypeAlready
} FFOpenServerType;


typedef enum : NSUInteger {
    FFCollectionTypeCollection = 1,
    FFCollectionTypeCancel
} FFCollectionType;

typedef enum : NSUInteger {
    FFGuide = 2,
    FFActivity = 3
} FFActivityType;

typedef enum : NSUInteger {
    FFBetaGame = 1,
    FFReservation
} FFBetaOrReservationType;

#pragma mark - game model
@interface FFGameModel : FFNetWorkManager


/** 旧主页游戏列表接口 */
+ (void)recommentGameListWithPage:(NSString * _Nonnull)page
                       Completion:(RequestCallBackBlock _Nullable)completion;

#pragma mark - game servers
/**
 * 主页的游戏服列表
 * @parma type 服务器类型;
 * @parma page 页数.起始页为1;
 */
+ (void)GameServersWithType:(FFGameServersType)serverType
                       Page:(NSString * _Nonnull)page
                 Completion:(RequestCallBackBlock _Nullable)completion;

#pragma mark - game list with type (新游/热门/排行)
/**
 * 游戏列表
 * @parma serverType    服务器类型;
 * @parma page          页数.起始页为1;
 */
+ (void)gameListWithPage:(NSString * _Nonnull)page
              ServerType:(FFGameServersType)serverType
                GameType:(NSString * _Nonnull)gameType
              Completion:(RequestCallBackBlock _Nullable)completion;
/**
 * 新游列表
 * @parma serverType    服务器类型;
 * @parma page          页数.起始页为1;
 */
+ (void)newGameListWithPage:(NSString * _Nonnull)page
                 ServerType:(FFGameServersType)serverType
                 Completion:(RequestCallBackBlock _Nullable)completion;
/**
 * 排行榜
 * @parma serverType    服务器类型;
 * @parma page          页数.起始页为1;
 */
+ (void)rankGameListWithPage:(NSString * _Nonnull)page
                  ServerType:(FFGameServersType)serverType
                  Completion:(RequestCallBackBlock _Nullable)completion;

#pragma makr - bate and reservation (内测和预约游戏)
+ (void)betaAndReservationGameWithPage:(NSString * _Nonnull)page
                                  Type:(FFBetaOrReservationType)type
                            Completion:(RequestCallBackBlock _Nullable)completion;

#pragma mark - open servers
/**
 * 开服表
 * @parma page          页数.起始页为1;
 * @parma serverType    服务器类型;
 * @parma openType      开服的时间
 */
+ (void)openServersListWithPage:(NSString * _Nonnull)page
                     ServerType:(FFGameServersType)serverType
                       OpenType:(FFOpenServerType)openType
                     Completion:(RequestCallBackBlock _Nullable)completion;
/**
 * BT 服开服表
 * @parma page          页数.起始页为1;
 * @parma openType      开服的时间
 */
+ (void)BTopenServersListWithPage:(NSString * _Nonnull)page
                         OpenType:(FFOpenServerType)openType
                       Completion:(RequestCallBackBlock _Nullable)completion;
/**
 * 折扣 服开服表
 * @parma page          页数.起始页为1;
 * @parma openType      开服的时间
 */
+ (void)ZKopenServersListWithPage:(NSString * _Nonnull)page
                         OpenType:(FFOpenServerType)openType
                       Completion:(RequestCallBackBlock _Nullable)completion;
/**
 * 单一游戏开服列表
 */
+ (void)openServersWithGameID:(NSString * _Nonnull)gameID
                   Completion:(RequestCallBackBlock _Nullable)completion;

#pragma mark - Game details infomation
/**
 * 游戏详情
 * @parma gameID        游戏 ID
 */
+ (void)gameDetailsWithGameID:(NSString * _Nonnull)gameID
                   Completion:(RequestCallBackBlock _Nullable)completion;

#pragma mark - collection game
/**
 * 游戏收藏
 * @parma gameID        游戏 ID
 */
+ (void)collectionGameWithGameID:(NSString * _Nonnull)gameID
                  CollectionType:(FFCollectionType)collectionType
                      Completion:(RequestCallBackBlock _Nullable)completion;

#pragma mark - game classify
/**
 * 游戏分类
 * @parma page          页数.起始页为1;
 * @parma serverType    服务器类型
 */
+ (void)gameClassifyListWithPage:(NSString * _Nonnull)page
                      ServerType:(FFGameServersType)serverType
                      Completion:(RequestCallBackBlock _Nullable)completion;
/**
 * 单个游戏分类详情
 * @parma classifyID    分类 ID;
 * @parma serverType    服务器类型
 * @parma page          页数.起始页为1;
 */
+ (void)gameclassifyWithClassifyID:(NSString * _Nonnull)classifyID
                              Page:(NSString * _Nonnull)page
                        ServerType:(FFGameServersType)serverType
                        Completion:(RequestCallBackBlock _Nullable)completion;

#pragma mark - get channel download game url
/**
 * 获取子渠道下载地址
 * @parma gameTag        游戏的 TAG 标签
 */
+ (void)getGameDownloadUrlWithTag:(NSString * _Nonnull)gameTag
                       Completion:(RequestCallBackBlock _Nullable)completion;

#pragma mark - game guide and activity list
/**
 * 游戏攻略或者活动
 * @parma page          页数,起始页为1
 * @parma serverType    服务器类型
 * @parma type          活动或者攻略
 */
+ (void)gameGuideAndActivityWithPage:(NSString * _Nonnull)page
                          ServerType:(FFGameServersType)serverType
                                Type:(FFActivityType)type
                          Completion:(RequestCallBackBlock _Nullable)completion;
/**
 * 游戏攻略
 */
+ (void)gameGuideListWithPage:(NSString * _Nonnull)page
                   ServerType:(FFGameServersType)serverType
                   Completion:(RequestCallBackBlock _Nullable)completion;
/**
 * 游戏活动
 */
+ (void)gameActivityWithPage:(NSString * _Nonnull)page
                  ServerType:(FFGameServersType)serverType
                  Completion:(RequestCallBackBlock _Nullable)completion;
/**
 * 单一游戏攻略
 */
+ (void)gameGuideWithGameID:(NSString * _Nonnull)gameID
                 Completion:(RequestCallBackBlock _Nullable)completion;
/**
 * 单一游戏活动
 */
+ (void)gameActivityWithGameID:(NSString * _Nonnull)gameID
                    Completion:(RequestCallBackBlock _Nullable)completion;


#pragma mark - game gift (游戏礼包)
/**
 * 根据游戏 id 获取游戏礼包列表
 */
+ (void)gameGiftWithGameID:(NSString * _Nonnull)gameID
                Completion:(RequestCallBackBlock _Nullable)completion;
/**
 * 根据 礼包 id 获取礼包
 */
+ (void)getGameGiftWithPackageID:(NSString * _Nonnull)packageID
                      Completion:(RequestCallBackBlock _Nullable)completion;
/**
 * 我的礼包
 */
+ (void)getUserGiftPackageWithPage:(NSString * _Nonnull)page
                        Completion:(RequestCallBackBlock _Nullable)completion;

#pragma mark - get game comment list
/**
 * 游戏评论列表
 */
+ (void)gameCommentListWithGameID:(NSString * _Nonnull)gameID
                             Page:(NSString * _Nonnull)page
                       Completion:(RequestCallBackBlock _Nullable)completion;

#pragma mark - mission center
/**
 * 任务中心
 */
+ (void)missionCenterInfoCompletion:(RequestCallBackBlock _Nullable)completion;

#pragma mark - promise
/** 185游戏承诺 */
+ (void)gamePromiseCompletion:(RequestCallBackBlock _Nullable)completion;

#pragma mark -
/** 新游预约 */
+ (void)reservaGameWithGameID:(NSString * _Nullable)gameID
                   Completion:(RequestCallBackBlock _Nullable)completion;



@end











