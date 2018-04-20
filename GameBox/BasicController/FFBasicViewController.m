//
//  FFBasicViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicViewController.h"
#import <FFTools/UINavigationController+FFGradient.h>


@interface FFBasicViewController ()



@end



@implementation FFBasicViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBGAlpha = @"1.0";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}


#pragma mark - method
- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initDataSource {

}

- (void)refreshData {

}

- (void)loadMoreData {

}

#pragma mark - responds
- (void)respondsToRightButton {

}

- (void)respondsToLeftButton {

}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    return nil;
}

#pragma mark - table view delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
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

- (MJRefreshBackFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _refreshFooter;
}

- (UIBarButtonItem *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];
    }
    return _rightButton;
}

- (UIBarButtonItem *)leftButton {
    if (!_leftButton) {
        _rightButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
    }
    return _leftButton;
}
















@end
