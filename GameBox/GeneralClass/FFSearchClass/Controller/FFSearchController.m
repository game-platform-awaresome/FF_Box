//
//  FFSearchController.m
//  GameBox
//
//  Created by 燚 on 2018/5/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFSearchController.h"
#import "FFSearchShowControllerViewController.h"

@interface FFSearchController ()<UIScrollViewDelegate, UISearchBarDelegate, FFSearchShowDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end


@implementation FFSearchController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"1.0";
    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_black_color]];
    [self.navigationController.navigationBar setBarTintColor:[FFColorManager navigation_bar_white_color]];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [FFSearchShowControllerViewController showSearchControllerWith:self andSearchType:self.ServerType];

}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"搜索";
    self.navigationItem.titleView = self.searchBar;
    self.leftButton = [[UIBarButtonItem alloc] initWithImage:[FFImageManager General_back_black] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
//    self.rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];

    self.navigationItem.leftBarButtonItem = self.leftButton;
}

- (void)initDataSource {
    [super initDataSource];
}

#pragma mark - responds
- (void)respondsToLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - search show delegate
- (void)FFSearchShowControllerViewController:(FFSearchShowControllerViewController *)controller didSelectRow:(id)info {
    [self.searchBar resignFirstResponder];
}

#pragma mark - searchDeleagete
//即将开始搜索
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem new];
    _searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    self.navigationItem.leftBarButtonItem = self.leftButton;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    _searchBar.showsCancelButton = NO;
}

//点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![searchBar.text isEqualToString:@""]) {
            [FFSearchModel addSearchHistoryWithKeyword:searchBar.text];
            [self pushViewController:[FFSearchResultController resultControllerWithKeyWord:searchBar.text]];
        }
    });
}

#pragma mark - getter
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];

        _searchBar.barTintColor = [FFColorManager blue_dark];
        _searchBar.tintColor = [FFColorManager navigation_bar_black_color];
        _searchBar.placeholder = @"搜索游戏";
        _searchBar.delegate = self;

        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[FFColorManager view_separa_line_color]];
            [searchField setTextColor:[FFColorManager navigation_bar_black_color]];
        }

    }
    return _searchBar;
}

@end











