//
//  FFNewGameViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/19.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFNewGameViewController.h"
#import "FFCustomizeCell.h"
#import <FFTools/FFTools.h>

#define CELL_IDE @"FFCustomizeCell"

@interface FFNewGameViewController ()

/** time array */
@property (nonatomic, strong) NSArray<NSString *> * timeArray;

/** game dictionary */
@property (nonatomic, strong) NSMutableDictionary * dataDictionary;

@end

@implementation FFNewGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.showsVerticalScrollIndicator = YES;
}

- (void)initDataSource {
    [super initDataSource];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - method
- (void)refreshData {
    self.currentPage = 1;
    [self startWaiting];
    [FFGameModel newGameListWithPage:New_page Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
//            syLog(@"new game == %@",content);
            self.showArray = [content[@"data"] mutableCopy];
            [self clearUpData:self.showArray];
        } else {

        }

        if (self.showArray && self.showArray.count > 0) {
            self.tableView.backgroundView = nil;
        } else {
            self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    [FFGameModel newGameListWithPage:Next_page Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            NSArray *dataArray = content[@"data"];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
    label.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    label.text = [NSString stringWithFormat:@"   %@",self.timeArray[section]];
    return label;
}

- (FFCustomizeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFCustomizeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    NSArray *array = self.dataDictionary[self.timeArray[indexPath.section]];
    cell.dict = array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

//    FFCustomizeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSDictionary *dict = cell.dict;
//
//    [FFGameViewController sharedController].gameName = dict[@"gamename"];
//    [FFGameViewController sharedController].gameLogo = cell.gameLogo.image;
//    [FFGameViewController sharedController].gameID = dict[@"id"];
//    HIDE_TABBAR;
//    HIDE_PARNENT_TABBAR;
//    [self.navigationController pushViewController:[FFGameViewController sharedController] animated:YES];
//    SHOW_TABBAR;
//    SHOW_PARNENT_TABBAR;
}





@end
