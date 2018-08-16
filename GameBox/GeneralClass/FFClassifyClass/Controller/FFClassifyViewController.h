//
//  FFClassifyViewController.h
//  GameBox
//
//  Created by 燚 on 2018/4/19.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicTableViewController.h"

@interface FFClassifyViewController : FFBasicTableViewController

@property (nonatomic, assign) FFGameServersType gameServersType;

@property (nonatomic, strong) NSString *topGameName;

@end
