//
//  FFGameGuideViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameDetailGuideViewController.h"

#import "FFWebViewController.h"
#import "FFCurrentGameModel.h"

#import "FFGameDetailGuideCell.h"

#define CELL_IDE @"FFGameDetailGuideCell"

@interface FFGameDetailGuideViewController ()

@property (nonatomic, strong) FFWebViewController *webViewController;

@end

@implementation FFGameDetailGuideViewController

- (void)viewWillAppear:(BOOL)animated {
    if (self.canRefresh) {
        [self refreshData];
    }
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.mj_footer = nil;
    self.tableView.mj_header = self.refreshHeader;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[FFGameDetailGuideCell class] forCellReuseIdentifier:CELL_IDE];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLayoutSubviews {
    self.tableView.frame = self.view.bounds;
}

- (void)refreshData {
    [super refreshData];
    [FFGameModel gameGuideWithGameID:CURRENT_GAME.game_id Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            syLog(@"game guide === %@",content);
            id data = content[@"data"][@"list"];
            if ([data isKindOfClass:[NSNull class]] || data == nil) {
                self.showArray = nil;
            } else {
                self.showArray = content[@"data"][@"list"];
            }
            [self.tableView reloadData];
        }
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFGameDetailGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    cell.dict = self.showArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.webViewController.webURL = self.showArray[indexPath.row][@"info_url"];
    [self pushViewController:self.webViewController];
}

- (FFWebViewController *)webViewController {
    if (!_webViewController) {
        _webViewController = [[FFWebViewController alloc] init];
    }
    return _webViewController;
}



@end
