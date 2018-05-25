//
//  FFGameActivityCell.m
//  GameBox
//
//  Created by 燚 on 2018/5/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameActivityCell.h"

@interface FFGameActivityCell () <UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FFGameActivityCell




- (void)setAcitivityArray:(NSArray *)acitivityArray {
    _acitivityArray = acitivityArray;
    [self.tableView reloadData];
    [self.contentView addSubview:self.tableView];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.tableView.frame = self.bounds;
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.acitivityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExclusiveEventCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ExclusiveEventCell"];
    }
    cell.textLabel.text = self.acitivityArray[indexPath.row][@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.block) {
        self.block(self.acitivityArray[indexPath.row]);
    }
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor whiteColor];

        _tableView.delegate = self;
        _tableView.dataSource = self;

        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ExclusiveEventCell"];

        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}




@end
