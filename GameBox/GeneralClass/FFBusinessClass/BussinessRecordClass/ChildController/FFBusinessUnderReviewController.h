//
//  FFBusinessUnderReviewController.h
//  GameBox
//
//  Created by 燚 on 2018/6/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicTableViewController.h"
#import "FFBusinessModel.h"
#import <MJRefresh.h>

#define Reset_page (self.currentPage = 1)
#define New_page ([NSString stringWithFormat:@"%lu",self.currentPage])
#define Next_page ([NSString stringWithFormat:@"%lu",++self.currentPage])

@interface FFBusinessUnderReviewController : FFBasicViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *showArray;

/** refresh header */
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
/** lord more footer */
@property (nonatomic, strong) MJRefreshBackFooter *refreshFooter;
/** current page */
@property (nonatomic, assign) NSUInteger currentPage;




@property (nonatomic, assign) BOOL isBuy;
@property (nonatomic, assign) FFBusinessUserSellType type;




@end
