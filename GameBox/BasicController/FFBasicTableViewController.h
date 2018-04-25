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
#define New_page ([NSString stringWithFormat:@"%lu",self.currentPage])
#define Next_page ([NSString stringWithFormat:@"%lu",++self.currentPage])

@interface FFBasicTableViewController : FFBasicViewController <UITableViewDataSource, UITableViewDelegate>

/** table view */
@property (nonatomic, strong) UITableView *tableView;
/** refresh header */
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
/** lord more footer */
@property (nonatomic, strong) MJRefreshBackFooter *refreshFooter;
/** show array */
@property (nonatomic, strong) NSMutableArray *showArray;
/** current page */
@property (nonatomic, assign) NSUInteger currentPage;

- (void)begainRefresData;


@end





