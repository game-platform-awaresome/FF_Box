//
//  FFBusinessViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/8.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessViewController.h"
#import "FFBusinessModel.h"
#import "FFBusinessTableViewCell.h"
#import "FFBusinessHeaderView.h"
#import "YBPopupMenu.h"
#import "FFBusinessSearchViewController.h"
#import "FFBusinessNoticeController.h"

#define CELL_IDE @"FFBusinessTableViewCell"
#define Button_tag 10086
#define Button_Height 30
#define Select_Heigth 44
#define Menu_tag 13374

@interface FFBusinessViewController () <YBPopupMenuDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIBarButtonItem *userCenter;
@property (nonatomic, strong) UIBarButtonItem *searchButton;

@property (nonatomic, strong) FFBusinessHeaderView *headerView;

@property (nonatomic, strong) UIView *sectionButtonView;
@property (nonatomic, strong) UIView *sectionSelectView;

@property (nonatomic, assign) FFBusinessOrderType orderType;
@property (nonatomic, assign) FFBusinessSystemType systemType;
@property (nonatomic, assign) FFBusinessOrderMethod orderMethod;
@property (nonatomic, strong) NSString *gameName;


@property (nonatomic, strong) UIButton *sortButton;
@property (nonatomic, strong) UIButton *systemButton;

@property (nonatomic, strong) UILabel *selectGameLabel;
@property (nonatomic, strong) UIButton *selectGameButton;
@property (nonatomic, strong) UITextField *selectGameTextField;

@property (nonatomic, strong) FFBusinessSearchViewController *searchController;

@property (nonatomic, strong) UIButton *cancelInputeButton;


@end

static FFBusinessViewController *_controller = nil;

@implementation FFBusinessViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [FFBusinessModel sharedModel];
    [self setUserCenterButtonTitle];
    self.navBarBGAlpha = @"1.0";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _controller = self;
    [self customNavLine];
}

- (void)initDataSource {
    [super initDataSource];
    _systemType = FFBusinessSystemTypeNull;
    _orderType = FFBusinessOrderTypeTime;
    _orderMethod = FFBusinessOrderMethodDescending;
    _gameName = @"";
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"账号交易";
    self.navigationItem.rightBarButtonItem = self.userCenter;
//    self.navigationItem.leftBarButtonItem = self.searchButton;
    [self resetTableView];
    [self.view addSubview:self.tableView];
}

- (void)refreshData {
    //刷新须知
    [FFBusinessNoticeController refreshNotice];
    Reset_page;
    [self startWaiting];
    [FFBusinessModel productListWithGameName:self.gameName Page:New_page System:self.systemType OrderType:self.orderType OrderMethod:self.orderMethod Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        syLog(@"product === %@",content);
        if (success) {
            self.showArray = [CONTENT_DATA[@"list"] mutableCopy];
        }
        [self.tableView reloadData];
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];

        if (self.showArray.count == 0) {
            [UIAlertController showAlertMessage:@"暂时没有找到商品\n请稍后尝试" dismissTime:0.7 dismissBlock:nil];
        }
    }];
}

- (void)loadMoreData {
    [self startWaiting];
    [FFBusinessModel productListWithGameName:self.gameName Page:Next_page System:self.systemType OrderType:self.orderType OrderMethod:(FFBusinessOrderMethodDescending) Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            NSArray *array = CONTENT_DATA[@"list"];
            if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.refreshFooter endRefreshing];
            } else {
                [self.refreshFooter endRefreshingWithNoMoreData];
            }
        } else {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    }];
}

- (void)begainRefresData {
    [self refreshData];
}

#pragma mark - table view data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.backgroundColor = [FFColorManager navigation_bar_white_color];
    cell.dict = self.showArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (![FFBusinessModel uid]) {
        pushViewController(@"FFBusinessLoginViewController");
        return;
    }

