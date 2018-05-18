//
//  FFDriveFansNumbersViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/29.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveFansNumbersViewController.h"
#import "FFViewFactory.h"
#import "FFDriveFansCell.h"
#import "MBProgressHUD.h"

#define CELL_IDE @"FFDriveFansCell"

@interface FFDriveFansNumbersViewController ()<FFDriveCellDelegate>

@property (nonatomic, assign) NSUInteger currentPage;


@end

@implementation FFDriveFansNumbersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}



- (void)initUserInterface {
    MJRefreshNormalHeader *customRefreshHeader = [FFViewFactory customRefreshHeaderWithTableView:self.tableView WithTarget:self];
    //下拉刷新
    [customRefreshHeader setRefreshingAction:@selector(refreshNewData)];
    //上拉加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.tableFooterView = [UIView new];
}

- (void)initDataSource {
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
    [self refreshNewData];
}

#pragma mark - method
- (void)refreshNewData {
    _currentPage = 1;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
    [FFDriveModel userFansAndAttettionWithUid:self.buid Page:[NSString stringWithFormat:@"%lu",_currentPage] Type:self.type Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"attention === %@", content);
        [hud hideAnimated:YES];
        if (success) {
            NSArray *array = content[@"data"][@"list"];
            self.showArray = array.mutableCopy;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FansAndAttetionNumbersCallBack" object:nil userInfo:@{@"type":(self.type == attention) ? @"0" : @"1",@"data":content[@"data"][@"count"]}];
        }

        if (self.showArray.count == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
            imageView.image = [UIImage imageNamed:@"Community_NoData"];
            self.tableView.backgroundView = imageView;
        } else {
            self.tableView.backgroundView = nil;
        }

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    _currentPage++;
    [FFDriveModel userFansAndAttettionWithUid:self.buid Page:[NSString stringWithFormat:@"%lu",_currentPage] Type:self.type Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"attention === %@", content);
        if (success) {
            NSArray *array = content[@"data"][@"list"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }

        if (self.showArray.count == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
            imageView.image = [UIImage imageNamed:@"Community_NoData"];
            self.tableView.backgroundView = imageView;
        } else {
            self.tableView.backgroundView = nil;
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFDriveFansCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.dict = self.showArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    syLog(@"dict === %@",self.showArray[indexPath.row]);
    
    NSString *uid = self.showArray[indexPath.row][@"uid"];
    if (uid.length > 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushDriveMineDetailView" object:nil userInfo:@{@"uid":uid}];
    }
}

#pragma mark - cell delegate
- (void)FFDriveFansCell:(FFDriveFansCell *)cell clickAttentionButtonWitDict:(NSDictionary *)dict {
    NSString *attention1 = dict[@"follow_status"];
    AttentionType type = (attention1.integerValue == 0) ? attention : cancel;
    NSString *uid = dict[@"uid"];
    [FFDriveModel userAttentionWith:uid Type:type Complete:^(NSDictionary *content, BOOL success) {
        [self refreshNewData];
    }];
}


#pragma mark - getter
- (FansOrAttention)type {
    return myFans;
}



@end







