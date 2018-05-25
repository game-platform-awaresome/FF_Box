//
//  FFSearchShowControllerViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFSearchShowControllerViewController.h"
#import "FFClassifyTableCell.h"


#define CELL_IDE @"FFClassifyTableCell"

@interface FFSearchShowControllerViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,FFClassifyTableCellDelegate>

@property (nonatomic, weak) id<FFSearchShowDelegate> delegate;

//列表
@property (nonatomic, strong) UITableView *tableView;

//列表数据源
@property (nonatomic, strong) NSArray *showArray;

/** 热门游戏 */
@property (nonatomic, strong) NSArray *hotArray;

/** 清除历史记录 */
@property (nonatomic, strong) UIButton *clearHistoryBtn;


@end

static FFSearchShowControllerViewController *controller = nil;

@implementation FFSearchShowControllerViewController

+ (instancetype)SharedController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[FFSearchShowControllerViewController alloc] init];
    });
    return controller;
}

+ (void)showSearchControllerWith:(UIViewController *)parentController {
    if (controller.parentViewController == parentController) {
        return;
    }
    [FFSearchShowControllerViewController SharedController].delegate = parentController;
    if (controller.parentViewController && controller.parentViewController != parentController) {
        [controller.parentViewController performSelector:@selector(clickCancelBtn)];
    }
    [parentController addChildViewController:[FFSearchShowControllerViewController SharedController]];
    [parentController.view addSubview:[FFSearchShowControllerViewController SharedController].view];
    [[FFSearchShowControllerViewController SharedController] didMoveToParentViewController:parentController];
}

+ (void)hideSearchController {
    [FFSearchShowControllerViewController SharedController].delegate = nil;
    [[FFSearchShowControllerViewController SharedController] willMoveToParentViewController:[FFSearchShowControllerViewController SharedController].parentViewController];
    [[FFSearchShowControllerViewController SharedController].view removeFromSuperview];
    [[FFSearchShowControllerViewController SharedController] removeFromParentViewController];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _showArray = [FFSearchModel getSearchHistory];
    if (_showArray) {
        self.tableView.tableFooterView = self.clearHistoryBtn;
    } else {
        self.tableView.tableFooterView = [UIView new];
    }

    if (self.hotArray.count == 0) {
        [self hotGame];
    }

    [self.tableView reloadData];


}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.modalPresentationCapturesStatusBarAppearance = NO;

    [self initDataSource];
    [self initUserInterface];
}

//初始化数据源
- (void)initDataSource {
    [self hotGame];
}

//初始化用户界面
- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];
}

- (void)hotGame {
    [FFSearchModel hotGameWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSArray *array = content[@"data"];
            if (array.count > 4) {
                NSRange range = NSMakeRange(0, 4);
                _hotArray = [array subarrayWithRange:range];
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - respond
- (void)clickClearHistoryBtn {
    if (self.showArray) {

        [FFSearchModel clearSearchHistory];
        self.showArray = nil;

        self.tableView.tableFooterView = [UIView new];

        [self.tableView reloadData];
    }
}

#pragma mark - method

#pragma mark - cellDelegate
- (void)FFClassifyTableCell:(FFClassifyTableCell *)cell clickGame:(NSDictionary *)dict {
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;

    syLog(@"dict ==== ");


    SHOW_TABBAR;
    SHOW_PARNENT_TABBAR;
}


#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.showArray.count;
        default:
            return 0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0: {
            FFClassifyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];

            cell.delegate = self;
            cell.array = self.hotArray;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }

        default: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rrrrr"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"rrrrr"];
            }

            cell.imageView.image = [UIImage imageNamed:@"search_history"];
            cell.textLabel.text = _showArray[indexPath.row];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            return cell;
        }
    }
}

#pragma mark - tableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_showArray.count != 0) {
        NSString *keyword = _showArray[indexPath.row];

        if (self.delegate && [self.delegate respondsToSelector:@selector(FFSearchShowControllerViewController:didSelectRow:)]) {
            [self.delegate FFSearchShowControllerViewController:self didSelectRow:nil];
        }
        HIDE_TABBAR;
        HIDE_PARNENT_TABBAR;
        [self.navigationController pushViewController:[FFSearchResultController resultControllerWithKeyWord:keyword] animated:YES];
        SHOW_PARNENT_TABBAR;
        SHOW_TABBAR;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, kSCREEN_WIDTH, 40)];

    label.backgroundColor = [UIColor whiteColor];
    switch (section) {
        case 0: {
            label.text = @"    热门搜索";
            break;
        }

        case 1: {
            label.text = @"    搜索历史";
            break;
        }

        default:
            break;
    }


    [view addSubview:label];

    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 100;
        default:
            return 44;
    }
}


#pragma mark - searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    [searchBar resignFirstResponder];

}



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 49) style:(UITableViewStylePlain)];

        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];

        _tableView.dataSource = self;
        _tableView.delegate = self;

        _tableView.backgroundColor = [UIColor whiteColor];

        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;

        _tableView.tableFooterView = self.clearHistoryBtn;

    }
    return _tableView;
}

- (UIButton *)clearHistoryBtn {
    if (!_clearHistoryBtn) {
        _clearHistoryBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _clearHistoryBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH , 44);
        [_clearHistoryBtn setTitle:@"清除历史记录" forState:(UIControlStateNormal)];
        [_clearHistoryBtn setImage:[UIImage imageNamed:@"search_delete"] forState:(UIControlStateNormal)];
        [_clearHistoryBtn addTarget:self action:@selector(clickClearHistoryBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [_clearHistoryBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [_clearHistoryBtn setBackgroundColor:RGBCOLOR(247, 247, 247)];

    }
    return _clearHistoryBtn;
}


@end
