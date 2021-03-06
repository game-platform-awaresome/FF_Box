//
//  FFBusinessSelectAccountViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/12.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessSelectAccountViewController.h"
#import "FFBusinessSellProductController.h"
#import "FFBusinessModel.h"
#import <UIImageView+WebCache.h>
#import "FFBusinessSDKCell.h"
#import "FFBusinessNoticeController.h"

#define ListModel()
#define CELL_IDE @"FFBusinessSDKCell"
#define Section_button_tag 199425
#define Section_image_tag 12374
#define Section_cancel_tag 4452

@interface FFBusinessSDKListModel : NSObject

@property (nonatomic, strong) NSString *SDKUid;
@property (nonatomic, strong) NSString *SDKUsername;
@property (nonatomic, assign) BOOL isSelling;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSArray *gameList;

@property (nonatomic, strong) NSMutableArray<FFBusinessSDKListModel *> *listArray;

@property (nonatomic, assign) BOOL isAnimation;;


- (void)setListWithArray:(NSArray *)array;



@end


@interface FFBusinessSelectAccountViewController ()

@property (nonatomic, strong) NSString *alipayAccount;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *headerTitle;

@property (nonatomic, strong) UIView *selectFooterView;


@property (nonatomic, strong) FFBusinessSDKListModel *model;



@end

@implementation FFBusinessSelectAccountViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataSource {
    [super initDataSource];
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"选择账号";
    [self.leftButton setImage:[FFImageManager General_back_black]];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    self.tableView.mj_footer = nil;
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
    self.tableView.tableHeaderView = self.headerView;
//    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
//    footerview.backgroundColor = [FFColorManager navigation_bar_white_color];
    self.tableView.tableFooterView = self.selectFooterView;
    [self.rightButton setTitle:@"关联账号"];
    self.navigationItem.rightBarButtonItem = self.rightButton;
}

- (void)begainRefresData {

}

- (void)refreshData {
    [self startWaiting];
    [FFBusinessModel linkSDKAccountListCompletion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        syLog(@"my accout --- %@",content);
        if (success) {
            self.alipayAccount = CONTENT_DATA[@"alipay_acount"];
            [self.model setListWithArray:CONTENT_DATA[@"list"]];
        }

        [self.refreshHeader endRefreshing];
        [self.tableView reloadData];
    }];
}

