//
//  FFBusinessSearchViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/12.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessSearchViewController.h"

@interface FFBusinessSearchViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;


@end

@implementation FFBusinessSearchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataSource {
//    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
//    self.showArray = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""].mutableCopy;
}

- (void)initUserInterface {
    [super initUserInterface];

    [self.leftButton setImage:[FFImageManager General_back_black]];
    self.navigationItem.leftBarButtonItem = self.leftButton;

    [self.rightButton setTitle:@"搜索"];
    self.navigationItem.rightBarButtonItem = self.rightButton;

    self.navigationItem.titleView = self.searchBar;

    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    syLog(@"!!!!!!!!!!!!!!!!!!!1");
}

- (void)begainRefresData {

}


#pragma mark - responds
- (void)respondsToTap:(UITapGestureRecognizer *)sender {
    [self.searchBar resignFirstResponder];
}

- (void)respondsToLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToRightButton {
    syLog(@"搜索");
    [self.searchBar resignFirstResponder];
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
            [searchField setTextColor:[FFColorManager textColorMiddle]];
        }

    }
    return _searchBar;
}



@end


















