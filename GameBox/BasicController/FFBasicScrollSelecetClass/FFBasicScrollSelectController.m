//
//  FFBasicScrollSelectController.m
//  GameBox
//
//  Created by 燚 on 2018/5/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicScrollSelectController.h"

#import <AudioToolbox/AudioToolbox.h>

@implementation FFBasicSSTableView

//允许同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end



@interface FFBasicScrollSelectController ()

@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@property (nonatomic, assign) CGFloat sectionHeaderHeight;;
@property (nonatomic, assign) CGFloat tableHeaderHeight;
@property (nonatomic, assign) CGFloat footerViewHeight;

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, assign) BOOL isRefreshing;

@end

@implementation FFBasicScrollSelectController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableviewScrollNotififation:) name:@"FFSSControllerTableScroll" object:nil];
}

- (void)tableviewScrollNotififation:(NSNotification *)sender  {
    self.canScroll = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initUserInterface {
    self.view.backgroundColor = [FFColorManager view_default_background_color];
    self.title = @"";
    self.canScroll = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navigationView];
}

- (void)initDataSource {
    WeakSelf;
    [FFBasicSSTableViewCell cell].canHorizontalScroll = YES;
    [[FFBasicSSTableViewCell cell] setScrollBlock:^(BOOL isScroll) {
        weakSelf.tableView.scrollEnabled = !isScroll;
    }];
}

- (void)refreshData {
    
}

#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFBasicSSTableViewCell *cell = [FFBasicSSTableViewCell cell];
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSCREEN_HEIGHT - kNAVIGATION_HEIGHT - self.sectionHeaderHeight - self.footerViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.sectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sectionView;
}

#pragma mark - scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [FFBasicSSTableViewCell cell].canHorizontalScroll = NO;
    _isRefreshing = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [FFBasicSSTableViewCell cell].canHorizontalScroll = YES;
    if (_isRefreshing) {
        _isRefreshing = NO;
        [self refreshData];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < -100 && !_isRefreshing) {
        _isRefreshing = YES;
        AudioServicesPlaySystemSound(1519);
    }

    //子控制器和主控制器之间的滑动状态切换
    CGFloat tabOffsetY = [_tableView rectForSection:0].origin.y - kNAVIGATION_HEIGHT;
    if (scrollView.contentOffset.y > tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        [self setChildControlelrScroll:YES];
        if (_canScroll) {
            _canScroll = NO;
        }
    } else {
        if (!_canScroll) {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        }
    }
}


- (void)showNavigationTitle {

}

- (void)hideNavigationTitle {

}

#pragma mark - setter
- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    self.tableView.tableHeaderView = _headerView;
    self.tableHeaderHeight = headerView.bounds.size.height;
}

- (void)setSectionView:(UIView *)sectionView {
    _sectionView = sectionView;
    self.sectionHeaderHeight = sectionView.bounds.size.height;
    [self.tableView reloadData];
}

- (void)setFooterView:(UIView *)footerView {
    if (_footerView) {
        [_footerView removeFromSuperview];
    }
    _footerView = footerView;
    self.footerViewHeight = footerView.bounds.size.height;
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - footerView.bounds.size.height);
    [self.view addSubview:_footerView];
}

- (void)setSelectChildConttoller:(NSArray<FFBasicSSTableViewController *> *)selectChildConttoller {
    _selectChildConttoller = selectChildConttoller;
    [FFBasicSSTableViewCell cell].dataArray = selectChildConttoller;
}

- (void)setChildControlelrScroll:(BOOL)scroll {
    if (self.selectChildConttoller.count > 0) {
        for (FFBasicSSTableViewController *vc in self.selectChildConttoller) {
            vc.canScroll = scroll;
        }
    }
}

#pragma mark - getter
- (FFBasicSSTableView *)tableView {
    if (!_tableView) {
        _tableView = [[FFBasicSSTableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:self.tableViewStyle];

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

        _canScroll = YES;
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

- (UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kNAVIGATION_HEIGHT)];
        _navigationView.backgroundColor = [FFColorManager game_controller_navigation_color];
        _navigationView.alpha = 0;
    }
    return _navigationView;
}

- (FFBasicSSSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[FFBasicSSSelectView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 45)];
        _selectView.backgroundColor = [UIColor whiteColor];
    }
    return _selectView;
}



@end





