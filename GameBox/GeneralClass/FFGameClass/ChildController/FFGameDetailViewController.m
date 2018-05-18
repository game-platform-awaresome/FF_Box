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

@interface FFGameDetailViewController ()

@property (nonatomic, strong) FFGameDetailHeaderView *headerView;

@property (nonatomic, strong) NSArray *sectionArray;


@end

@implementation FFGameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    [self resetTableView];
}

- (void)initDataSource {
    self.sectionArray = @[@"",@"",@"",@"",@"",@""];
}

- (void)viewDidLayoutSubviews {
    self.tableView.frame = self.view.bounds;
}

- (void)refresh {
    self.headerView.imageArray = CURRENT_GAME.showImageArray;
}

#pragma mark - objserve
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"frameChange"]) {
//        syLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//        self.tableView.frame = self.view.bounds;
//    }
//}



#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123123"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"123123"];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    label.backgroundColor = [UIColor blackColor];
    return label;
}

#pragma mark - setter


#pragma mark - getter
- (FFGameDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFGameDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.77)];
    }
    return _headerView;
}



- (void)resetTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0,0) style:(UITableViewStyleGrouped)];
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










