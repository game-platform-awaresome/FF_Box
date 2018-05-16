//
//  FFGameViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameViewController.h"
#import "FFCurrentGameModel.h"
#import "FFGameHeaderView.h"

@interface FFGameViewController ()


@property (nonatomic, strong) FFGameHeaderView *gameHeaderView;



@end

static FFGameViewController *controller = nil;
@implementation FFGameViewController


+ (instancetype)sharedController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!controller) {
            controller = [[FFGameViewController alloc] init];
        }
    });
    return controller;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"0.0";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];

//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    self.headerView = self.gameHeaderView;

    self.sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];
    self.sectionView.backgroundColor = [UIColor blueColor];


    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 60, kSCREEN_WIDTH, 60)];
    self.footerView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.footerView];
    [self.view bringSubviewToFront:self.navigationView];
    //下拉放大
//    [self.stretchableTableHeaderView stretchHeaderForTableView:self.tableView withView:self.gameHeaderView.backgroundView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [self.gameHeaderView refreshBackgroundHeight:scrollView.contentOffset.y];
}


- (void)initDataSource {
    [super initDataSource];
    self.selectChildConttoller = @[[self creatController],
                                   [self creatController],
                                   [self creatController],
                                   [self creatController]];
}

- (FFBasicSSTableViewController *)creatController {
    FFBasicSSTableViewController *vc = [FFBasicSSTableViewController new];
    UIColor *color = RGBColor(arc4random() % 255, arc4random() % 255, arc4random() % 255);
    vc.view.backgroundColor = color;
    return vc;
}


#pragma mark - method
- (void)refreshData {
    [super refreshData];
    if (self.gid.length > 0) {
        [self startWaiting];
        [FFCurrentGameModel refreshCurrentGameWithGameID:self.gid Completion:^(BOOL success) {
            [self stopWaiting];
        }];
    }
    [self.tableView.mj_header endRefreshing];
}


#pragma mark - setter
- (void)setGid:(NSString *)gid {
    if ([_gid isEqualToString:gid]) {
        return;
    }

    _gid = gid;
    //刷新游戏
    [self refreshData];
}


#pragma mark - getter
- (FFGameHeaderView *)gameHeaderView {
    if (!_gameHeaderView) {
        _gameHeaderView = [[FFGameHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.6666)];
    }
    return _gameHeaderView;
}




@end








