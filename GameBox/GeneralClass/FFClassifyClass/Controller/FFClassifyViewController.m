//
//  FFClassifyViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/19.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFClassifyViewController.h"
#import "FFClassifyDetailViewController.h"
#import "FFClassifyTableCell.h"
#import <UIButton+WebCache.h>
#import "FFSearchController.h"


#define BTNTAG 1700
#define SECTIONTAG 2700
#define CELL_IDE @"FFClassifyTableCell"

@interface FFClassifyViewController () <FFClassifyTableCellDelegate>

/** classify array */
@property (nonatomic, strong) NSMutableArray *classifyArray;

/** header veiw */
@property (nonatomic, strong) UIView *headerView;
/** search view */
@property (nonatomic, strong) UIView *searchView;
/** search back view */
@property (nonatomic, strong) UIView *searchBackView;
/** search title button */
@property (nonatomic, strong) UIButton *searchTitleButton;
/** classify button view */
@property (nonatomic, strong) UIView *classifyButtonView;
/** classify button array */
@property (nonatomic, strong) NSMutableArray<UIView *> *classifyButtonArray;


/** detail view controller */
@property (nonatomic, strong) FFClassifyDetailViewController *detailViewController;


@end


@implementation FFClassifyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBGAlpha = @"1.0";
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"分类";
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
    self.tableView.tableHeaderView = self.headerView;


//    [self.leftButton setImage:[FFImageManager General_back_black]];
//    [self.leftButton setTitle:@"游戏首页"];
//    UIBarButtonItem *lefBar = [[UIBarButtonItem alloc] initWithTitle:@"游戏首页" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
//
//    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [button setTitle:@" 游戏首页" forState:(UIControlStateNormal)];
//    [button setTitleColor:[FFColorManager navigation_bar_black_color] forState:(UIControlStateNormal)];
//    [button setImage:[FFImageManager General_back_black] forState:(UIControlStateNormal)];
//    button.titleLabel.font = [UIFont systemFontOfSize:16];
//    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    [barbutton setTarget:self];
//    [barbutton setAction:@selector(respondsToLeftButton)];
//    self.navigationItem.leftBarButtonItem = barbutton;
//    self.navigationItem.leftBarButtonItems = @[self.leftButton,lefBar];
//
//    @property(nonatomic,retain) UIImage *backIndicatorImage;
//    @property(nonatomic,retain) UIImage *backIndicatorTransitionMaskImage;
//
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem alloc] initwith

}

- (void)initDataSource {
    BOX_REGISTER_CELL;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - responds
- (void)respondsToLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToSearchButton {
    FFSearchController *searchVC = [[FFSearchController alloc] init];
    searchVC.ServerType = self.gameServersType;
    self.hidesBottomBarWhenPushed = YES;
    [self pushViewController:searchVC];
}


#pragma amrk - method
- (void)refreshData {
    self.currentPage = 1;
    [self startWaiting];
    [FFGameModel gameClassifyListWithPage:New_page ServerType:self.gameServersType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        [self.tableView.mj_header endRefreshing];
        NSLog(@"classify === %@",content);
        if (success) {
            self.classifyArray = [content[@"data"][@"class"] mutableCopy];
            NSArray *array = content[@"data"][@"classData"];
            self.showArray = [NSMutableArray array];
            for (NSDictionary *obj in array) {
                NSArray *list = obj[@"list"];
                if (list.count != 0 && list != nil) {
                    [self.showArray addObject:obj];
                }
            }
            [self.tableView reloadData];
        } else {
            self.classifyArray = nil;
            self.showArray = nil;
        }

        if (self.showArray && self.showArray.count > 0) {
            self.tableView.backgroundView = nil;
        } else {
            self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

//        if (self.classifyArray.count > 0 && self.showArray.count > 0) {
//            self.tableView.tableHeaderView = self.headerView;
//        } else {
//            self.tableView.tableHeaderView = nil;
//        }
    }];
}


#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFClassifyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.delegate = self;
    cell.array = self.showArray[indexPath.section][@"list"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    NSString *string = self.showArray[section][@"className"];
    label.text = [NSString stringWithFormat:@"     %@",string];

    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame  = CGRectMake(kSCREEN_WIDTH - 75, 5, 60, 20);
    [button setTitle:@"更多>" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor grayColor] forState:(UIControlStateHighlighted)];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.tag = SECTIONTAG + section;
    [button addTarget:self action:@selector(respondstoSectionBtn:) forControlEvents:(UIControlEventTouchUpInside)];

    [view addSubview:label];
    [view addSubview:button];

    CALayer *line = [[CALayer alloc] init];
    line.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0.5);
    line.backgroundColor = [FFColorManager text_separa_line_color].CGColor;
    [view.layer addSublayer:line];


    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - cell delegate
