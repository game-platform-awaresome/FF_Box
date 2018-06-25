//
//  BusinessCustomerServiceViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/12.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessCustomerServiceViewController.h"
#import "FFBusinessModel.h"
#import "UINavigationBar+FFNavigationBar.h"
#import "BusinessCustomerCell.h"

#define CELL_IDE @"BusinessCustomerCell"

@interface FFBusinessCustomerServiceViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *showArray;

@end

@implementation FFBusinessCustomerServiceViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self naviTransParent];
    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_white_color]];
    self.navBarBGAlpha = @"0.0";
    self.navigationController.navigationBar.lineLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self refreshData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.lineLayer.backgroundColor = [FFColorManager view_separa_line_color].CGColor;
}

- (void)naviTransParent {
    UIView *barBackgroundView;// _UIBarBackground
    UIImageView *backgroundImageView;// UIImageView
    UIView *backgroundEffectView;// UIVisualEffectView
    if (@available(iOS 10.0, *)) {//
        barBackgroundView = [self.self.navigationController.navigationBar.subviews objectAtIndex:0];
        if (self.self.navigationController.navigationBar.subviews.count > 0) {
            for (UIView *view in self.self.navigationController.navigationBar.subviews) {
                view.alpha = 0;
            }
        }
        for (UIView *view in barBackgroundView.subviews) {
            view.alpha = 0;
        }
    } else {
        for (UIView *view in self.self.navigationController.navigationBar.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                barBackgroundView = view;
                barBackgroundView.alpha = 0;
            }
        }
        for (UIView *otherView in barBackgroundView.subviews) {
            if ([otherView isKindOfClass:NSClassFromString(@"UIImageView")]) {
                backgroundImageView = (UIImageView *)otherView;
                barBackgroundView.alpha = 0;
            }else if ([otherView isKindOfClass:NSClassFromString(@"_UIBackdropView")]) {
                backgroundEffectView = otherView;
                backgroundEffectView.alpha = 0;
            }
        }
    }
    barBackgroundView.alpha = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    [self.leftButton setImage:[FFImageManager General_back_white]];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}


- (void)refreshData {
    [self startWaiting];
    [FFBusinessModel customerWithCompletion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            if ([content[@"data"] isKindOfClass:[NSArray class]]) {
                self.showArray = content[@"data"];
            } else {
                self.showArray = nil;
            }
        } else {
            [self respondsToLeftButton];
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
        [self.tableView reloadData];
        syLog(@"customer === %@",content);
    }];
}

#pragma mark - table view data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    cell.qq = self.showArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *urlStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",self.showArray[indexPath.row]];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    } else {
        [UIAlertController showAlertMessage:@"没有安装QQ" dismissTime:0.7 dismissBlock:nil];
    }
}

#pragma mark - getter
- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 207)];
        _headerView.image = [UIImage imageNamed:@"Business_customer_header"];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}



@end










