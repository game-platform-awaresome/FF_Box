//
//  FFZKServerViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/11.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFZKServerViewController.h"

@interface FFZKServerViewController ()

@end

@implementation FFZKServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



#pragma mark - setter
- (void)setNavigationTitle:(NSString *)title {
    self.navigationItem.title = @"折扣服";
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 44 - KSTATUBAR_HEIGHT - kTABBAR_HEIGHT);
}

#pragma mark - getter
- (FFGameServersType)type {
    return ZK_SERVERS;
}

- (NSArray *)selectButtonArray {
    return @[@"新游",@"活动",@"超低折扣",@"分类"];
}

- (NSArray *)selectImageArray {
    return @[[FFImageManager Home_new_game],
             [FFImageManager Home_activity],
             [FFImageManager Home_discount],
             [FFImageManager Home_classify]];
}
- (NSArray *)selectControllerName {
    return @[@"FFZKNewGameController",
             @"FFActivityViewController",
             @"FFDiscountController",
             @"FFZKClassifyController"];
}

//- (void)resetTableView {
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kTABBAR_HEIGHT - KSTATUBAR_HEIGHT - 44) style:(UITableViewStyleGrouped)];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    self.tableView.showsVerticalScrollIndicator = YES;
//    self.tableView.showsHorizontalScrollIndicator = NO;
//    self.tableView.tableFooterView = [UIView new];
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
//    } else {
//
//    }
//    self.tableView.mj_header = self.refreshHeader;
//    self.tableView.mj_footer = self.refreshFooter;
//    [self.view addSubview:self.tableView];
//    [self registCell];
//}





@end