#pragma mark - table view data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.listArray[section].gameList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFBusinessSDKCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.dict = self.model.listArray[indexPath.section].gameList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.listArray[indexPath.section].isOpen) {
        return 56;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self.alipayAccount isEqualToString:@"还没有绑定支付宝账号"] || [self.alipayAccount isEqualToString:@"关联的支付宝账号 : "]) {
        [UIAlertController showAlertMessage:@"请先绑定支付宝" dismissTime:0.7 dismissBlock:^{
            pushViewController(@"FFBusinessBindAlipayViewController");
        }];
    } else if (self.model.listArray[indexPath.section].isSelling) {
        [UIAlertController showAlertMessage:@"账号交易中" dismissTime:0.7 dismissBlock:nil];
    } else {
//        if (OBJECT_FOR_USERDEFAULTS(@"BusinessProtocol")) {
//            NSDictionary *dict = self.model.listArray[indexPath.section].gameList[indexPath.row];
//            FFBusinessProductController *controller = [FFBusinessProductController initwithGameName:[dict[@"game_name"] copy] Account:self.model.listArray[indexPath.section].SDKUsername];
//            controller.appid = dict[@"appid"];
//            controller.systemArray = dict[@"system"];
//            [self pushViewController:controller];
//        } else {
        WeakSelf;
        [FFBusinessNoticeController showNoticeWithType:FFNoticeTypeSell ClickButtonBLock:^{
            NSDictionary *dict = self.model.listArray[indexPath.section].gameList[indexPath.row];
            FFBusinessProductController *controller = [FFBusinessProductController initwithGameName:[dict[@"game_name"] copy] Account:self.model.listArray[indexPath.section].SDKUsername];
            controller.appid = dict[@"appid"];
            controller.systemArray = dict[@"system"];
            [weakSelf pushViewController:controller];
        }];
//        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    view.backgroundColor = [FFColorManager navigation_bar_white_color];

    UIButton *accountButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [accountButton setImage:[UIImage imageNamed:@"Business_point"] forState:(UIControlStateNormal)];
    [accountButton setTitle:[NSString stringWithFormat:@"  账号 : %@",self.model.listArray[section].SDKUsername] forState:(UIControlStateNormal)];
    [accountButton setTitleColor:[FFColorManager textColorMiddle] forState:(UIControlStateNormal)];
    accountButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [accountButton sizeToFit];
    accountButton.center = CGPointMake(16 + accountButton.bounds.size.width / 2, 22);
    accountButton.tag = section + Section_button_tag;
    [accountButton addTarget:self action:@selector(respondsToSectionButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:accountButton];

    UIImageView *sectionImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Business_SDK_arrow"]];
    sectionImage.center = CGPointMake(CGRectGetMaxX(accountButton.frame) + sectionImage.bounds.size.width / 2 + 4, 22);
    sectionImage.tag = Section_image_tag + section;
    [view addSubview:sectionImage];


    UIButton *cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitle:[NSString stringWithFormat:@"%@",self.model.listArray[section].isSelling ? @"交易中" : @"取消关联"] forState:(UIControlStateNormal)];
    cancelButton.tag = Section_cancel_tag + section;
    [cancelButton addTarget:self action:@selector(respondsToCancelButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [cancelButton sizeToFit];
    [cancelButton setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];
    CGRect bounds = cancelButton.bounds;
    bounds.size.height = 44;
    cancelButton.bounds = bounds;
    cancelButton.center = CGPointMake(kSCREEN_WIDTH - 10 - bounds.size.width / 2, 22);
    [view addSubview:cancelButton];

    [view.layer addSublayer:[self creatLineWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)]];
//    [view.layer addSublayer:[self creatLineWithFrame:CGRectMake(0, 43, kSCREEN_WIDTH, 1)]];
    return view;
}


#pragma mark - responds
- (void)respondsToHeaderButton {

}

- (void)respondsToRightButton {
    pushViewController(@"FFBusinessLinkSDKViewController");
}

- (void)respondsToSectionButton:(UIButton *)sender {
    NSUInteger section = sender.tag - Section_button_tag;
    if (self.model.listArray[section].isAnimation) return;
    self.model.listArray[section].isAnimation = YES;
    [self.tableView beginUpdates];
    UIButton *imageView = [self.view viewWithTag:Section_image_tag + section];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.transform = self.model.listArray[section].isOpen ? CGAffineTransformMakeRotation(-M_PI / 2) : CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.model.listArray[section].isAnimation = NO;
    }];
    if (self.model.listArray[section].isOpen) {
        self.model.listArray[section].isOpen = NO;
    } else {
        self.model.listArray[section].isOpen = YES;
    }
    [self.tableView endUpdates];
}

