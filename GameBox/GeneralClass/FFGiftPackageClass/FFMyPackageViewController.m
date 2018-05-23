//
//  FFMyPackageViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFMyPackageViewController.h"
#import "FFpackageCell.h"

#define CELL_IDE @"FFpackageCell"

@interface FFMyPackageViewController () <FFpackageCellDelegate>

@end

@implementation FFMyPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
    self.navigationItem.title = @"我的礼包";
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
}

- (void)refreshData {
    Reset_page;
    [FFGameModel getUserGiftPackageWithPage:New_page Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            NSArray *array = content[@"data"][@"list"];
            syLog(@"package === %@",array);
            self.showArray = [array mutableCopy];
            [self.tableView reloadData];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    [FFGameModel getUserGiftPackageWithPage:Next_page Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            NSArray *array = content[@"data"][@"list"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            BOX_MESSAGE(content[@"msg"]);
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFpackageCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.currentIdx = indexPath.row;
    cell.dict = self.showArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - cell delegate
- (void)FFpackageCell:(FFpackageCell *)cell select:(NSInteger)idx {
    syLog(@"领取礼包");
    NSString *str = self.showArray[idx][@"card"];
    if ([str isKindOfClass:[NSNull class]]) {
        [FFGameModel getGameGiftWithPackageID:cell.dict[@"id"] Completion:^(NSDictionary * _Nonnull content, BOOL success) {
            if (success) {
                NSMutableDictionary *dict = [self.showArray[idx] mutableCopy];
                [dict setObject:content[@"data"] forKey:@"card"];
                [self.showArray replaceObjectAtIndex:idx withObject:dict];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
                [UIAlertController showAlertMessage:@"领取成功" dismissTime:0.7 dismissBlock:nil];
            } else {
                [UIAlertController showAlertMessage:@"领取失败" dismissTime:0.7 dismissBlock:nil];
            }
        }];

    } else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
        [UIAlertController showAlertMessage:@"已复制礼包兑换码" dismissTime:0.7 dismissBlock:nil];
    }
}


#pragma mark - getter


//- (FFPackageDetailViewController *)detailViewController {
//    if (!_detailViewController) {
//        //        _detailViewController = [[FFPackageDetailViewController alloc] init];
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil];
//        _detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"FFPackageDetailViewController"];
//    }
//    return _detailViewController;
//}


@end
