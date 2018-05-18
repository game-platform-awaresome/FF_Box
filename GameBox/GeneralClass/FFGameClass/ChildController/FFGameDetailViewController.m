//
//  FFGameDetailViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameDetailViewController.h"
#import "FFGameDetailHeaderView.h"
#import "FFCurrentGameModel.h"
#import "FFGameDetailSectionModel.h"

#import "FFGameDetailCell.h"

#define CELL_IDE @"FFGameDetailCell"

@interface FFGameDetailViewController ()

@property (nonatomic, strong) FFGameDetailHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray<FFGameDetailSectionModel *> *sectionArray;


@end

@implementation FFGameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    BOX_REGISTER_CELL;
}

- (void)initUserInterface {
//    [super initUserInterface];
    [self resetTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)initDataSource {
    self.sectionArray = [NSMutableArray arrayWithCapacity:6];
    for (int i = 0; i < 6; i++) {
        [self.sectionArray addObject:[FFGameDetailSectionModel initWithType:i]];
    }
}

- (void)viewDidLayoutSubviews {
    self.tableView.frame = self.view.bounds;
}

- (void)refreshData {
    [super refreshData];
    self.headerView.imageArray = CURRENT_GAME.showImageArray;
    self.tableView.tableHeaderView = self.headerView;
    for (int i = 0; i < 6; i++) {
        [self.sectionArray[i] refreshDataWith:i];
    }

    [self.tableView reloadData];
}

#pragma mark - objserve


#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionArray[section].sectionItemNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FFGameDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];

    cell.content = self.sectionArray[indexPath.section].contentString;

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH - 10, 44)];
    label.backgroundColor = [UIColor whiteColor];

    label.text = [NSString stringWithFormat:@"      %@ :",self.sectionArray[section].sectionHeaderTitle];
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = self.sectionArray[section].sectionFooterTitle;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.center = CGPointMake(kSCREEN_WIDTH / 2, 22);
    return label;
}

#pragma mark - setter


#pragma mark - getter
- (FFGameDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFGameDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.72)];
    }
    return _headerView;
}



- (void)resetTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0,0) style:(UITableViewStyleGrouped)];
    BOX_REGISTER_CELL;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.sectionHeaderHeight = 44;
    self.tableView.sectionFooterHeight = 44;
    self.tableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
    } else {

    }
    [self.view addSubview:self.tableView];
}








@end










