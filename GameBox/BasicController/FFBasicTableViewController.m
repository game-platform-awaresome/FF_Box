
//  FFBasicViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicTableViewController.h"
#import <FFTools/UINavigationController+FFGradient.h>

#define CELL_IDE @"FFCustomizeCell"

@interface FFBasicTableViewController ()



@end


@implementation FFBasicTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self begainRefresData];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.mj_header = self.refreshHeader;
    self.tableView.mj_footer = self.refreshFooter;
    [self.view addSubview:self.tableView];
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
}

- (void)refreshData {

}

- (void)loadMoreData {

}

#pragma mark - method
- (void)begainRefresData {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    id cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    [cell setValue:@3 forKey:@"selectionStyle"];
    [cell setValue:self.showArray[indexPath.row] forKey:@"dict"];

    return cell;
}

#pragma mark - table view delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

//    return;
    id cell = [tableView cellForRowAtIndexPath:indexPath];

    Class FFCustomizeCell = NSClassFromString(@"FFCustomizeCell");
    if (![cell isKindOfClass:FFCustomizeCell]) {
        
        return;
    }
    
    NSDictionary *dict = [cell valueForKey:@"dict"];
    Class FFGameViewController = NSClassFromString(@"FFGameViewController");
    SEL selector = NSSelectorFromString(@"sharedController");
    if ([FFGameViewController respondsToSelector:selector]) {
        IMP imp = [FFGameViewController methodForSelector:selector];
        UIViewController *(*func)(void) = (void *)imp;
        UIViewController *vc = func();
        if (vc) {
            NSString *gid = (dict[@"id"]) ? dict[@"id"] : dict[@"gid"];
            [vc setValue:gid forKey:@"gid"];
            [self pushViewController:vc];
        } else {
            syLog(@"\n ! %s \n present error :  %s not exist \n ! \n",__func__,sel_getName(selector));
        }
    } else {
        syLog(@"\n ! %s \n present error :  %s not exist \n ! \n",__func__,sel_getName(selector));
    }
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
        _tableView.backgroundColor = [FFColorManager tableview_background_color];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
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

- (MJRefreshBackFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _refreshFooter;
}



- (void)resetTableView {

    
}











@end
