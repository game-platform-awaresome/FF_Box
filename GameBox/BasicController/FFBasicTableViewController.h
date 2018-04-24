//
//  FFBasicViewController.h
//  GameBox
//
//  Created by 燚 on 2018/4/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicViewController.h"
#import <MJRefresh.h>

#define BOX_REGISTER_CELL [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE]

@interface FFBasicTableViewController : FFBasicViewController <UITableViewDataSource, UITableViewDelegate>

/** table view */
@property (nonatomic, strong) UITableView *tableView;
/** refresh header */
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
/** lord more footer */
@property (nonatomic, strong) MJRefreshBackFooter *refreshFooter;
/** show array */
@property (nonatomic, strong) NSMutableArray *showArray;



@end





