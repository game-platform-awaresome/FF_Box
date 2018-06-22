//
//  FFBusinessUnderReviewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessUnderReviewController.h"
#import "FFBusinessSellRecordCell.h"
#import "FFBusinessProductController.h"
#import "FFBusinessSellProductController.h"

#define CELL_IDE @"FFBusinessSellRecordCell"

@interface FFBusinessUnderReviewController ()<FFBusinessSellRecordCellDelegate,UITableViewDelegate, UITableViewDataSource>




@end

@implementation FFBusinessUnderReviewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.refreshHeader beginRefreshing];
}

- (void)initDataSource {
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
}


- (void)initUserInterface {
    [super initUserInterface];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}


- (void)refreshData {
    Reset_page;
    [self startWaiting];
    [FFBusinessModel userSellRecordWithPage:New_page Type:self.type Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            NSArray *array = CONTENT_DATA[@"list"];
            self.showArray = array.mutableCopy;
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
        syLog(@"user sell === %@",content);
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    [self startWaiting];
    [FFBusinessModel userSellRecordWithPage:Next_page Type:self.type Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            NSArray *array = CONTENT_DATA[@"list"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.refreshFooter endRefreshing];
                [self.tableView reloadData];
            } else {
                [self.refreshFooter endRefreshingWithNoMoreData];
            }
        } else {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - table view data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFBusinessSellRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    cell.isBuy = self.isBuy;
    cell.dict = self.showArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - cell delelgate
- (void)FFBusinessSellRecordCell:(FFBusinessSellRecordCell *)cell clickButtonWithInfo:(id)info {
    syLog(@"点击 cell 按钮");
    switch (self.type) {
        case FFBusinessUserSellTypeUnderReview: {

            break;
        }
        case FFBusinessUserSellTypeSelling: {
            //售卖中, 下架操作/
            [UIAlertController showAlertControllerWithViewController:self alertControllerStyle:(UIAlertControllerStyleAlert) title:@"确定下架商品吗" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle: nil otherButtonTitles:@[@"确定"] CallBackBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self DropOffProductWith:cell.dict];
                }
            }];
            break;
        }
        case FFBusinessUserSellTypeSold: {

            break;
        }
        case FFBusinessUserSellTypeTransacton: {

            break;
        }
        case FFBusinessUserSellTypeCancel: {
            [self DropOnProductWith:cell.dict];
            break;
        }
        default:
            break;
    }
}

#pragma mark - method
- (void)DropOffProductWith:(NSDictionary *)dict {
    syLog(@"下架商品");
    [self startWaiting];
    [FFBusinessModel dropOffProductWithID:[NSString stringWithFormat:@"%@",dict[@"id"]] Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        success ? [UIAlertController showAlertMessage:@"下架成功" dismissTime:0.7 dismissBlock:^{
            [self refreshData];
        }] : [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
    }];
}

- (void)DropOnProductWith:(NSDictionary *)dict {
    syLog(@"上架商品");
    [self startWaiting];
    [FFBusinessModel ProductInfoWithProductID:[NSString stringWithFormat:@"%@",dict[@"id"]] Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        syLog(@"product === %@",content);
        if (success) {
            [self pushViewController:[FFBusinessSellProductController initwithDict:CONTENT_DATA]];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
    }];
}


#pragma mark - getter
- (FFBusinessUserSellType)type {
    return FFBusinessUserSellTypeUnderReview;
}

- (BOOL)isBuy {
    return NO;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [FFColorManager tableview_background_color];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        _tableView.mj_header = self.refreshHeader;
        _tableView.mj_footer = self.refreshFooter;
    }
    return _tableView;
}

- (MJRefreshNormalHeader *)refreshHeader {
    if (!_refreshHeader) {
        _refreshHeader = [[MJRefreshNormalHeader alloc] init];
        [_refreshHeader setRefreshingTarget:self];
        [_refreshHeader setTitle:@"数据已加载" forState:MJRefreshStateIdle];
        [_refreshHeader setTitle:@"刷新数据" forState:MJRefreshStatePulling];
        [_refreshHeader setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        [_refreshHeader setTitle:@"即将刷新" forState:MJRefreshStateWillRefresh];
        [_refreshHeader setTitle:@"所有数据加载完毕，没有更多的数据了" forState:MJRefreshStateNoMoreData];
        [_refreshHeader.lastUpdatedTimeLabel setText:@"0"];
        [_refreshHeader setRefreshingAction:@selector(refreshData)];
        _refreshHeader.automaticallyChangeAlpha = YES;
    }
    return _refreshHeader;
}

- (MJRefreshBackFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _refreshFooter;
}



@end


