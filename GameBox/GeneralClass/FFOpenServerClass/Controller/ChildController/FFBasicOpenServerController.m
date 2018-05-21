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

@interface FFBasicOpenServerController ()<FFopenServerCellDelegate>

@end

@implementation FFBasicOpenServerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataSource {
    [super initDataSource];
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
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
        syLog(@"open servers === %@",content);
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
    FFOpenServerCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.dict = self.showArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSDictionary *dict = self.showArray[indexPath.row];
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





@end
