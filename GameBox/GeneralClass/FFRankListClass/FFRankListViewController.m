//
//  FFRankListViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFRankListViewController.h"
#import "FFGameViewController.h"
#import "FFRankHeaderView.h"
#import "FFRankListCell.h"

//#define CELL_IDE @"FFCustomizeCell"
#define CELL_IDE @"FFRankListCell"


@interface FFRankListViewController ()

@property (nonatomic, strong) FFRankHeaderView  *headerView;

@property (nonatomic, strong) NSString *gameType;


@end

@implementation FFRankListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"排行榜";
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
}

- (void)initDataSource {
    [super initDataSource];
    [self.tableView registerClass:[FFRankListCell class] forCellReuseIdentifier:CELL_IDE];

    WeakSelf;
    [self.headerView setClickGame:^(NSDictionary *dict) {
        [weakSelf respondsToGame:dict];
    }];
}

#pragma makr - responds
- (void)respondsToGame:(NSDictionary *)dict {
    [FFGameViewController sharedController].gid = dict[@"id"] ?: dict[@"gid"];
    BOOL flag = NO;
    for (id vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[FFGameViewController class]]) {
            flag = YES;
            break;
        }
    }

    if (flag) {
        [self.navigationController popToViewController:[FFGameViewController sharedController] animated:YES];
    } else {
        [self pushViewController:[FFGameViewController sharedController]];
    }
}


#pragma mark - method
- (void)refreshData {
    self.currentPage = 1;
    [self startWaiting];
    [FFGameModel gameListWithPage:New_page ServerType:self.gameServerType GameType:self.gameType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        
        syLog(@"rank list === %@",content);
        
        if (success) {
            self.showArray = [content[@"data"][@"list"] mutableCopy];
        } else {

        }

        if (self.showArray && self.showArray.count > 0) {
            self.tableView.backgroundView = nil;
        } else {
            self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

        if (self.showArray.count < 3) {
            self.tableView.tableHeaderView = [UIView new];
        } else {
            self.headerView.showArray = @[self.showArray[0],self.showArray[1],self.showArray[2]];
            self.tableView.tableHeaderView = self.headerView;
        }

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    [FFGameModel gameListWithPage:Next_page ServerType:self.gameServerType GameType:self.gameType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            NSArray *dataArray = content[@"data"][@"list"];
            if (dataArray.count > 0) {
                [self.showArray addObjectsFromArray:dataArray];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {

            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.showArray.count < 3) {
        return self.showArray.count;
    } else {
        return self.showArray.count - 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    if (self.showArray.count < 3) {
        cell.dict = self.showArray[indexPath.row];
        cell.idx = indexPath.row;
    } else {
        cell.dict = self.showArray[indexPath.row + 3];
        cell.idx = indexPath.row + 4;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.showArray.count < 3) {
        [self respondsToGame:self.showArray[indexPath.row]];
    } else {
        [self respondsToGame:self.showArray[indexPath.row + 3]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - getter
- (FFGameServersType)gameServerType {
    return BT_SERVERS;
}

- (NSString *)gameType {
    return @"3";
}


- (FFRankHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFRankHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 230)];
        _headerView.backgroundColor = kWhiteColor;
    }
    return _headerView;
}




@end








