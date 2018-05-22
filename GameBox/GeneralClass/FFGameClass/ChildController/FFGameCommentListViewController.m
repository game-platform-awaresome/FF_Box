//
//  FFGameCommentListViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameCommentListViewController.h"
#import "FFCurrentGameModel.h"
#import "FFUserModel.h"
#import "FFGameModel.h"
#import <MJRefresh/MJRefresh.h>
#import "FFLoginViewController.h"

#import "FFDriveCommentCell.h"
#define CELL_IDE @"FFDriveCommentCell"
#define BOX_REGISTER_CELL [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE]
#define Reset_page (self.currentPage = 1)
#define New_page ([NSString stringWithFormat:@"%lu",self.currentPage])
#define Next_page ([NSString stringWithFormat:@"%lu",++self.currentPage])

@interface FFGameCommentListViewController () <FFDriveCommentCellDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, assign) BOOL isLiking;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *showArray;
@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshBackFooter *refreshFooter;

@end

@implementation FFGameCommentListViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.canRefresh) {
        [self refreshData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    [self.view addSubview:self.tableView];
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

/**刷新数据*/
- (void)refreshData {
    self.canScroll = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    self.canScroll = NO;
    self.canRefresh = NO;
    Reset_page;
    [FFGameModel gameCommentListWithGameID:CURRENT_GAME.game_id Page:New_page Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        //刷新评论数
        [CURRENT_GAME getCommentNumber];
        syLog(@"comment %@",content);
        if (success) {
            NSArray *array = content[@"data"][@"list"];
            if (array.count > 0) {
                self.showArray = [NSMutableArray arrayWithArray:array];
            } else {
                self.showArray = nil;
            }
        } else {

        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}

/** 加载更多数据 */
- (void)loadMoreData {
    [FFGameModel gameCommentListWithGameID:CURRENT_GAME.game_id Page:Next_page Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            NSArray *array = content[@"data"][@"list"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - table iew
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FFDriveCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.delegate = self;
    cell.dict = self.showArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.hidesBottomBarWhenPushed = YES;
    if (![FFUserModel currentUser].isLogin) {
        [self pushViewController:[FFLoginViewController new]];
        return;
    }
    if (self.isLiking) {
        return;
    }

    [self showCellSelectionWithIndexPath:indexPath];
}

- (void)showCellSelectionWithIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.showArray[indexPath.row];
    NSString *like_type = [NSString stringWithFormat:@"%@",dict[@"like_type"]];
    NSString *uid = [NSString stringWithFormat:@"%@",dict[@"uid"]];
    NSString *destructiveTitle = nil;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"回复"];
    if ([like_type isEqualToString:@"2"]) {
        [array addObject:@"点赞"];
    } else if ([like_type isEqualToString:@"1"]) {
        [array addObject:@"取消点赞"];
    }

    if ([uid isEqualToString:SSKEYCHAIN_UID]) {
        [array removeObject:@"回复"];
        destructiveTitle = @"删除评论";
    }

    [UIAlertController showAlertControllerWithViewController:[FFControllerManager sharedManager].rootNavController alertControllerStyle:(UIAlertControllerStyleActionSheet) title:@"评论操作" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:destructiveTitle otherButtonTitles:array CallBackBlock:^(NSInteger btnIndex) {
        self.currentIndexPath = indexPath;
        [self selectCellResultWithDictionary:dict desTitle:destructiveTitle btnTitles:array selectIndex:btnIndex];

    }];

}

- (void)selectCellResultWithDictionary:(NSDictionary *)dict desTitle:(NSString *)desTitle btnTitles:(NSArray *)array selectIndex:(NSUInteger)index {

    switch (index) {
        case 0: {

            break;
        }
        case 1: {
            [self cellSelectIndex1WithDesTitle:desTitle Dictionary:dict];
            break;
        }
        case 2: {
            [self cellSelectIndex2WithDictionary:dict];
            break;
        }

        default:
            break;
    }
}

- (void)cellSelectIndex1WithDesTitle:(NSString *)desTitle Dictionary:(NSDictionary *)dict {
    if (desTitle) {
        //删除评论
        NSString *commentID = [NSString stringWithFormat:@"%@",dict[@"id"]];
        [self startWaiting];
        [CURRENT_GAME deleteCommentWithCommentID:commentID Completion:^(NSDictionary *content, BOOL success) {
            [self stopWaiting];
            if (success) {
                [UIAlertController showAlertMessage:@"删除成功" dismissTime:0.7 dismissBlock:nil];
                [self refreshData];
            }
        }];
    } else {
#warning resend message
        //回复评论
//        FFReplyToCommentController *controller = [FFReplyToCommentController replyCommentWithCommentDict:dict Completion:^(NSDictionary *content, BOOL success) {
//            [self.navigationController popViewControllerAnimated:YES];
//            if (success) {
//                [UIAlertController showAlertMessage:@"回复成功" dismissTime:0.7 dismissBlock:nil];
//                [self.tableView.mj_header beginRefreshing];
//            } else {
//                [UIAlertController showAlertMessage:@"回复失败" dismissTime:0.7 dismissBlock:nil];
//            }
//            syLog(@"replay ==== %@",content);
//        }];
//
//        HIDE_TABBAR;
//        HIDE_PARNENT_TABBAR;
//        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)cellSelectIndex2WithDictionary:(NSDictionary *)dict {
    NSString *like_type = [NSString stringWithFormat:@"%@",dict[@"like_type"]];
    if ([like_type isEqualToString:@"2"]) {
        //点赞
        [self likeWithCommentID:[NSString stringWithFormat:@"%@",dict[@"id"]] Dict:dict andIndexPath:self.currentIndexPath];
    } else if ([like_type isEqualToString:@"1"]) {
        //取消点赞
        [self cancelLikeWithCommentID:[NSString stringWithFormat:@"%@",dict[@"id"]] Dict:dict andIndexPath:self.currentIndexPath];
    }
}






#pragma mark - cell delegate
- (void)FFDriveCommentCell:(FFDriveCommentCell *)cell didClickLikeButtonWith:(NSDictionary *)dict {
    syLog(@"评论点赞 %@",dict);

    if (![FFUserModel currentUser].isLogin) {
        [self pushViewController:[FFLoginViewController new]];
        return;
    }

    if (self.isLiking) {
        return;
    }
    _isLiking = YES;
    NSString *likeType = [NSString stringWithFormat:@"%@",dict[@"like_type"]];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *commentID = [NSString stringWithFormat:@"%@",dict[@"id"]];
    if ([likeType isEqualToString:@"2"]) {
        //点赞
        [self likeWithCommentID:commentID Dict:dict andIndexPath:indexPath];
    } else {
        //取消赞
        [self cancelLikeWithCommentID:commentID Dict:dict andIndexPath:indexPath];
    }
}

/** 点赞 */
- (void)likeWithCommentID:(NSString *)commentID Dict:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    [CURRENT_GAME likeCommentWithCommentID:commentID Completion:^(NSDictionary *content, BOOL success) {
        syLog(@"like returen --- %@",content);
        weakSelf.isLiking = NO;
        if (success) {
            NSMutableDictionary *rdict = [dict mutableCopy];
            [rdict setObject:@"1" forKey:@"like_type"];
            NSString *likes = [NSString stringWithFormat:@"%@",rdict[@"likes"]];
            [rdict setObject:[NSString stringWithFormat:@"%lu",(likes.integerValue + 1)] forKey:@"likes"];
            [weakSelf.showArray setObject:rdict atIndexedSubscript:indexPath.row];
        }
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    }];
}

/** 取消赞 */
- (void)cancelLikeWithCommentID:(NSString *)commentID Dict:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    [CURRENT_GAME cancelLikeCommentWithCommentID:commentID Type:@"1" Completion:^(NSDictionary *content, BOOL success) {
        weakSelf.isLiking = NO;
        if (success) {
            NSMutableDictionary *rdict = [dict mutableCopy];
            [rdict setObject:@"2" forKey:@"like_type"];
            NSString *likes = [NSString stringWithFormat:@"%@",rdict[@"likes"]];
            [rdict setObject:[NSString stringWithFormat:@"%lu",(likes.integerValue - 1)] forKey:@"likes"];
            [weakSelf.showArray setObject:rdict atIndexedSubscript:indexPath.row];
        }
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    }];
}

#pragma makr - scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isTouch = YES;
}

//用于判断手指是否离开了 要做到当用户手指离开了，tableview滑道顶部，也不显示出主控制器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.isTouch = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }

    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FFSSControllerTableScroll" object:@1];
        self.canScroll = NO;
        scrollView.contentOffset = CGPointZero;
    }
}


#pragma mark - commentView;

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [FFColorManager tableview_background_color];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {

        }
        _tableView.mj_footer = self.refreshFooter;
        
    }
    return _tableView;
}



- (MJRefreshBackFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _refreshFooter;
}





@end
