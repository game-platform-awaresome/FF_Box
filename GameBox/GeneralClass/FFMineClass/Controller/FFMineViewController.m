//
//  FFMineViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFMineViewController.h"
#import "FFControllerManager.h"
#import "FFMineViewModel.h"

@interface FFMineViewController ()

@property (nonatomic, strong) UIView *headerView;


@property (nonatomic, strong) FFMineViewModel *viewModel;


@end

@implementation FFMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBGAlpha = @"0.0";
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    self.navigationItem.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    [self resetTableView];
    [self.view addSubview:self.tableView];

    [self.rightButton setTitle:@"设置"];
    self.navigationItem.rightBarButtonItem = self.rightButton;
}

- (void)resetTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kTABBAR_HEIGHT) style:(UITableViewStyleGrouped)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    self.tableView.mj_header = self.refreshHeader;

    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;

    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
}


- (void)initDataSource {
    self.showArray = [@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""] mutableCopy];
}

- (void)begainRefresData {

}


#pragma mark - refresh
- (void)refreshData {
    [self.tableView.mj_header endRefreshing];
}

- (void)loadMoreData {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}


#pragma mark - responds
- (void)respondsToRightButton {
    UIViewController *vc = [UIViewController new];
    vc.navBarBGAlpha = @"1.0";
    vc.view.backgroundColor = [UIColor whiteColor];
    [self pushViewController:vc];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel sectionNumber];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel itemNumberWithSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMineCell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"NewMineCell"];
    }

    NSDictionary *dict = [self.viewModel cellInfoWithIndexpath:indexPath];
    
    cell.textLabel.text = dict[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    if (indexPath.section == 0) {

    } else {
        if (dict[@"attributeString"]) {
            cell.detailTextLabel.attributedText = dict[@"attributeString"];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        } else {
            cell.detailTextLabel.text = dict[@"subTitle"];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        }
    }


    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (dict[@"subimage"]) {
        cell.imageView.image = [UIImage imageNamed:dict[@"subimage"]];
    } else {
        cell.imageView.image = nil;
        syLog(@"no image === T@%@",dict);
    }

    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, cell.frame.size.height - 1, kSCREEN_WIDTH, 1);
    layer.backgroundColor = [FFColorManager backgroundColor].CGColor;
    [cell.contentView.layer addSublayer:layer];

    return cell;
}

#pragma mark - table veiw delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 24;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 24;
}


#pragma mark - getter
- (FFMineViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [FFMineViewModel new];
    }
    return _viewModel;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.6)];
        _headerView.backgroundColor = [UIColor blackColor];
    }
    return _headerView;
}





@end
