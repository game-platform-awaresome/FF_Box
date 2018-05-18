//
//  FFGameGuideViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameDetailGuideViewController.h"

#import "FFGameGuideCell.h"
#import "FFWebViewController.h"
#import "FFCurrentGameModel.h"

#define CELL_IDE @"FFGameGuideCell"

@interface FFGameDetailGuideViewController ()

@property (nonatomic, strong) FFWebViewController *webViewController;

@end

@implementation FFGameDetailGuideViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.mj_footer = nil;
    self.tableView.mj_header = self.refreshHeader;
    [self.view addSubview:self.tableView];
    BOX_REGISTER_CELL;
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLayoutSubviews {
    self.tableView.frame = self.view.bounds;
}

- (void)refreshData {
    [super refreshData];
//    [self startWaiting];
    [FFGameModel gameGuideWithGameID:CURRENT_GAME.game_id Completion:^(NSDictionary * _Nonnull content, BOOL success) {
//        [self stopWaiting];
        if (success) {
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
    FFGameGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.dict = self.showArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
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
