//
//  FFBusinessNoticeController.m
//  GameBox
//
//  Created by 燚 on 2018/6/26.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessNoticeController.h"
#import "FFBusinessModel.h"
#import "FFBusinessBuyModel.h"
#import "FFBusinessNoticeCell.h"

#define CELL_IDE @"FFBusinessNoticeCell"
#define Back_View_width kSCREEN_WIDTH * 0.9
#define Back_View_height kSCREEN_HEIGHT * 0.9

@interface FFBusinessNoticeController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIWindow *window;

/** 买家须知 */
@property (nonatomic, strong) NSArray *buyNotice;
/** 买家须知 */
@property (nonatomic, strong) NSArray *sellNotice;
/** 注意事项 */
@property (nonatomic, strong) NSArray *businessNotice;

@property (nonatomic, assign) FFNoticeType type;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImage;

@property (nonatomic, strong) UILabel *noticeHeader;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *closeButton;


@end

static FFBusinessNoticeController *controller = nil;
@implementation FFBusinessNoticeController

+ (FFBusinessNoticeController *)sharedController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (controller == nil) {
            controller = [[FFBusinessNoticeController alloc] init];
        }
    });
    return controller;
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backView];
}


+ (void)refreshNotice {
    [FFBusinessModel businessNotice:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            [self sharedController].buyNotice = CONTENT_DATA[@"buyer_notes"];
            [self sharedController].sellNotice = CONTENT_DATA[@"seller_notes"];
            [self sharedController].businessNotice = CONTENT_DATA[@"business_notice"];
            [FFBusinessBuyModel sharedModel].productAmountLimit = CONTENT_DATA[@"product_price_limit"];
        }
        syLog(@"notice ================= %@",content);
    }];
}


+ (void)showNoticeWithType:(FFNoticeType)type ClickButtonBLock:(ClickButtonBLock)block {
    [self sharedController].type = type;
    [self sharedController].block = block;
    if (type == FFNoticeTypeBuy) {
        [self sharedController].headerImage.image = [UIImage imageNamed:@"Business_header_notice_buy"];
    } else {
        [self sharedController].headerImage.image = [UIImage imageNamed:@"Business_header_noitce_sell"];
    }

    [[self sharedController].window makeKeyAndVisible];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (self.type == FFNoticeTypeBuy) ? self.buyNotice.count : self.sellNotice.count;
    } else {
        return self.businessNotice.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FFBusinessNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.contentLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.section == 0) {
        if (self.type == FFNoticeTypeBuy) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%ld.  %@",indexPath.row + 1,self.buyNotice[indexPath.row]];
        } else {
            cell.contentLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row + 1,self.sellNotice[indexPath.row]];
        }
    } else {
        cell.contentLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row + 1,self.businessNotice[indexPath.row]];
    }

    cell.contentLabel.textColor = [FFColorManager textColorLight];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 30;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Back_View_width, 40)];
    view.backgroundColor = [FFColorManager navigation_bar_white_color];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Back_View_width, 40)];
    label.text = (section == 1) ? @"  如遇以下情况,请警惕骗子 : " : (self.type == FFNoticeTypeBuy) ? @"  买家须知 : " : @"  卖家须知 :";
    [view addSubview:label];

    [view.layer addSublayer:[self creatLineWithFrame:CGRectMake(0, 0, Back_View_width, 1)]];
    return view;
}

#pragma mark - responds
- (void)respondsToSureButton {
//    @"BusinessProtocol";
    if (self.type == FFNoticeTypeBuy) {
        SAVEOBJECT_AT_USERDEFAULTS(@"1", @"BusinessBuyProtocol");
    } else {
        SAVEOBJECT_AT_USERDEFAULTS(@"1", @"BusinessProtocol");
    }

    if (self.block) {
        self.block();
    }

    [self.window resignKeyWindow];
    self.window = nil;
}

- (void)respondsToCloseButton {
    [self.window resignKeyWindow];
    self.window = nil;
}


#pragma mark - setter

#pragma mark - getter
- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _window.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
        _window.rootViewController = self;
    }
    return _window;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Back_View_width, Back_View_height)];
        _backView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
        _backView.backgroundColor = [FFColorManager navigation_bar_white_color];
        [_backView addSubview:self.noticeHeader];
        [_backView addSubview:self.closeButton];
        [_backView addSubview:self.tableView];
        [_backView addSubview:self.sureButton];
//        [_backView addSubview:self.footerView];
        _backView.layer.cornerRadius = 8;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, Back_View_height - 83, Back_View_width, 83)];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:self.sureButton];
    }
    return _footerView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sureButton.frame = CGRectMake(10, Back_View_height - 53, Back_View_width - 20, 44);
        [_sureButton setTitle:@"同意" forState:(UIControlStateNormal)];
        [_sureButton setBackgroundColor:[FFColorManager blue_dark]];
        [_sureButton addTarget:self action:@selector(respondsToSureButton) forControlEvents:(UIControlEventTouchUpInside)];
        _sureButton.layer.cornerRadius = 22;
        _sureButton.layer.masksToBounds = YES;
    }
    return _sureButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.noticeHeader.frame), Back_View_width, Back_View_height - 50 - CGRectGetMaxY(self.noticeHeader.frame)) style:(UITableViewStylePlain)];

        _tableView.dataSource = self;
        _tableView.delegate = self;

        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Back_View_height, 44)];

        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];

        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Back_View_width, Back_View_width * 0.215 + 44)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Back_View_width - 10, 44)];
        label.text = @"流程";
        label.font = [UIFont systemFontOfSize:16];

        [_headerView addSubview:label];
        [_headerView addSubview:self.headerImage];
//        [_headerView.layer addSublayer:[self creatLineWithFrame:CGRectMake(0, Back_View_width * 0.215 + 43.5, Back_View_width, 0.5)]];
    }
    return _headerView;
}

- (UIImageView *)headerImage {
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 44, Back_View_width - 32, (Back_View_width - 32) * 0.21)];
    }
    return _headerImage;
}

- (UILabel *)noticeHeader {
    if (!_noticeHeader) {
        _noticeHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Back_View_width, 44)];
        _noticeHeader.backgroundColor = [FFColorManager blue_dark];
        _noticeHeader.text = @"交易须知";
        _noticeHeader.font = [UIFont systemFontOfSize:17];
        _noticeHeader.textAlignment = NSTextAlignmentCenter;
        _noticeHeader.textColor = [FFColorManager navigation_bar_white_color];
    }
    return _noticeHeader;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_closeButton setTitle:@"关闭" forState:(UIControlStateNormal)];
        [_closeButton sizeToFit];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _closeButton.center = CGPointMake(Back_View_width - _closeButton.bounds.size.width, 22);
        [_closeButton addTarget:self action:@selector(respondsToCloseButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}




@end




