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
+ (void)recommentGameListWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion;
/** new game list */
+ (void)newGameListWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion;


@end
