//
//  FFSystemInfoController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/12/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFSystemInfoController.h"
#import "FFMyNewsModel.h"
#import "FFSystemInfoCell.h"
#import "FFSystemDetailController.h"
#import "FFViewFactory.h"

#define CELL_IDE @"FFSystemInfoCell"

#define MODEL FFMyNewsModel

@interface FFSystemInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *showArray;


@end

@implementation FFSystemInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
    [self initDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.view.bounds.size.height);
}

- (void)initUserInterface {
    self.view.layer.masksToBounds = YES;
    [self.view addSubview:self.tableView];
}

- (void)initDataSource {
//    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - method
- (void)refreshData {
    START_NET_WORK;
    [MODEL systemInfoListWithCompletion:^(NSDictionary *content, BOOL success) {
        STOP_NET_WORK;
        syLog(@"content ==== %@  ",content);
        [self.tableView.mj_header endRefreshing];
        if (success) {
            self.showArray = [content[@"data"] mutableCopy];
        } else {
            self.showArray = nil;
        }
        [self.tableView reloadData];
    }];
}


#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFSystemInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];

    cell.dict = self.showArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.showArray[indexPath.row];

    FFSystemDetailController *detailController = [[FFSystemDetailController alloc] init];
    detailController.dict = dict;
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:detailController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dict = self.showArray[indexPath.row];
        START_NET_WORK;
        [MODEL deleteMessageWithMessageID:dict[@"id"] Completion:^(NSDictionary *content, BOOL success) {
            STOP_NET_WORK;
            if (success) {
                [self.showArray removeObjectAtIndex:indexPath.row];
                //tableView刷新方式   设置tableView带动画效果 删除数据
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationAutomatic];
                //取消编辑状态
                [tableView setEditing:NO animated:NO];
            } else {
                BOX_MESSAGE(content[@"msg"]);
            }
        }];
    }

}


#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [FFViewFactory creatTableView:_tableView WithFrame:CGRectNull WithDelegate:self];

        MJRefreshNormalHeader *customRefreshHeader = [FFViewFactory customRefreshHeaderWithTableView:_tableView WithTarget:self];

        //下拉刷新
        [customRefreshHeader setRefreshingAction:@selector(refreshData)];

        _tableView.tableFooterView = [UIView new];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 2)];
        line.backgroundColor = BACKGROUND_COLOR;
        _tableView.tableHeaderView = line;

        _tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.view.bounds.size.height);
        _tableView.estimatedRowHeight = 60;
        _tableView.rowHeight = UITableViewAutomaticDimension;

        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
    }
    return _tableView;
}











@end
