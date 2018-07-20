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


#define BTNTAG 1700
#define SECTIONTAG 2700
#define CELL_IDE @"FFClassifyTableCell"

@interface FFClassifyViewController () <FFClassifyTableCellDelegate>

/** classify array */
@property (nonatomic, strong) NSMutableArray *classifyArray;

/** header veiw */
@property (nonatomic, strong) UIView *headerView;

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
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma amrk - method
- (void)refreshData {
    self.currentPage = 1;
    [self startWaiting];
    [FFGameModel gameClassifyListWithPage:New_page ServerType:self.gameServersType Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
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

        if (self.classifyArray.count > 0 && self.showArray.count > 0) {
            self.tableView.tableHeaderView = self.headerView;
        } else {
            self.tableView.tableHeaderView = nil;
        }

        [self.tableView.mj_header endRefreshing];
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
        self.headerView = nil;
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

        self.headerView.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH / 4 * height1);
        self.headerView.backgroundColor = [FFColorManager tabbarColor];

        NSInteger idx = 0;
        for (NSDictionary *obj in _classifyArray) {
            NSString *title = obj[@"name"];
            //            背景视图
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH / 4 * (idx % 4), kSCREEN_WIDTH / 4 * (idx / 4), kSCREEN_WIDTH / 4, kSCREEN_WIDTH / 4 )];
            view.backgroundColor = [FFColorManager tabbarColor];

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
            [self.headerView addSubview:view];
            idx++;
        }
    } else {
        self.headerView = nil;
    }

}

#pragma mark - getter
- (FFGameServersType)gameServersType {
    return BT_SERVERS;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0);
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





