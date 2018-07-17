//
//  FFH5ServerViewController.m
//  GameBox
//
//  Created by 燚 on 2018/7/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFH5ServerViewController.h"

@interface FFH5ServerViewController ()

@end

@implementation FFH5ServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - setter
- (void)setNavigationTitle:(NSString *)title {
    self.navigationItem.title = @"H5";
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 44 - KSTATUBAR_HEIGHT - kTABBAR_HEIGHT);
}

#pragma mark - responds
- (void)respondsToRightButton {
    pushViewController(@"FFZKClassifyController");
}

#pragma mark - getter
- (FFGameServersType)type {
    return H5_SERVERS;
}

- (NSArray *)selectButtonArray {
    return @[@"新游",@"活动",@"超低折扣",@"开服表"];
}

- (NSArray *)selectImageArray {
    return @[[FFImageManager Home_new_game],
             [FFImageManager Home_activity],
             [FFImageManager Home_discount],
             [FFImageManager Home_classify]];
}

- (NSArray *)selectControllerName {
    return @[@"FFZKNewGameController",
             @"FFZKActivityViewController",
             @"FFDiscountController",
             @"FFZKOpenServerViewController"];
}




@end