- (void)respondsToCancelButton:(UIButton *)sender {
    NSUInteger section = sender.tag - Section_cancel_tag;
    if ([sender.titleLabel.text isEqualToString:@"取消关联"]) {
        [UIAlertController showAlertControllerWithViewController:self alertControllerStyle:(UIAlertControllerStyleAlert) title: nil message:@"确定取消关联吗" cancelButtonTitle:@"取消" destructiveButtonTitle: nil CallBackBlock:^(NSInteger btnIndex) {
            if (btnIndex == 1) {
                [self startWaiting];
                [FFBusinessModel cancelLinkSDKAccountWithSDKAccount:self.model.listArray[section].SDKUsername Completion:^(NSDictionary * _Nonnull content, BOOL success) {
                    [self stopWaiting];
                    if (success) {
                        [self refreshData];
                        [UIAlertController showAlertMessage:@"取消成功" dismissTime:0.7 dismissBlock:nil];
                    } else {
                        [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
                    }
                }];
            }
        } otherButtonTitles:@"确定", nil];
    } else {
        syLog(@"交易中");
    }
}

- (void)respondsToTap:(UITapGestureRecognizer *)sender {
    pushViewController(@"FFBusinessBindAlipayViewController");
}


#pragma mark - setter
- (void)setAlipayAccount:(NSString *)alipayAccount {
    if ([alipayAccount isKindOfClass:[NSString class]] && alipayAccount.length > 1) {
        _alipayAccount = [NSString stringWithFormat:@"关联的支付宝账号 : %@",[NSString stringWithFormat:@"%@********%@",[alipayAccount substringWithRange:NSMakeRange(0, 1)],[alipayAccount substringWithRange:NSMakeRange(alipayAccount.length - 1, 1)]]];
    } else {
        _alipayAccount = @"还没有绑定支付宝账号";
    }
    [self.headerTitle setTitle:_alipayAccount forState:(UIControlStateNormal)];
}

#pragma mark - getter
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 90)];
        _headerView.backgroundColor = [FFColorManager navigation_bar_white_color];
        [_headerView addSubview:self.headerTitle];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 60, kSCREEN_WIDTH - 32, 30)];
        label.text = @"绑定的交易账号";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [FFColorManager textColorDark];

        [_headerView addSubview:label];
    }
    return _headerView;
}

- (UIButton *)headerTitle {
    if (!_headerTitle) {
        _headerTitle = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _headerTitle.frame = CGRectMake(4, 0, kSCREEN_WIDTH, 44);
        [_headerTitle setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];
        _headerTitle.titleLabel.font = [UIFont systemFontOfSize:16];
        [_headerTitle addTarget:self action:@selector(respondsToHeaderButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_headerTitle setTitle:@"关联的支付宝账号 : " forState:(UIControlStateNormal)];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_headerTitle addGestureRecognizer:tap];
    }
    return _headerTitle;
}

- (FFBusinessSDKListModel *)model {
    if (!_model) {
        _model = [[FFBusinessSDKListModel alloc] init];
    }
    return _model;
}

- (UIView *)selectFooterView {
    if (!_selectFooterView) {
        _selectFooterView = [[UIView alloc] init];
        _selectFooterView.backgroundColor = [FFColorManager navigation_bar_white_color];
        NSArray *remindArray = @[@"1.只能出售有充值金额的游戏.",
                                 @"2.交易之前,请先关联支付宝账号用作收款",
                                 @"3.关联游戏账号后才可以出售",
                                 @"4.提交出售信息后,账号将会被冻结."];
        int i = 0;
        for (NSString *obj in remindArray) {
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30 * i++, kSCREEN_WIDTH, 30)];
            label1.textColor = [FFColorManager textColorLight];
            label1.text = obj;
            label1.font = [UIFont systemFontOfSize:13];
            [_selectFooterView addSubview:label1];
        }
        _selectFooterView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 30 * remindArray.count);
        [_selectFooterView.layer addSublayer:[self creatLineWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)]];
    }
    return _selectFooterView;
}



@end



@implementation FFBusinessSDKListModel

- (void)setListWithArray:(NSArray *)array {
    if ([array isKindOfClass:[NSArray class]]) {
        _listArray = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dict in array) {
            FFBusinessSDKListModel *model = [FFBusinessSDKListModel new];
            model.SDKUid = dict[@"sdk_uid"];
            model.SDKUsername = dict[@"sdk_username"];
            model.isSelling = ((NSString *)dict[@"selling"]).boolValue;
            model.gameList = dict[@"game_list"];
            model.isOpen = YES;
            [_listArray addObject:model];
        }
    }
}

- (void)setSDKUid:(NSString *)SDKUid {
    _SDKUid = [NSString stringWithFormat:@"%@",SDKUid];
}

- (void)setSDKUsername:(NSString *)SDKUsername {
    _SDKUsername = [NSString stringWithFormat:@"%@",SDKUsername];
}

- (void)setGameList:(NSArray *)gameList {
    if ([gameList isKindOfClass:[NSArray class]]) {
        _gameList = gameList;
    } else {
        _gameList = nil;
    }
}



#pragma mark - getter




@end





