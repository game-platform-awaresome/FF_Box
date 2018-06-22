//
//  FFBusinessWarehouseController.m
//  GameBox
//
//  Created by 燚 on 2018/6/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessWarehouseController.h"

@interface FFBusinessWarehouseController ()

@end

@implementation FFBusinessWarehouseController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.refreshHeader beginRefreshing];
}

- (FFBusinessUserSellType)type {
    return FFBusinessUserSellTypeCancel;
}










@end
