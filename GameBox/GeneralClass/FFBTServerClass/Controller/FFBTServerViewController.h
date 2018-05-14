//
//  FFBTServerViewController.h
//  GameBox
//
//  Created by 燚 on 2018/5/10.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicTableViewController.h"
#import "FFServersModel.h"

@interface FFBTServerViewController : FFBasicTableViewController

@property (nonatomic, assign) FFGameServersType type;

@property (nonatomic, strong) NSArray *selectButtonArray;
@property (nonatomic, strong) NSArray *selectImageArray;

@end
