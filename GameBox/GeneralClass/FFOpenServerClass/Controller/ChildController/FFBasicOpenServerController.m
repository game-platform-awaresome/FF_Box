//
//  FFBasicOpenServerController.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicOpenServerController.h"

#import "FFOpenServerCell.h"

#define CELL_IDE @"FFOpenServerCell"

@interface FFBasicOpenServerController ()

@end

@implementation FFBasicOpenServerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataSource {
    [super initDataSource];
    [self.tableView registerNib:[UINib nibWithNibName:kCAEmitterLayerLine bundle:nil] forCellReuseIdentifier:CELL_IDE];
}

- (void)initUserInterface {
    [super initUserInterface];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.view.bounds.size.height);
}

- (void)tableViewBegainRefreshing {
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData {
    self.currentPage = 1;
    [FFGameModel openServersListWithPage:New_page ServerType:self.gameServerType OpenType:self.openServerType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            self.showArray = [content[@"data"] mutableCopy];
            [self.tableView reloadData];
        }

        if (self.showArray && self.showArray.count > 0) {
            self.tableView.backgroundView = nil;
        } else {
            self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    [FFGameModel openServersListWithPage:Next_page ServerType:self.gameServerType OpenType:self.openServerType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            NSArray *array = content[@"data"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }];
}

#pragma mark - table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"???????"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"???????"];
    }

    cell.textLabel.text = self.showArray[indexPath.row][@"gamename"];
//    FFOpenServerCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
//
//    cell.dict = self.showArray[indexPath.row];

    return cell;
}




@end