//    if (OBJECT_FOR_USERDEFAULTS(@"BusinessBuyProtocol")) {
        NSDictionary *dict = self.showArray[indexPath.row];
        Class FFGameViewController = NSClassFromString(@"FFBusinessCommodityViewController");
        SEL selector = NSSelectorFromString(@"sharedController");
        if ([FFGameViewController respondsToSelector:selector]) {
            IMP imp = [FFGameViewController methodForSelector:selector];
            UIViewController *(*func)(void) = (void *)imp;
            UIViewController *vc = func();
            if (vc) {
                NSString *pid = (dict[@"id"]) ? dict[@"id"] : dict[@"gid"];
                [vc setValue:pid forKey:@"pid"];
                [self pushViewController:vc];
            } else {
                syLog(@"\n ! %s \n present error :  %s not exist \n ! \n",__func__,sel_getName(selector));
            }
        } else {
            syLog(@"\n ! %s \n present error :  %s not exist \n ! \n",__func__,sel_getName(selector));
        }
//    } else {
//        [FFBusinessNoticeController showNoticeWithType:FFNoticeTypeBuy];
//    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return Button_Height + Select_Heigth;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, Button_Height + Select_Heigth)];
    view.backgroundColor = [FFColorManager navigation_bar_white_color];

    [view addSubview:self.sectionButtonView];
    [view addSubview:self.sectionSelectView];
    return view;
}



#pragma mark - responds
- (void)respondsToLeftButton {
    if (currentUser() -> uid) {
        pushViewController(@"FFBusinessUserCenterViewController");
    } else  {
        pushViewController(@"FFBusinessLoginViewController");
    }
}

- (void)respondsToRightButton {
    pushViewController(@"FFBusinessSearchViewController");
}

- (void)respondsToButton:(UIButton *)sender {
    clickButton(sender.tag - Button_tag);
}

- (void)respondstoCancelInputButton {
    [self.selectGameTextField resignFirstResponder];
    [self.cancelInputeButton removeFromSuperview];
}

void clickButton(long idx) {
    syLog(@"点击 按钮 == %ld",idx);
    [_controller pushViewControllerWith:idx];
}

- (void)pushViewControllerWith:(NSUInteger)idx {
    switch (idx) {
        case 0: {pushViewController(@"FFBusinessNoticeViewController");} break;
        case 1: {
            if ([FFBusinessModel uid]) {
                pushViewController(@"FFBusinessSelectAccountViewController");
            } else  {
                pushViewController(@"FFBusinessLoginViewController");
            }
        } break;
        case 2: {
            if ([FFBusinessModel uid]) {
                pushViewController(@"FFBusinessRecordViewController");
            } else  {
                pushViewController(@"FFBusinessLoginViewController");
            }
        } break;
        case 3: {pushViewController(@"FFBusinessCustomerServiceViewController");} break;
        default: break;
    }
}

/** 排序选择 */
- (void)respondsToSortButton:(UIButton *)sender {
    YBPopupMenu *menu = [YBPopupMenu showRelyOnView:sender titles:@[@"最新发布",@"价格升序",@"价格降序"] icons:nil menuWidth:sender.bounds.size.width + 10 delegate:self];
    menu.tag = Menu_tag + 0;
    menu.fontSize = 10.f;
    menu.type = YBPopupMenuTypeDark;
    menu.textColor = [UIColor whiteColor];
}

- (void)respondsToSystemButton:(UIButton *)sender {
    YBPopupMenu *menu = [YBPopupMenu showRelyOnView:sender titles:@[@"选择系统",@"Android",@"iOS",@"双平台"] icons:nil menuWidth:sender.bounds.size.width + 10 delegate:self];
    menu.tag = Menu_tag + 1;
    menu.fontSize = 10.f;
    menu.type = YBPopupMenuTypeDark;
    menu.textColor = [UIColor whiteColor];
}

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)menu {
    if (menu.tag == Menu_tag + 0) {
        switch (index) {
            case 0: {
                [self.sortButton setTitle:@"最新发布" forState:(UIControlStateNormal)];
                self.orderMethod = FFBusinessOrderMethodDescending;
                self.orderType = FFBusinessOrderTypeTime;
                break;
            }
            case 1: {
                [self.sortButton setTitle:@"价格升序" forState:(UIControlStateNormal)];
                self.orderMethod = FFBusinessOrderMethodAscending;
                self.orderType = FFBusinessOrderTypePrice;
                break;
            }
            case 2: {
                [self.sortButton setTitle:@"价格降序" forState:(UIControlStateNormal)];
                self.orderMethod = FFBusinessOrderMethodDescending;
                self.orderType = FFBusinessOrderTypePrice;
                break;
            }
            default:
                break;
        }
    } else if (menu.tag == Menu_tag + 1) {
        switch (index) {
            case 0: {
                [self.systemButton setTitle:@"选择系统" forState:(UIControlStateNormal)];
                self.systemType = FFBusinessSystemTypeNull;
                break;
            }
            case 1: {
                [self.systemButton setTitle:@"Android" forState:(UIControlStateNormal)];
                self.systemType = FFBusinessSystemTypeAndroid;
                break;
            }
            case 2: {
                [self.systemButton setTitle:@"iOS" forState:(UIControlStateNormal)];
                self.systemType = FFBusinessSystemTypeIOS;
                break;
            }
            case 3: {
                [self.systemButton setTitle:@"双平台" forState:(UIControlStateNormal)];
                self.systemType = FFBusinessSystemTypeAll;
                break;
            }
            default:
                break;
        }
    }
    [self begainRefresData];
}

