//
//  FFNewGameViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/19.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFNewGameViewController.h"
#import "FFGameViewController.h"
#import "FFCustomizeCell.h"
#import "FFNewGameHeaderView.h"

#define CELL_IDE @"FFCustomizeCell"

@interface FFNewGameViewController () <FFNewGameHeaderViewDelegate>

/** time array */
@property (nonatomic, strong) NSArray<NSString *> * timeArray;

/** game dictionary */
@property (nonatomic, strong) NSMutableDictionary * dataDictionary;

/** table headerview */
@property (nonatomic, strong) FFNewGameHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *headerDataArray;

@end

@implementation FFNewGameViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"1.0";
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    self.view.backgroundColor = [FFColorManager view_default_background_color];
    self.navigationItem.title = @"新游";
    [self resetTableView];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initDataSource {

}

#pragma mark - header view delegate
- (void)FFNewGameHeaderView:(FFNewGameHeaderView *)view seletGameItemWithInfo:(id)info {
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSString *gid = info[@"id"];
        [FFGameViewController sharedController].gid = gid;
        self.hidesBottomBarWhenPushed = YES;
        [self pushViewController:[FFGameViewController sharedController]];
    }
}

- (void)FFNewGameHeaderView:(FFNewGameHeaderView *)view showBetaGame:(id)info {
    syLog(@"内测游戏");
    pushViewController(@"FFBetaGameViewController");
}

- (void)FFNewGameHeaderView:(FFNewGameHeaderView *)view showreservationGame:(id)info {
    syLog(@"预约游戏");
    pushViewController(@"FFReservationGameController");
}

#pragma mark - method
- (void)refreshData {
    self.currentPage = 1;
    [self startWaiting];
    [FFGameModel newGameListWithPage:New_page ServerType:self.serverType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            self.headerDataArray = nil;
            syLog(@"new game == %@",content);
            NSDictionary *dict = content[@"data"];

            @try {
                self.showArray = [dict[@"list"] mutableCopy];
                [self clearUpData:self.showArray];
                //内测游戏
                NSArray *betaArray = CONTENT_DATA[@"closedBeta"];
                //预约游戏
                NSArray *reservationArray = CONTENT_DATA[@"reservation"];

                NSMutableArray *titleArray = [NSMutableArray array];
                if ([betaArray isKindOfClass:[NSArray class]] && betaArray.count > 0) {
                    [self.headerDataArray addObject:betaArray];
                    [titleArray addObject:@"内测游戏"];
                }

                if ([reservationArray isKindOfClass:[NSArray class]] && reservationArray.count > 0) {
                    [self.headerDataArray addObject:betaArray];
                    [titleArray addObject:@"预约游戏"];
                }

                self.headerView.titleArray = titleArray;
                self.headerView.array = self.headerDataArray;

            } @catch (NSException *exception) {

            } @finally {

            }



        } else {

        }

        if (self.showArray && self.showArray.count > 0) {
            self.tableView.backgroundView = nil;
        } else {
            self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

        if (self.headerDataArray.count > 0) {
            syLog(@"加载头部视图");
            self.tableView.tableHeaderView = self.headerView;
        } else {
            syLog(@"不加载头部视图");
            self.tableView.tableHeaderView = nil;
        }

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    [FFGameModel newGameListWithPage:Next_page ServerType:self.serverType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            NSArray *dataArray = content[@"data"][@"list"];
            syLog(@"new game == %@",content);
            if (dataArray.count > 0) {
                [self.showArray addObjectsFromArray:dataArray];
                [self clearUpData:self.showArray];
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

/** sort array with time */
- (NSMutableArray *)clearUpData:(NSMutableArray *)array {
    NSMutableSet *set = [NSMutableSet set];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    for (NSDictionary *obj in array) {
        NSString *timeStr = obj[@"addtime"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStr.integerValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY-MM-dd";
        timeStr = [formatter stringFromDate:date];
        syLog(@"sort time === %@",timeStr);
        NSMutableArray *array = dict[timeStr];
        if (array == nil) {
            array = [NSMutableArray array];
        }
        [array addObject:obj];
        [dict setObject:array forKey:timeStr];
        [set addObject:timeStr];
    }

    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]];
    self.timeArray = [set sortedArrayUsingDescriptors:sortDesc];
    self.dataDictionary = [dict mutableCopy];
    [self.timeArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *array = self.dataDictionary[obj];
        [self.dataDictionary setObject:array forKey:obj];
    }];

    return [array mutableCopy];
}

#pragma mark - tableview data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.timeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataDictionary[self.timeArray[section]];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
    view.backgroundColor = [UIColor whiteColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
    label.text = [NSString stringWithFormat:@"   %@",self.timeArray[section]];
    label.textColor = [FFColorManager textColorDark];
    [view addSubview:label];

    return view;
}

- (FFCustomizeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFCustomizeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    NSArray *array = self.dataDictionary[self.timeArray[indexPath.section]];
    cell.dict = array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    FFCustomizeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dict = cell.dict;
    [FFGameViewController sharedController].gid = dict[@"id"] ? dict[@"id"] : dict[@"gid"];
    [self pushViewController:[FFGameViewController sharedController]];
}


#pragma mark - getter
- (void)resetTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT) style:(UITableViewStyleGrouped)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } 
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.mj_header = self.refreshHeader;
    self.tableView.mj_footer = self.refreshFooter;
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.backgroundColor = [FFColorManager navigation_bar_white_color];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    BOX_REGISTER_CELL;
}

- (FFNewGameHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFNewGameHeaderView alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (NSMutableArray *)headerDataArray {
    if (!_headerDataArray) {
        _headerDataArray = [NSMutableArray array];
    }
    return _headerDataArray;
}





@end