- (void)FFClassifyTableCell:(FFClassifyTableCell *)cell clickGame:(NSDictionary *)dict {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    id vc = [NSClassFromString(@"FFGameViewController") performSelector:@selector(sharedController)];
#pragma clang diagnostic pop
    if (vc) {
        [vc setValue:dict[@"id"] ? dict[@"id"] : dict[@"gid"] forKey:@"gid"];
        [self pushViewController:vc];
    }
}

#pragma mark - respons
/** 按钮响应事件 */
- (void)respondsToBtn:(UIButton *)sender {
    self.detailViewController.dict = self.classifyArray[sender.tag - BTNTAG];
    [self pushViewController:self.detailViewController];
}

/** section按钮点击事件 */
- (void)respondstoSectionBtn:(UIButton *)button {
    syLog(@"%s",__func__);
    NSString *classifyId = self.showArray[button.tag - SECTIONTAG][@"list"][0][@"tid"];
    NSDictionary *dict = @{@"id":classifyId,@"name":self.showArray[button.tag - SECTIONTAG][@"className"]};
    self.detailViewController.dict = dict;
    [self pushViewController:self.detailViewController];
}


#pragma mark - setter
- (void)setClassifyArray:(NSMutableArray *)classifyArray {
    if (classifyArray) {
        _classifyArray = classifyArray;

        if (_classifyButtonArray.count) {
            for (UIView *view in _classifyButtonArray) {
                [view removeFromSuperview];
            }
            [_classifyButtonArray removeAllObjects];
        } else {
            _classifyButtonArray = [NSMutableArray arrayWithCapacity:_classifyArray.count];
        }

        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:_classifyArray.count];
        for (NSDictionary *obj in _classifyArray) {
            NSString *string = obj[@"name"];
            [titleArray addObject:string];
        }

        CGFloat height = titleArray.count / 4.f;
        NSInteger height1 = height;

        if (height > height1) {
            height1++;
        }

        self.classifyButtonView.frame = CGRectMake(0, self.searchView.bounds.size.height, kScreenWidth, kSCREEN_WIDTH / 4 * height1);
        self.headerView.bounds = CGRectMake(0, 0, kScreenWidth, kSCREEN_WIDTH / 4 * height1 + self.searchView.bounds.size.height);


        NSInteger idx = 0;
        for (NSDictionary *obj in _classifyArray) {
            NSString *title = obj[@"name"];
            //            背景视图
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH / 4 * (idx % 4), kSCREEN_WIDTH / 4 * (idx / 4), kSCREEN_WIDTH / 4, kSCREEN_WIDTH / 4 )];
            view.backgroundColor = [FFColorManager navigation_bar_white_color];

            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];

            button.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 8, kSCREEN_WIDTH / 8);
            button.center = CGPointMake(kSCREEN_WIDTH / 8, kSCREEN_WIDTH / 9);

            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,obj[@"logo"]]] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"image_downloading"]];

            button.tag = idx + BTNTAG;

            [button addTarget:self action:@selector(respondsToBtn:) forControlEvents:(UIControlEventTouchUpInside)];

            UILabel *label = [[UILabel alloc] init];
            label.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 8, kSCREEN_WIDTH / 20);
            label.center = CGPointMake(kSCREEN_WIDTH / 8, kSCREEN_WIDTH / 24 * 5);

            label.text = title;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];

            [view addSubview:button];
            [view addSubview:label];

            [_classifyButtonArray addObject:view];
            [self.classifyButtonView addSubview:view];
            idx++;
        }


    } else {
//        self.headerView = nil;
    }

    self.tableView.tableHeaderView = self.headerView;
}

