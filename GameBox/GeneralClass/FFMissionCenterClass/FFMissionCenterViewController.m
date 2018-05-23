//
//  FFMissionCenterViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFMissionCenterViewController.h"

@interface FFMissionCenterViewController ()

@property (nonatomic, strong) UIImageView *headerView;


@end

@implementation FFMissionCenterViewController

- (void)initDataSource {
    self.showArray = @[@"",@"",@"",@"",@"",@"",@"",@""].mutableCopy;
}

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)begainRefresData {

}



#pragma mark - table view delegate ande data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"missionCenterCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"missionCenterCell"];
    }

//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    label.text = @"asdfasdfasf";
//    cell.accessoryView = label;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.textLabel.text = @"哈哈哈哈哈";
    cell.detailTextLabel.text = @"哦哦哦哦哦哦哦哦";
    cell.detailTextLabel.textColor = [FFColorManager textColorMiddle];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSCREEN_HEIGHT * 0.66 / self.showArray.count;
}

#pragma mark - getter
- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT * 0.34)];
    }
    return _headerView;
}






@end











