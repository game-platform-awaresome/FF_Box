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
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    footerview.backgroundColor = [FFColorManager navigation_bar_white_color];
    self.tableView.tableFooterView = footerview;
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
    NSDictionary *dict = self.model.listArray[indexPath.section].gameList[indexPath.row];
    FFBusinessProductController *controller = [FFBusinessProductController initwithGameName:[dict[@"game_name"] copy] Account:self.model.listArray[indexPath.section].SDKUsername];
    [self pushViewController:controller];
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
    }];
    self.model.listArray[section].isOpen = !self.model.listArray[section].isOpen;
    [self.tableView endUpdates];
    self.model.listArray[section].isAnimation = NO;

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


#pragma mark - setter
- (void)setAlipayAccount:(NSString *)alipayAccount {
    if ([alipayAccount isKindOfClass:[NSString class]] && alipayAccount.length > 1) {
        _alipayAccount = alipayAccount;
    } else {
        _alipayAccount = @"还没有绑定支付宝账号";
    }
    [self.headerTitle setTitle:_alipayAccount forState:(UIControlStateNormal)];
}

#pragma mark - getter
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
        _headerView.backgroundColor = [FFColorManager navigation_bar_white_color];
        [_headerView addSubview:self.headerTitle];
//        [_headerView.layer addSublayer:[self creatLineWithFrame:CGRectMake(0, 43, kSCREEN_WIDTH, 1)]];
    }
    return _headerView;
}

- (UIButton *)headerTitle {
    if (!_headerTitle) {
        _headerTitle = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _headerTitle.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 44);
        [_headerTitle setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];
        _headerTitle.titleLabel.font = [UIFont systemFontOfSize:16];
        [_headerTitle addTarget:self action:@selector(respondsToHeaderButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_headerTitle setTitle:@"..." forState:(UIControlStateNormal)];
    }
    return _headerTitle;
}

- (FFBusinessSDKListModel *)model {
    if (!_model) {
        _model = [[FFBusinessSDKListModel alloc] init];
    }
    return _model;
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





