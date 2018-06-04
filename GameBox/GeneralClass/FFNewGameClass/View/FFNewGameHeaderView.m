//
//  FFNewGameHeaderView.m
//  GameBox
//
//  Created by 燚 on 2018/6/4.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFNewGameHeaderView.h"
#import "FFGameIconTableCell.h"

#define CELL_IDE @"FFGameIconTableCell"


@interface FFNewGameHeaderView ()<UITableViewDelegate, UITableViewDataSource>



@property (nonatomic, strong) UITableView *tableView;



@end


@implementation FFNewGameHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tableView];
}


#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 200);
}


- (void)setArray:(NSArray *)array {

}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}




#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFGameIconTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 0) style:(UITableViewStyleGrouped)];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 10;

        [_tableView registerClass:NSClassFromString(CELL_IDE) forCellReuseIdentifier:CELL_IDE];
    }
    return _tableView;
}




@end









