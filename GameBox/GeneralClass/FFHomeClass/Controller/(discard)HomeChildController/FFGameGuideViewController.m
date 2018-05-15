//
//  FFGameGuideViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/19.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameGuideViewController.h"
#import "FFWebViewController.h"
#import "FFGameGuideCell.h"

#define CELL_IDE @"FFGameGuideCell"

@interface FFGameGuideViewController ()

@property (nonatomic, strong) FFWebViewController *webViewController;

@end

@implementation FFGameGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.showsVerticalScrollIndicator = YES;
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma amrk - method
- (void)refreshData {
    self.currentPage = 1;
    [self startWaiting];
    [FFGameModel gameGuideListWithPage:New_page Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        syLog(@"game guide list === %@",content);
        [self stopWaiting];
        if (success) {
            self.showArray = [content[@"data"][@"list"] mutableCopy];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    [FFGameModel gameGuideListWithPage:New_page Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            NSArray *array = content[@"data"][@"list"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    }];
}


#pragma mark - table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFGameGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    cell.dict = self.showArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.webViewController.webURL = self.showArray[indexPath.row][@"info_url"];
    [self pushViewController:self.webViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


#pragma mark - getter
- (FFWebViewController *)webViewController {
    if (!_webViewController) {
        _webViewController = [[FFWebViewController alloc] init];
    }
    return _webViewController;
}






@end
