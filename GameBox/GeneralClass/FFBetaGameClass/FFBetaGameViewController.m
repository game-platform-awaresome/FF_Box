//
//  FFBetaGameViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/5.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBetaGameViewController.h"
#import "FFCustomizeCell.h"

#define CELL_IDE @"FFCustomizeCell"

@implementation FFBetaGameViewController

- (void)initUserInterface {
    [super initUserInterface];
    [self resetTableView];
    self.navigationItem.title = @"内测游戏";
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
}


- (void)refreshData {
    Reset_page;
    [self startWaiting];
    [FFGameModel betaAndReservationGameWithPage:New_page Type:self.type Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];

        syLog(@"beta game  === %@",content);
        if (success) {
            self.showArray = [CONTENT_DATA mutableCopy];
        }

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    [self startWaiting];
    [FFGameModel betaAndReservationGameWithPage:Next_page Type:self.type Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            NSArray *array = CONTENT_DATA;
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
    }];
}

#pragma makr - table veiw data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFCustomizeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    cell.dict = self.showArray[indexPath.section];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
    view.backgroundColor = [FFColorManager navigation_bar_white_color];

    NSString *timeString = [NSString stringWithFormat:@"%@",self.showArray[section][@"newgame_time"]];
    if ([timeString isEqualToString:@"0"] || timeString == nil || timeString.length < 1) {
        timeString = @"敬请期待";
    } else {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeString.integerValue];
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"YYYY-MM-dd";
        timeString = [formatter stringFromDate:date];
    }

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, kSCREEN_WIDTH - 30, 20)];
    if (self.type == FFBetaGame) {
        label.text = [NSString stringWithFormat:@"公测时间 : %@",timeString];
    } else {
        label.text = [NSString stringWithFormat:@"上线时间 : %@",timeString];
    }
    label.textColor = [FFColorManager textColorMiddle];
    label.font = [UIFont systemFontOfSize:15];

    [view addSubview:label];

    if (section == 0) {
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 1);
        layer.backgroundColor = [FFColorManager view_separa_line_color].CGColor;
        [view.layer addSublayer:layer];
    }

    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *dict = self.showArray[indexPath.section];

    Class FFGameViewController = NSClassFromString(@"FFGameViewController");
    SEL selector = NSSelectorFromString(@"sharedController");
    if ([FFGameViewController respondsToSelector:selector]) {
        IMP imp = [FFGameViewController methodForSelector:selector];
        UIViewController *(*func)(void) = (void *)imp;
        UIViewController *vc = func();
        if (vc) {
            NSString *gid = (dict[@"id"]) ?: dict[@"gid"];

            NSString *timeString = [NSString stringWithFormat:@"%@",self.showArray[indexPath.section][@"newgame_time"]];
            if ([timeString isEqualToString:@"0"] || timeString == nil || timeString.length < 1) {
                timeString = @"敬请期待";
            } else {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeString.integerValue];
                NSDateFormatter *formatter = [NSDateFormatter new];
                formatter.dateFormat = @"YYYY-MM-dd";
                timeString = [formatter stringFromDate:date];
            }
            [vc setValue:timeString forKey:(self.type == FFBetaGame) ? @"betaString" :@"reservationString"];
            [vc setValue:gid forKey:@"gid"];
            [self pushViewController:vc];
        } else {
            syLog(@"\n ! %s \n present error :  %s not exist \n ! \n",__func__,sel_getName(selector));
        }
    } else {
        syLog(@"\n ! %s \n present error :  %s not exist \n ! \n",__func__,sel_getName(selector));
    }
}


- (void)resetTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header = self.refreshHeader;
    self.tableView.mj_footer = self.refreshFooter;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = [FFColorManager navigation_bar_white_color];

    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];

    [self.view addSubview:self.tableView];
}

- (FFBetaOrReservationType)type {
    return FFBetaGame;
}


@end









