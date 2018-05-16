//
//  FFBasicScrollSelectController.h
//  GameBox
//
//  Created by 燚 on 2018/5/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicTableViewController.h"
#import "FFBasicSSTableViewCell.h"
#import <MJRefresh.h>
#import "FFStretchableTableHeaderView.h"

@interface FFBasicSSTableView : UITableView


@end


@interface FFBasicScrollSelectController : FFBasicViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) FFBasicSSTableView *tableView;

/** refresh header */
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
/** lord more footer */
@property (nonatomic, strong) MJRefreshBackFooter *refreshFooter;


//下拉头部放大控件
@property (strong, nonatomic) FFStretchableTableHeaderView *stretchableTableHeaderView;


@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *sectionView;


@property (nonatomic, strong) UIView *navigationView;


@property (nonatomic, strong) NSArray<FFBasicSSTableViewController *> *selectChildConttoller;





@end
