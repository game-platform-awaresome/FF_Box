//
//  FFBusinessBuyProoductController.m
//  GameBox
//
//  Created by 燚 on 2018/6/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessBuyProoductController.h"
#import "FFImageManager.h"

@interface FFBusinessBuyProoductController ()

@end

@implementation FFBusinessBuyProoductController

+ (instancetype)init {
    return [[UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FFBusinessBuyProoductController"];
}


- (instancetype)init {
    return [FFBusinessBuyProoductController init];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[FFImageManager General_back_black] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
    self.navigationItem.title = @"购买商品";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark - responds
- (void)respondsToLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}






@end









