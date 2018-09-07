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

#pragma mark - responds
- (void)respondsToRightButton {
    m185Statistics(@"分类", self.type);
    pushViewController(@"FFZKClassifyController");
}

#pragma mark - getter
- (FFGameServersType)type {
    return ZK_SERVERS;
}

- (NSArray *)selectButtonArray {
    return @[@"新游",@"排行榜",@"超低折扣",@"开服表"];
}

- (NSArray *)selectImageArray {
    return @[[FFImageManager Home_new_game],
             [FFImageManager Home_activity],
             [FFImageManager Home_discount],
             [FFImageManager Home_classify]];
}
- (NSArray *)selectControllerName {
    return @[@"FFZKNewGameController",
             @"FFZKRankViewController",
             @"FFDiscountController",
             @"FFZKOpenServerViewController"];
}







@end