//// this is Apple's recommended place for adding/updating constraints
//- (void)updateConstraints {
//
//    [self.growingButton updateConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
//        make.width.equalTo(@(self.buttonSize.width)).priorityLow();
//        make.height.equalTo(@(self.buttonSize.height)).priorityLow();
//        make.width.lessThanOrEqualTo(self);
//        make.height.lessThanOrEqualTo(self);
//    }];
//
//    //according to apple super should be called at end of method
//    [super updateConstraints];
//}


- (void)setTopGameName:(NSString *)topGameName {
    _topGameName = topGameName;
    [self setSearchTitle:topGameName];
}

- (void)setSearchTitle:(NSString *)title {
    if ([self.searchTitleButton.titleLabel.text isEqualToString:title] || ![title isKindOfClass:[NSString class]]) {


        return;
        
    } else {
        [self.searchTitleButton setTitle:(title ?: @"精品游戏") forState:(UIControlStateNormal)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setSearchTitle:title];
        });
    }
}


#pragma mark - getter
- (FFGameServersType)gameServersType {
    return BT_SERVERS;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];

        self.searchView = [UIView hyb_viewWithSuperView:_headerView constraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self -> _headerView);
            make.left.mas_equalTo(self -> _headerView);
            make.right.mas_equalTo(self -> _headerView);
            make.height.mas_equalTo(60);
        }];
        self.searchView.backgroundColor = [FFColorManager navigation_bar_white_color];

        self.searchBackView = [UIView hyb_viewWithSuperView:self.searchView constraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
//            make.top.mas_equalTo(self.searchView).offset(10);
            make.left.mas_equalTo(self.searchView).offset(10);
            make.right.mas_equalTo(self.searchView).offset(-10);
//            make.bottom.mas_equalTo(self.searchView).offset(-10);
            make.height.mas_equalTo(40);
        } onTaped:^(UITapGestureRecognizer *sender) {
            [self respondsToSearchButton];
        }];
        self.searchBackView.layer.cornerRadius = 8;
        self.searchBackView.layer.masksToBounds = YES;
        self.searchBackView.backgroundColor = [FFColorManager home_search_view_background_color];

        self.searchTitleButton = [UIButton hyb_buttonWithImage:[FFImageManager Home_search_image] superView:_searchView constraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointZero);
        } touchUp:^(UIButton *sender) {
            [self respondsToSearchButton];
        }];
        self.searchTitleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.searchTitleButton setTitleColor:[FFColorManager textColorLight] forState:(UIControlStateNormal)];


        self.classifyButtonView = [UIView hyb_viewWithSuperView:_headerView constraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.searchView.mas_bottom);
//            make.left.mas_equalTo(self -> _headerView);
//            make.bottom.mas_equalTo(self -> _headerView.mas_bottom);
//            make.right.mas_equalTo(self -> _headerView);
        }];
        self.classifyButtonView.frame = CGRectMake(0, self.searchView.bounds.size.height, kScreenWidth, 0);
        self.classifyButtonView.backgroundColor = [FFColorManager navigation_bar_white_color];
    }
    return _headerView;
}

- (FFClassifyDetailViewController *)detailViewController {
    if (!_detailViewController) {
        _detailViewController = [[FFClassifyDetailViewController alloc] init];
        _detailViewController.gameServersType = self.gameServersType;
    }
    return _detailViewController;
}








@end





