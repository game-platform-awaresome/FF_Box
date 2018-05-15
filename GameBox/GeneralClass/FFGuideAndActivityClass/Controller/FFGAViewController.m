//
//  FFGAViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGAViewController.h"
#import "FFWebViewController.h"
#import "FFActivityCell.h"
#import "FFGameGuideCell.h"


#define ACTIVITY_CELL_IDE   @"FFActivityCell"
#define GUIDE_CELL_IDE      @"FFGameGuideCell"

@interface FFGAViewController ()

@property (nonatomic, strong) FFWebViewController *webViewController;

@end

@implementation FFGAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.showsVerticalScrollIndicator = YES;
}

- (void)initDataSource {
    (self.acitvityType == FFActivity) ?
    [self.tableView registerNib:[UINib nibWithNibName:ACTIVITY_CELL_IDE bundle:nil] forCellReuseIdentifier:ACTIVITY_CELL_IDE] :
    [self.tableView registerNib:[UINib nibWithNibName:GUIDE_CELL_IDE bundle:nil] forCellReuseIdentifier:GUIDE_CELL_IDE];
}


#pragma mark - method
- (void)refreshData {
    self.currentPage = 1;
    [self startWaiting];
    [FFGameModel gameGuideAndActivityWithPage:New_page ServerType:self.gameServerType Type:self.acitvityType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];

        if (success) {
            self.showArray = [content[@"data"][@"list"] mutableCopy];
        } else {

        }

        if (self.showArray && self.showArray.count > 0) {
            self.tableView.backgroundView = nil;
        } else {
            self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    [FFGameModel gameGuideAndActivityWithPage:Next_page ServerType:self.gameServerType Type:self.acitvityType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
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

#pragma mark - tableview data source and delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell;
    NSString *cell_ide = (self.acitvityType == FFActivity) ? ACTIVITY_CELL_IDE : GUIDE_CELL_IDE;
    cell = [tableView dequeueReusableCellWithIdentifier:cell_ide];
    NSDictionary *dict = self.showArray[indexPath.row];
    [cell setValue:dict forKey:@"dict"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.acitvityType == FFActivity) ? 80 : 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.webViewController.webURL = self.showArray[indexPath.row][@"info_url"];
    [self pushViewController:self.webViewController];
}


#pragma mark - getter
- (FFGameServersType)gameServerType {
    return BT_SERVERS;
}

- (FFActivityType)acitvityType {
    return FFActivity;
}

- (FFWebViewController *)webViewController {
    if (!_webViewController) {
        _webViewController = [[FFWebViewController alloc] init];
    }
    return _webViewController;
}



@end
