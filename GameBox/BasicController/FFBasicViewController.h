//
//  FFBasicViewController.h
//  GameBox
//
//  Created by 燚 on 2018/4/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>
#import <FFTools/FFTools.h>

typedef void(^EndOfNetWorkRequestBlock)(BOOL success);

@interface FFBasicViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

/** table view */
@property (nonatomic, strong) UITableView *tableView;
/** refresh header */
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
/** lord more footer */
@property (nonatomic, strong) MJRefreshBackFooter *refreshFooter;
/** show array */
@property (nonatomic, strong) NSMutableArray *showArray;
/** End of network request block */
@property (nonatomic, strong) EndOfNetWorkRequestBlock endOfNetWorkRequestBlock;

/** uinavigation left button  */
@property (nonatomic, strong) UIBarButtonItem *leftButton;
/** uinavigation rigth button */
@property (nonatomic, strong) UIBarButtonItem *rightButton;

/** initialize user interface */
- (void)initUserInterface;
/** initialize */
- (void)initDataSource;

/** refresh data */
- (void)refreshData;
/** load more data */
- (void)loadMoreData;

- (void)respondsToRightButton;
- (void)respondsToLeftButton;



@end





