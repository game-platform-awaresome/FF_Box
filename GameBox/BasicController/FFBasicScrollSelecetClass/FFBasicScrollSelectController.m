//
//  FFBasicScrollSelectController.m
//  GameBox
//
//  Created by 燚 on 2018/5/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicScrollSelectController.h"

@interface FFBasicScrollSelectController ()

@end

@implementation FFBasicScrollSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - table view delegate






@end