- (void)respondsToSelectGameButton {
    syLog(@"选择游戏");
//    pushViewController(@"FFBusinessSearchViewController");
//    [self pushViewController:self.searchController];


}

#pragma mark - setter
- (void)setUserCenterButtonTitle {
    if (currentUser() -> uid) {
        NSMutableString *username = [FFBusinessModel username].mutableCopy;
        [username replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        [self.userCenter setTitle:username];
    } else {
        [self.userCenter setTitle:@"登录"];
    }
}

- (void)setOrderType:(FFBusinessOrderType)orderType {
    if (_orderType != orderType) {
        _orderType = orderType;
    }
}

- (void)setSystemType:(FFBusinessSystemType)systemType {
    if (_systemType != systemType) {
        _systemType = systemType;
    }
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.cancelInputeButton removeFromSuperview];
    self.gameName = textField.text;
    [self begainRefresData];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    syLog(@"开始输入 ");
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    syLog(@"结束输入 ");
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    syLog(@"开始输入 2222");
    [self.view addSubview:self.cancelInputeButton];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    syLog(@"结束输入 22222");

    return YES;
}

#pragma mark - getter
- (NSString *)gameName {
    if (!_gameName) {
        _gameName = @"";
    }
    return _gameName;
}
- (UIBarButtonItem *)userCenter {
    if (!_userCenter) {
        _userCenter = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
    }
    return _userCenter;
}

- (UIBarButtonItem *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIBarButtonItem alloc] initWithImage:[FFImageManager Home_search_image] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];
    }
    return _searchButton;
}

- (FFBusinessHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFBusinessHeaderView alloc] init];
    }
    return _headerView;
}

- (UIView *)sectionButtonView {
    if (!_sectionButtonView) {
        _sectionButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, Button_Height)];
        NSArray *titleArray = @[@"交易须知",@"我要卖号",@"交易记录",@"联系客服"];
        for (int i = 0 ; i < 4; i++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.tag = Button_tag + i;
            [button addTarget:self action:@selector(respondsToButton:) forControlEvents:(UIControlEventTouchUpInside)];
            button.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 4 - 5, Button_Height);
            button.frame = CGRectMake(kSCREEN_WIDTH / 4 * i, 0, kSCREEN_WIDTH / 4, Button_Height);
            [button setTitle:titleArray[i] forState:(UIControlStateNormal)];
            [button setTitleColor:[FFColorManager textColorMiddle] forState:(UIControlStateNormal)];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_sectionButtonView addSubview:button];

            CALayer *layer = [[CALayer alloc] init];
            layer.frame = CGRectMake(0, Button_Height - 0.5, kSCREEN_WIDTH, 0.5);
            layer.backgroundColor = [FFColorManager view_separa_line_color].CGColor;
            [_sectionButtonView.layer addSublayer:layer];
        }
    }
    return _sectionButtonView;
}

