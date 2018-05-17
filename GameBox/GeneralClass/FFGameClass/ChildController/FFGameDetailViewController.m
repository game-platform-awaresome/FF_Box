//
//  FFGameDetailViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameDetailViewController.h"
#import "FFGameDetailHeaderView.h"
#import "FFCurrentGameModel.h"

@interface FFGameDetailViewController ()

@property (nonatomic, strong) FFGameDetailHeaderView *headerView;


@end

@implementation FFGameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)initDataSource {
    [super initDataSource];
}


- (void)refresh {
    self.headerView.imageArray = CURRENT_GAME.showImageArray;
}


#pragma mark - getter
- (FFGameDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFGameDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.77)];
    }
    return _headerView;
}











@end










