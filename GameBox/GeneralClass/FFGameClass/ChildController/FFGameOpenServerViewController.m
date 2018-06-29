//
//  FFGameOpenServerViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameOpenServerViewController.h"
#import "FFCurrentGameModel.h"
#import "FFGameOpenCell.h"

#define CELL_IDE @"FFGameOpenCell"

@interface FFGameOpenServerViewController ()

@end

@implementation FFGameOpenServerViewController

- (void)viewWillAppear:(BOOL)animated {
    if (self.canRefresh) {
        [self refreshData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_footer = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    BOX_REGISTER_CELL;
}

- (void)refreshData {
    [FFGameModel openServersWithGameID:CURRENT_GAME.game_id Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        syLog(@"game open servers == %@",content);
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


#pragma mark - cell for
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFGameOpenCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.dict = self.showArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
