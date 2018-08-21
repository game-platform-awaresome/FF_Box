//
//  FFRankListViewController.h
//  GameBox
//
//  Created by 燚 on 2018/4/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicTableViewController.h"

@interface FFRankListViewController : FFBasicTableViewController


- (void)setGameType:(NSString *)gameType;

@property (nonatomic, assign) FFGameServersType gameServerType;


@end
