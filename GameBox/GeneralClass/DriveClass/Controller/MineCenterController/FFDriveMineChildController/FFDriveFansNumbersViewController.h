//
//  FFDriveFansNumbersViewController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/29.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFMineBaseTableViewController.h"
#import "FFDriveModel.h"

@interface FFDriveFansNumbersViewController : FFMineBaseTableViewController


@property (nonatomic, strong) NSMutableArray *showArray;
@property (nonatomic, assign) FansOrAttention type;
@property (nonatomic, strong) NSString *buid;

- (void)refreshNewData;

@end



