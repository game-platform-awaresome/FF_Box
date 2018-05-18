//
//  FFDriveMyNewsViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/2/6.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveMyNewsViewController.h"
#import "FFDriveDetailInfoViewController.h"
#import "FFDriveModel.h"
#import "FFDriveMyNewsCell.h"
#import "YBPopupMenu.h"

#define CELL_IDE @"FFDriveMyNewsCell"

@interface FFDriveMyNewsViewController () <UITableViewDelegate, UITableViewDataSource, YBPopupMenuDelegate>

@property (nonatomic, assign) MyNewsType myNewsType;

@property (nonatomic, strong) UIView *selectTypeView;


@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger maxPage;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) FFDriveDetailInfoViewController *detailController;

@end

@implementation FFDriveMyNewsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshType];
}

- (void)refreshType {
    [FFDriveModel myNewNumbersComplete:^(NSDictionary *content, BOOL success) {
        syLog(@"my news number == %@",content);
        NSString *count = [NSString stringWithFormat:@"%@",content[@"data"][@"count"]];
        if (success && count.integerValue > 0) {
            self.myNewsType = [NSString stringWithFormat:@"%@",content[@"data"][@"type"]].integerValue;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isRefreshMyNewsData" object:nil];
        } else {
            self.myNewsType = newComments;
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)initUserInterface {
    [super initUserInterface];
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
}

- (void)initDataSource {
//    self.myNewsType = newComments;
}

#pragma mark - responds
- (void)respondsToSelectButton {
    syLog(@"选择按钮");
    YBPopupMenu *menu = [YBPopupMenu showRelyOnView:self.selectButton titles:@[@"新的评论",@"被赞的评论",@"被赞的动态"] icons:nil menuWidth:self.selectButton.bounds.size.width delegate:self];
    menu.fontSize = 10.f;
    menu.type = YBPopupMenuTypeDark;
    menu.textColor = [UIColor whiteColor];
}


#pragma mark - method
- (void)refreshNewData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
    _currentPage = 1;
    [FFDriveModel myNewsWithType:self.myNewsType page:[NSString stringWithFormat:@"%lu",_currentPage] Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"my news --- %@",content);
        [hud hideAnimated:YES];
        self.showArray = nil;
        if (success) {
            self.showArray = [content[@"data"][@"list"] mutableCopy];
            self.maxPage = [NSString stringWithFormat:@"%@",content[@"data"][@"count"]].integerValue;
        }
        if (self.showArray.count == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
            imageView.image = [UIImage imageNamed:@"Community_NoData"];
            self.tableView.backgroundView = imageView;
        } else {
            self.tableView.backgroundView = nil;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    _currentPage++;
    if (_currentPage > _maxPage) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [FFDriveModel myNewsWithType:self.myNewsType page:[NSString stringWithFormat:@"%lu",_currentPage] Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"my news --- %@",content);
        if (success) {
            NSArray *array = content[@"data"];
            if (array.count > 0 && array != nil) {
                [self.showArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }

        if (self.showArray.count == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
            imageView.image = [UIImage imageNamed:@"Community_NoData"];
            self.tableView.backgroundView = imageView;
        } else {
            self.tableView.backgroundView = nil;
        }

    }];
}


#pragma mark - table view data source d
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFDriveMyNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.type = self.myNewsType;
    cell.dict = self.showArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.selectTypeView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dict = self.showArray[indexPath.row];
    self.detailController.dynamic_id = dict[@"dynamics_id"];
    self.detailController.indexPath = indexPath;
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:self.detailController animated:YES];
    SHOW_PARNENT_TABBAR;
}

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    self.myNewsType = (index + 1);
}

#pragma mark - setter
- (void)setMyNewsType:(MyNewsType)myNewsType {
    syLog(@"select type === %lu", myNewsType);
    if (_myNewsType != myNewsType) {
        _myNewsType = myNewsType;
        [self.tableView.mj_header beginRefreshing];
    }

    switch (myNewsType) {
        case newComments: [self.selectButton setTitle:@"新的评论" forState:(UIControlStateNormal)];
            break;
        case newLikeOfComment: [self.selectButton setTitle:@"被赞的评论" forState:(UIControlStateNormal)];
            break;
        case newLikeofDynamic: [self.selectButton setTitle:@"被赞的动态" forState:(UIControlStateNormal)];
            break;
        default:
            break;
    }
}

#pragma mark - getter
- (UIView *)selectTypeView {
    if (!_selectTypeView) {
        _selectTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
        _selectTypeView.backgroundColor = TABBARCOLOR;
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH - 115, 30)];
        title.text = @"消息类型 : ";
        title.textAlignment = NSTextAlignmentRight;
        [_selectTypeView addSubview:title];
        [_selectTypeView addSubview:self.selectButton];
    }
    return _selectTypeView;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _selectButton.frame = CGRectMake(kSCREEN_WIDTH - 110, 0, 100, 30);
        [_selectButton setTitle:@"回复" forState:(UIControlStateNormal)];
        [_selectButton addTarget:self action:@selector(respondsToSelectButton) forControlEvents:(UIControlEventTouchUpInside)];
        _selectButton.layer.cornerRadius = 4;
        _selectButton.layer.masksToBounds = YES;
        _selectButton.layer.borderColor = NAVGATION_BAR_COLOR.CGColor;
        _selectButton.layer.borderWidth = 1;
        _selectButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_selectButton setTitleColor:NAVGATION_BAR_COLOR forState:(UIControlStateNormal)];
    }
    return _selectButton;
}


- (FFDriveDetailInfoViewController *)detailController {
    if (!_detailController) {
        _detailController = [[FFDriveDetailInfoViewController alloc] init];
        _detailController.delegate = self;
    }
    return _detailController;
}


@end













