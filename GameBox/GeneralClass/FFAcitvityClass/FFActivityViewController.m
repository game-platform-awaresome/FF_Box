//
//  FFActivityViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/27.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFActivityViewController.h"
#import "FFActivityTableViewCell.h"
#import "FFWebViewController.h"

#define CELL_IDE @"FFActivityTableViewCell"

@interface FFActivityViewController ()

@property (nonatomic, strong) FFWebViewController *webViewController;

@end

@implementation FFActivityViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"1.0";
}

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.mj_footer = nil;
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
    self.navigationItem.title = @"独家活动";
}


- (void)refreshData {
    [self startWaiting];
    [FFGameModel gameActivityWithPage:@"1" ServerType:self.type Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            self.showArray = [CONTENT_DATA mutableCopy];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.dict = self.showArray[indexPath.row];
    return cell;
}   


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30 + kSCREEN_WIDTH / 16 * 9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.showArray[indexPath.row];
    self.webViewController.webURL = dict[@"url"];
    [self pushViewController:self.webViewController];
}


- (FFGameServersType)type {
    return BT_SERVERS;
}

#pragma mark - getter
- (FFWebViewController *)webViewController {
    if (!_webViewController) {
        _webViewController = [[FFWebViewController alloc] init];
    }
    return _webViewController;
}



@end
