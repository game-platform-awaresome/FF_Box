//
//  FFPromiseViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFPromiseViewController.h"
#import <UIImageView+WebCache.h>
#import "FFPromiseCell.h"
#import <MJRefresh.h>

#define CELL_IDE @"FFPromiseCell"

@interface FFPromiseViewController () <UITableViewDelegate, UITableViewDataSource , FFPromiseCellDelegate>

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *showArray;

/** refresh header */
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;


@end

@implementation FFPromiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
    [self.tableView.mj_header beginRefreshing];
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.showArray = [@[@""] mutableCopy];
}

- (void)initUserInterface {
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.estimatedRowHeight = 100;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)refreshData {
    [self.tableView.mj_header endRefreshing];
    [self startWaiting];
    [FFGameModel gamePromiseCompletion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        [self.tableView.mj_header endRefreshing];
        syLog(@"promise === %@",content);
        if (success) {
            [self setHeaderviewWith:CONTENT_DATA[@"pic"]];
            NSArray *array = CONTENT_DATA[@"list"];
            if (array && [array isKindOfClass:[NSArray class]]) {
                self.showArray = array.mutableCopy;
            }
        } else {

        }


        [self.tableView reloadData];
    }];
}

- (void)setHeaderviewWith:(NSString *)url {
    if ([url isKindOfClass:[NSString class]] && url.length > 0) {
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    }
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFPromiseCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.dict = self.showArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    view.backgroundColor = [FFColorManager navigation_bar_white_color];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, kSCREEN_WIDTH - 20, 30)];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [FFColorManager textColorMiddle];
    label.textAlignment = NSTextAlignmentLeft;
    NSDictionary *dict = self.showArray[section];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        label.text = dict[@"title"];
    }
    [view addSubview:label];

    return view;
}

- (void)FFPromiseCell:(FFPromiseCell *)cell clickQQButtonWithString:(NSString *)qq {
    if (qq && [qq isKindOfClass:[NSString class]] && qq.length > 0) {
        NSString *urlStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qq];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}


#pragma mark - getter
- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 432 / 1080)];
    }
    return _headerView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [FFColorManager tableview_background_color];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];;
        _tableView.mj_header = self.refreshHeader;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {

        }
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



@end
