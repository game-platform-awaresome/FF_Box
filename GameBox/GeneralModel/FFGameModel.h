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
    ZK_SERVERS
} FFGameServersType;



#pragma mark - game model
@interface FFGameModel : FFNetWorkManager


/** recomment game list */
+ (void)recommentGameListWithPage:(NSString * _Nonnull)page
                       Completion:(RequestCallBackBlock _Nullable)completion;

//=======================================================================================//
/** game list with type */
+ (void)gameListWithPage:(NSString * _Nonnull)page
                GameType:(NSString * _Nonnull)gameType
              Completion:(RequestCallBackBlock _Nullable)completion;
/** new game list */
+ (void)newGameListWithPage:(NSString * _Nonnull)page
                 Completion:(RequestCallBackBlock _Nullable)completion;
/** rank game list */
+ (void)rankGameListWithPage:(NSString * _Nonnull)page
                  Completion:(RequestCallBackBlock _Nullable)completion;

//=======================================================================================//
/** game guide list */
+ (void)gameGuideListWithPage:(NSString * _Nonnull)page
                   Completion:(RequestCallBackBlock _Nullable)completion;

//=======================================================================================//
/** classify game list */
+ (void)classifyGameListWithPage:(NSString * _Nonnull)page
                      Completion:(RequestCallBackBlock _Nullable)completion;
/** classify with id */
+ (void)classifyWithID:(NSString *_Nonnull)classifyID
                  Page:(NSString *_Nonnull)page
            Completion:(RequestCallBackBlock _Nullable)completion;


#pragma mark - game servers
/**
 * 主页的游戏服列表
 * @parma type 服务器类型;
 * @parma page 页数.起始页为1;
 */
+ (void)GameServersWithType:(FFGameServersType)type
                       Page:(NSString * _Nonnull )page
                 Completion:(RequestCallBackBlock _Nullable)completion;








@end











