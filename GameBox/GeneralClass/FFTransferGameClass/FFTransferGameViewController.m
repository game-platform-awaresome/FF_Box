//
//  FFTransferGameViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFTransferGameViewController.h"
#import "FFRebateSelectView.h"
#import "FFApplyTransferView.h"
#import "FFTransferRecordCell.h"
#import "FFTransferServerNotesController.h"
#import "FFUserModel.h"

#define NAVGATION_BAR_HEIGHT CGRectGetMaxY(self.navigationController.navigationBar.frame)
#define CELL_IDE @"FFTransferRecordCell"


@interface FFTransferGameViewController ()<FFRebateSelectViewDelegate, UIScrollViewDelegate, FFApplyTransferViewDelegate,UITableViewDelegate>

/** 提示标签 */
@property (nonatomic, strong) UILabel *remindLabel;

/** 选择视图 */
@property (nonatomic, strong) FFRebateSelectView *selectView;

/** 滑动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 申请转游视图 */
@property (nonatomic, strong) FFApplyTransferView *applyTransferView;


@property (nonatomic, strong) FFTransferServerNotesController *notesController;

@end

@implementation FFTransferGameViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(kSCREEN_WIDTH, 0, kSCREEN_WIDTH, self.scrollView.bounds.size.height);
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"申请转游";
    self.view.backgroundColor = [FFColorManager tabbarColor];
    [self.rightButton setTitle:@"转游须知"];
    self.navigationItem.rightBarButtonItem = self.rightButton;
    [self.view addSubview:self.remindLabel];
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.scrollView];
    BOX_REGISTER_CELL;
}


- (void)initDataSource {
    [super initDataSource];
    [self refreshData];
}

- (void)refreshData {
    Reset_page;
    [FFUserModel transferGameListWithPage:New_page Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            syLog(@"transfer game == %@",content);
            NSArray *array = content[@"data"][@"list"];
            self.showArray = [array mutableCopy];
            [self.tableView reloadData];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    [FFUserModel transferGameListWithPage:Next_page Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSArray *array = content[@"data"][@"list"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            BOX_MESSAGE(content[@"msg"]);
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - responds
- (void)respondsToRightButton {
    HIDE_TABBAR;
    [self.navigationController pushViewController:self.notesController animated:YES];
}

#pragma mark - table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FFTransferRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];

    cell.dict = self.showArray[indexPath.row];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    //设置选择视图的浮标
    if (scrollView == self.scrollView) {
        [self.selectView reomveLabelWithX:(x / scrollView.contentSize.width * kSCREEN_WIDTH)];
    }
}

#pragma mark - select view delegate
- (void)FFRebateSelectView:(FFRebateSelectView *)selectView didSelectBtnAtIndexPath:(NSInteger)idx {
    [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * idx, 0) animated:YES];
}

#pragma mark - apply transfer server delegate
- (void)FFApplyTransferView:(FFApplyTransferView *)view clickSureButton:(NSDictionary *)info {
    [FFUserModel transferGameApplyWithOriginAppName:info[@"origin_appname"]OriginServerName:info[@"origin_servername"] OriginRoleName:info[@"origin_rolename"] NewAppName:info[@"new_appname"] NewServerName:info[@"new_servername"] NewRoleName:info[@"new_rolename"] QQNumber:info[@"qq"] Mobile:info[@"mobile"] Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            [view setAllTextfildNil];
        }
        BOX_MESSAGE(content[@"msg"]);
    }];
}

#pragma mark - getter
- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] init];
        _remindLabel.frame = CGRectMake(0, NAVGATION_BAR_HEIGHT, kSCREEN_WIDTH, 35);
        _remindLabel.text = @"转游戏前请先查看右上角帮助或者联系客服";
        _remindLabel.textColor = [FFColorManager blue_dark];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        if (kSCREEN_WIDTH < 375) {
            _remindLabel.font = [UIFont systemFontOfSize:14];
        } else {
            _remindLabel.font = [UIFont systemFontOfSize:16];
        }
    }
    return _remindLabel;
}

- (FFRebateSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[FFRebateSelectView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.remindLabel.frame) + 5, kSCREEN_WIDTH, 60) WithBtnArray:@[@"转游申请",@"转游记录"]];

        _selectView.delegate = self;
    }
    return _selectView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectView.frame) + 5, kSCREEN_WIDTH, kSCREEN_HEIGHT - (CGRectGetMaxY(self.selectView.frame) + 5))];

        _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * 2, _scrollView.frame.size.height);

        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        [_scrollView addSubview:self.applyTransferView];
        [_scrollView addSubview:self.tableView];
#ifdef DEBUG
        _scrollView.backgroundColor = [UIColor grayColor];
#else
        _scrollView.backgroundColor = [UIColor whiteColor];
#endif
    }
    return _scrollView;
}

- (FFApplyTransferView *)applyTransferView {
    if (!_applyTransferView) {
        _applyTransferView = [[NSBundle mainBundle] loadNibNamed:@"FFApplyTransferView" owner:nil options:nil].lastObject;
        _applyTransferView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - (CGRectGetMaxY(self.selectView.frame) - 5));
        _applyTransferView.delegate = self;
    }
    return _applyTransferView;
}

- (FFTransferServerNotesController *)notesController {
    if (!_notesController) {
        _notesController = [[FFTransferServerNotesController alloc] init];
    }
    return _notesController;
}









@end
