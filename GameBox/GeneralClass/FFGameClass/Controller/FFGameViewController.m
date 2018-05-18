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

@property (nonatomic, strong) NSArray *childsControllerName;
@property (nonatomic, strong) NSMutableArray<FFBasicSSTableViewController *> *childsControllerArray;


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
//    self.view.backgroundColor = [UIColor blackColor];
    [self setSelectViewInfo];
    [self setNormalView];
}

- (void)setNormalView {
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"0.0";
    self.headerView = self.gameHeaderView;
    self.sectionView = self.selectView;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:1 alpha:1]];

    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 60, kSCREEN_WIDTH, 60)];
    self.footerView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.tableView];

//    self.tableView.alpha = 0;
//    self.footerView.alpha = 0;
//    [UIView animateWithDuration:0.7 animations:^{
//        self.tableView.alpha = 1;
//        self.footerView.alpha = 1;
//    }];
    [self.view bringSubviewToFront:self.navigationView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];

    //计算导航栏的透明度
    CGFloat maxAlphaOffset = self.headerView.bounds.size.height - kNAVIGATION_HEIGHT;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = offset / maxAlphaOffset;

    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:(1 - alpha) alpha:1]];

    self.navigationView.alpha = alpha;

    CGFloat offset_y = scrollView.contentOffset.y;
    [self.gameHeaderView refreshBackgroundHeight:offset_y];
    //根据导航栏透明度设置title
    if (offset_y > 120) {
        [self showNavigationTitle];
    } else {
        [self hideNavigationTitle];
    }
}


- (void)initDataSource {
    [super initDataSource];

    self.childsControllerName = @[@"FFGameDetailViewController",
                                  @"FFGameCommentListViewController",
                                  @"FFGameDetailViewController",
                                  @"FFGameDetailViewController",
                                  @"FFGameDetailViewController"];

    [self.gameHeaderView setQqGroupButtonBlock:^{
        syLog(@"玩家 QQ 群");
    }];

    //点击了 select view 的下标后 滑动cell 的 scroll view 到指定位置
    [self.selectView setSelectBlock:^(NSUInteger idx) {
        [[FFBasicSSTableViewCell cell] selectViewWithIndex:idx];
    }];

    //cell 横向滑动的时候 移动 select view 的游标
    WeakSelf;
    [[FFBasicSSTableViewCell cell] setScrolledBlock:^(CGFloat offset_x) {
        [weakSelf.selectView setCursorView_X:(offset_x)];
    }];
}

- (FFBasicSSTableViewController *)creatController {
    FFBasicSSTableViewController *vc = [FFBasicSSTableViewController new];
    UIColor *color = RGBColor(arc4random() % 255, arc4random() % 255, arc4random() % 255);
    vc.view.backgroundColor = color;
    return vc;
}

- (FFBasicSSTableViewController *)creatControllerWithName:(NSString *)name {
    Class ViewController = NSClassFromString(name);
    id vc = [[ViewController alloc] init];
    if (![vc isKindOfClass:[FFBasicSSTableViewController class]]) {
        vc = [[UIViewController alloc] init];
    }
    [self addChildViewController:vc];

    syLog(@"self navigation controller = %@",self.navigationController);
    return vc;
}


#pragma mark - method
- (void)refreshData {
    if (self.gid.length > 0) {
        [self startWaiting];
        WeakSelf;
        [FFCurrentGameModel refreshCurrentGameWithGameID:self.gid Completion:^(BOOL success) {
            [weakSelf stopWaiting];
            if (success) {
                [weakSelf setNormalView];
                [weakSelf.gameHeaderView refresh];
            } else {
                [weakSelf.currentNav popViewControllerAnimated:YES];
            }
        }];
    }
}


- (void)showNavigationTitle {
    self.navigationItem.title = CURRENT_GAME.game_name;
    [self.gameHeaderView showNavigationTitle];
}

- (void)hideNavigationTitle {
    self.navigationItem.title = @"";
    [self.gameHeaderView hideNavigationTitle];
}

#pragma mark - setter
- (void)setGid:(NSString *)gid {
    if ([_gid isEqualToString:gid]) {
        return;
    }

    [self removeAllview];
    _gid = gid;
    //刷新游戏
    [self refreshData];
}

- (void)removeAllview {
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    self.navigationView.alpha = 0;
    self.footerView = nil;
    [self hideNavigationTitle];
}

- (void)setChildsControllerName:(NSArray *)childsControllerName {
    _childsControllerName = childsControllerName;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:childsControllerName.count];
    for (NSString *name in childsControllerName) {
        id vc = [self creatControllerWithName:name];
        [array addObject:vc];
    }
    self.selectChildConttoller = array.copy;
}




#pragma mark - getter
- (FFGameHeaderView *)gameHeaderView {
    if (!_gameHeaderView) {
        _gameHeaderView = [[FFGameHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 250)];
    }
    return _gameHeaderView;
}

- (void)setSelectViewInfo {
    self.selectView.headerLineColor = [FFColorManager game_select_line_color];
    self.selectView.footerLineColor = [FFColorManager game_select_line_color];
    self.selectView.normalColor = [FFColorManager game_select_normal_color];
    self.selectView.selectColor = [FFColorManager game_select__color];
    self.selectView.cursorColor = [FFColorManager game_select_cursor_color];
    self.selectView.titleArray = @[@"详情",@"评论",@"礼包",@"开服",@"攻略"];
    [self.selectView setButtonSubscriptWithIdx:1 Title:@"12"];
}




@end








