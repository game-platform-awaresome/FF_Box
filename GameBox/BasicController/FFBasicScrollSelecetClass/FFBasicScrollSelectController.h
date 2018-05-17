//
//  FFBasicScrollSelectController.h
//  GameBox
//
//  Created by 燚 on 2018/5/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicTableViewController.h"
#import "FFBasicSSTableViewCell.h"
#import "FFBasicSSSelectView.h"
#import <MJRefresh.h>

@interface FFBasicSSTableView : UITableView


@end


@interface FFBasicScrollSelectController : FFBasicViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) FFBasicSSTableView *tableView;

/** refresh header */
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
/** lord more footer */
@property (nonatomic, strong) MJRefreshBackFooter *refreshFooter;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *sectionView;


@property (nonatomic, strong) UIView *navigationView;

@property (nonatomic, strong) NSArray<FFBasicSSTableViewController *> *selectChildConttoller;


@property (nonatomic, strong) FFBasicSSSelectView *selectView;


@property (nonatomic, assign) BOOL canRestView;

- (void)showNavigationTitle;
- (void)hideNavigationTitle;







@end