- (UIView *)sectionSelectView {
    if (!_sectionSelectView) {
        _sectionSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, Button_Height, kSCREEN_WIDTH, Select_Heigth)];


        [_sectionSelectView addSubview:self.sortButton];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Business_SDK_arrow"]];
        imageView.center = CGPointMake(CGRectGetMaxX(self.sortButton.frame) + imageView.bounds.size.width / 2 + 2, self.sortButton.center.y);
        [_sectionSelectView addSubview:imageView];

        [_sectionSelectView addSubview:self.systemButton];
        UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Business_SDK_arrow"]];
        imageView1.center = CGPointMake(CGRectGetMaxX(self.systemButton.frame) + imageView.bounds.size.width / 2 + 2, self.systemButton.center.y);
        [_sectionSelectView addSubview:imageView1];

        [_sectionSelectView addSubview:self.selectGameLabel];
        [_sectionSelectView addSubview:self.selectGameTextField];

        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, Select_Heigth - 0.5, kSCREEN_WIDTH, 0.5);
        layer.backgroundColor = [FFColorManager view_separa_line_color].CGColor;
        [_sectionSelectView.layer addSublayer:layer];
    }
    return _sectionSelectView;
}


- (void)resetTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT - kTABBAR_HEIGHT) style:(UITableViewStylePlain)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [FFColorManager tableview_background_color];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.mj_header = self.refreshHeader;
    self.tableView.mj_footer = self.refreshFooter;
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
//    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
}

- (UIButton *)sortButton {
    if (!_sortButton) {
        _sortButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_sortButton setTitle:@"按时间排序" forState:(UIControlStateNormal)];
        _sortButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sortButton setTitleColor:[FFColorManager textColorLight] forState:(UIControlStateNormal)];
        [_sortButton sizeToFit];
        _sortButton.frame = CGRectMake(10, 0, _sortButton.bounds.size.width, Select_Heigth);
        [_sortButton addTarget:self action:@selector(respondsToSortButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sortButton;
}

- (UIButton *)systemButton {
    if (!_systemButton) {
        _systemButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_systemButton setTitle:@"选择系统" forState:(UIControlStateNormal)];
        _systemButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_systemButton setTitleColor:[FFColorManager textColorLight] forState:(UIControlStateNormal)];
        [_systemButton sizeToFit];
        _systemButton.frame = CGRectMake(CGRectGetMaxX(self.sortButton.frame) + 20, 0, _systemButton.bounds.size.width, Select_Heigth);
        [_systemButton addTarget:self action:@selector(respondsToSystemButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _systemButton;
}

- (UILabel *)selectGameLabel {
    if (!_selectGameLabel) {
        _selectGameLabel = [[UILabel alloc] init];
        _selectGameLabel.text = @"搜索 : ";
        _selectGameLabel.font = [UIFont systemFontOfSize:14];
        _selectGameLabel.textColor = [FFColorManager textColorLight];
        [_selectGameLabel sizeToFit];
        _selectGameLabel.frame = CGRectMake(CGRectGetMaxX(self.systemButton.frame) + 20, 0, _selectGameLabel.bounds.size.width, Select_Heigth);
    }
    return _selectGameLabel;
}

- (UIButton *)selectGameButton {
    if (!_selectGameButton) {
        _selectGameButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_selectGameButton setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];
        _selectGameButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_selectGameButton setTitle:@"输入" forState:(UIControlStateNormal)];
        [_selectGameButton sizeToFit];
        _selectGameButton.frame = CGRectMake(CGRectGetMaxX(self.selectGameLabel.frame), 0, _selectGameButton.bounds.size.width, Select_Heigth);
        [_selectGameButton addTarget:self action:@selector(respondsToSelectGameButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _selectGameButton;
}

- (UITextField *)selectGameTextField {
    if (!_selectGameTextField) {
        _selectGameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectGameLabel.frame), 0, kSCREEN_WIDTH - CGRectGetMaxX(self.selectGameLabel.frame), Select_Heigth)];
        _selectGameTextField.placeholder = @"输入游戏名称";
        _selectGameTextField.delegate = self;
        _selectGameTextField.returnKeyType = UIReturnKeySearch;
        _selectGameTextField.font = [UIFont systemFontOfSize:14];
        _selectGameTextField.tintColor = [FFColorManager textColorLight];
        _selectGameTextField.clearButtonMode = UITextFieldViewModeAlways;
    }
    return _selectGameTextField;
}

- (UIButton *)cancelInputeButton {
    if (!_cancelInputeButton) {
        _cancelInputeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _cancelInputeButton.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [_cancelInputeButton addTarget:self action:@selector(respondstoCancelInputButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelInputeButton;
}


- (FFBusinessSearchViewController *)searchController {
    if (!_searchController) {
        _searchController = [[FFBusinessSearchViewController alloc] init];
    }
    return _searchController;
}







@end










