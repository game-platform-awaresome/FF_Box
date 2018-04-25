//
//  FFGameModel.h
//  GameBox
//
//  Created by 燚 on 2018/4/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFNetWorkManager.h"

@interface FFGameModel : FFNetWorkManager

/** recomment game list */
+ (void)recommentGameListWithPage:(NSString * _Nonnull)page Completion:(RequestCallBackBlock _Nullable)completion;

//=======================================================================================//
/** game list with type */
+ (void)gameListWithPage:(NSString * _Nonnull)page GameType:(NSString * _Nonnull)gameType Completion:(RequestCallBackBlock _Nullable)completion;
/** new game list */
+ (void)newGameListWithPage:(NSString * _Nonnull)page Completion:(RequestCallBackBlock _Nullable)completion;
/** rank game list */
+ (void)rankGameListWithPage:(NSString * _Nonnull)page Completion:(RequestCallBackBlock _Nullable)completion;

//=======================================================================================//
/** game guide list */
+ (void)gameGuideListWithPage:(NSString * _Nonnull)page Completion:(RequestCallBackBlock _Nullable)completion;







@end
