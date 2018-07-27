//
//  FFRankListViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFRankListViewController.h"

#define CELL_IDE @"FFCustomizeCell"

@interface FFRankListViewController ()


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
//    [self setGameType:@"2"];
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
            [self.tableView reloadData];
        } else {

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
    [FFGameModel gameListWithPage:New_page ServerType:self.gameServerType GameType:self.gameType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    [cell setValue:@3 forKey:@"selectionStyle"];
    NSMutableDictionary *dict = [self.showArray[indexPath.row] mutableCopy];
    if (indexPath.row < 3) {
        [dict setObject:[NSString stringWithFormat:@"Invite_%lu",indexPath.row + 1] forKey:@"downloadImage"];
    } else {
        [dict setObject:[NSString stringWithFormat:@"Invite_other"] forKey:@"downloadImage"];
    }
    
    [dict setObject:[NSString stringWithFormat:@"%lu",indexPath.row + 1] forKey:@"rank"];
    [cell setValue:dict forKey:@"dict"];
    
    return cell;
}


#pragma mark - getter
- (FFGameServersType)gameServerType {
    return BT_SERVERS;
}

- (NSString *)gameType {
    return @"1";
}




@end








