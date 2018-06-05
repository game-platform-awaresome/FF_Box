//
//  FFNewGameHeaderView.m
//  GameBox
//
//  Created by 燚 on 2018/6/4.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFNewGameHeaderView.h"
#import "FFGameIconTableCell.h"
#import "FFColorManager.h"

#define CELL_IDE @"FFGameIconTableCell"
#define BUTTON_TAG 10086

@interface FFNewGameHeaderView ()<UITableViewDelegate, UITableViewDataSource, FFGameIconTableCellDelegate>



@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *showArry;


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
    _showArry = array.copy;
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 130 * array.count);

    syLog(@"title array === %@",self.titleArray);
    [self.tableView reloadData];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.tableView.frame = frame;
}

#pragma mark - cell delegate
- (void)FFGameIconTableCell:(FFGameIconTableCell *)cell selectItemWithInfo:(id)info {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFNewGameHeaderView:seletGameItemWithInfo:)]) {
        [self.delegate FFNewGameHeaderView:self seletGameItemWithInfo:info];
    }
}

#pragma mark - responds
- (void)respondsToButton:(UIButton *)sender {
    NSString *title = self.titleArray[sender.tag - BUTTON_TAG];
    if ([title isEqualToString:@"内测游戏"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(FFNewGameHeaderView:showBetaGame:)]) {
            [self.delegate FFNewGameHeaderView:self showBetaGame:nil];
        }
    } else if ([title isEqualToString:@"预约游戏"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(FFNewGameHeaderView:showreservationGame:)]) {
            [self.delegate FFNewGameHeaderView:self showreservationGame:nil];
        }
    }
}


#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showArry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFGameIconTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.array = self.showArry[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [FFColorManager navigation_bar_white_color];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    view.backgroundColor = [FFColorManager navigation_bar_white_color];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH - 30, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = self.titleArray[section];
    label.textColor = [FFColorManager textColorDark];
    label.font = [UIFont systemFontOfSize:16];
    [label sizeToFit];
    label.center = CGPointMake(10 + label.bounds.size.width / 2, 15);

    [view addSubview:label];

    if (section == 0) {
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 1);
        layer.backgroundColor = [FFColorManager view_separa_line_color].CGColor;
        [view.layer addSublayer:layer];
    }


    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"更多 >" forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button sizeToFit];
    button.bounds = CGRectMake(0, 0, button.bounds.size.width + 10, 30);
    button.center = CGPointMake(kSCREEN_WIDTH - 15 - button.bounds.size.width / 2, 15);
    [button setTitleColor:[FFColorManager textColorMiddle] forState:(UIControlStateNormal)];
    [view addSubview:button];
    button.tag = BUTTON_TAG + section;
    [button addTarget:self action:@selector(respondsToButton:) forControlEvents:(UIControlEventTouchUpInside)];


    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    view.backgroundColor = [FFColorManager view_separa_line_color];
    return view;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 0) style:(UITableViewStylePlain)];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 10;

        [_tableView registerClass:NSClassFromString(CELL_IDE) forCellReuseIdentifier:CELL_IDE];

        _tableView.backgroundColor = [FFColorManager navigation_bar_white_color];
    }
    return _tableView;
}




@end









