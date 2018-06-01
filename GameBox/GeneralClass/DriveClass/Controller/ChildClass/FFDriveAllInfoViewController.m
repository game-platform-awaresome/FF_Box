//
//  FFDriveAllInfoViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/11.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveAllInfoViewController.h"
#import "DriveInfoCell.h"
#import "FFSharedController.h"
#import "FFDriveMineViewController.h"
#import "FFDriveUserModel.h"
#import "FFDriveDetailInfoViewController.h"
#import "FFColorManager.h"

#define CELL_IDE @"DriveInfoCell"

@interface FFDriveAllInfoViewController ()<UITableViewDelegate,UITableViewDataSource,DriveInfoCellDelegate,FFDriveDetailDelegate, UIScrollViewDelegate>


@property (nonatomic, assign) NSUInteger currentPage;

//判断手指是否离开
@property (nonatomic, assign) BOOL isTouch;

@property (nonatomic, strong) FFDriveDetailInfoViewController *detailController;


@property (nonatomic, assign) BOOL cancelLike;

@end

@implementation FFDriveAllInfoViewController {
    NSString *dynamicsID;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondsToSharedDynamisSuccess) name:SharedDynamicsSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewData) name:@"postStausComplete" object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dynamicType = allDynamic;
    [self initDataSource];
    [self initUserInterface];
}


- (void)initUserInterface {
    self.view.backgroundColor = [UIColor redColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}




- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)initDataSource {
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshNewData {
    _currentPage = 1;
    MBProgressHUD *hud;
    if (self.showArray.count == 0) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
    } else {
        hud = nil;
    }
    [FFDriveModel getDynamicWithType:self.dynamicType Page:[NSString stringWithFormat:@"%ld",(unsigned long)_currentPage] CheckUid:self.buid Complete:^(NSDictionary *content, BOOL success) {
        [hud hideAnimated:YES];
        syLog(@"get dynamic == %@",content);
        syLog(@"get dynamics success!!!!");
        self.showArray = nil;
        if (success) {
            NSArray *array = content[@"data"];
            if (array.count > 0) {
                self.showArray = [self.model dataArrayWithArray:array];
            }
            if (self.dynamicType == CheckUserDynamic) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckUserDynamicCallBack" object:nil userInfo:content];
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self cheackShowArrayIsempty];
        [self.tableView reloadData];

    }];
}


- (void)loadMoreData {
    _currentPage++;
    [FFDriveModel getDynamicWithType:self.dynamicType Page:[NSString stringWithFormat:@"%ld",(unsigned long)_currentPage] CheckUid:self.buid Complete:^(NSDictionary *content, BOOL success) {
        NSArray *array = content[@"data"];
        if (success && array.count > 0) {
            self.showArray = [self.model dataArrayAddArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self cheackShowArrayIsempty];
    }];
}

- (void)cheackShowArrayIsempty {
    if (self.showArray.count == 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
        imageView.image = [UIImage imageNamed:@"Community_NoData"];
        self.tableView.backgroundView = imageView;
    } else {
        self.tableView.backgroundView = nil;
    }
}

#pragma mark - responds
- (void)respondsToLikeOrDislikeButtonWithModel:(FFDynamicModel *)model Type:(LikeOrDislike)type index:(NSIndexPath *)indexPath {

    FF_is_login;
    if (_cancelLike == YES) {
        return;
    }

    _cancelLike = YES;
    syLog(@"%@  like === %lu , opera === %@",model.dynamic_id,type,model.operate);
    if (model.operate.integerValue == 2) {
        [FFDriveModel userLikeOrDislikeWithDynamicsID:model.dynamic_id type:type Complete:^(NSDictionary *content, BOOL success) {
            if (success) {
                syLog(@"zan === %@",content);
                [self replaceShowArrayDataWith:indexPath type:type info:content[@"data"][@"operate"]];
            } else {
                BOX_MESSAGE(content[@"msg"]);
            }
            _cancelLike = NO;
        }];
    } else {
        //operate 1 赞 0 踩 2 未操纵
        if (model.operate.integerValue == 1 && type == like) {
            //取消赞
            [FFDriveModel userCancelLikeOrDislikeWithDynamicsID:model.dynamic_id type:like Complete:^(NSDictionary *content, BOOL success) {
                syLog(@"取消赞 ??? %@",content);
                if (success) {
                    [self cancelReplaceShowArrayDataWith:indexPath Type:like info:content[@"data"][@"operate"]];
                }
                _cancelLike = NO;
            }];
        } else if(model.operate.integerValue == 1 && type == dislike) {
            //取消赞
            [FFDriveModel userCancelLikeOrDislikeWithDynamicsID:model.dynamic_id type:like Complete:^(NSDictionary *content, BOOL success) {
                syLog(@"取消赞 ??? %@",content);
                if (success) {
                    [self cancelReplaceShowArrayDataWith:indexPath Type:like info:content[@"data"][@"operate"]];
                    //点踩
                    [FFDriveModel userLikeOrDislikeWithDynamicsID:model.dynamic_id type:dislike Complete:^(NSDictionary *content, BOOL success) {
                        if (success) {
                            [self replaceShowArrayDataWith:indexPath type:type info:content[@"data"][@"operate"]];
                        } else {
                            BOX_MESSAGE(content[@"msg"]);
                        }
                        _cancelLike = NO;
                    }];
                }
            }];
        } else if (model.operate.integerValue == 0 && type == dislike) {
            //取消踩
            [FFDriveModel userCancelLikeOrDislikeWithDynamicsID:model.dynamic_id type:dislike Complete:^(NSDictionary *content, BOOL success) {
                syLog(@"取消踩 ??? %@",content);
                if (success) {
                    [self cancelReplaceShowArrayDataWith:indexPath Type:dislike info:content[@"data"][@"operate"]];
                }
                _cancelLike = NO;
            }];
        } else if (model.operate.integerValue == 0 && type == like) {
            //取消踩,点赞
            [FFDriveModel userCancelLikeOrDislikeWithDynamicsID:model.dynamic_id type:dislike Complete:^(NSDictionary *content, BOOL success) {
                syLog(@"取消踩 ??? %@",content);
                if (success) {
                    [self cancelReplaceShowArrayDataWith:indexPath Type:dislike info:content[@"data"][@"operate"]];
                    //点赞
                    [FFDriveModel userLikeOrDislikeWithDynamicsID:model.dynamic_id type:like Complete:^(NSDictionary *content, BOOL success) {
                        if (success) {
                            [self replaceShowArrayDataWith:indexPath type:type info:content[@"data"][@"operate"]];
                        } else {
                            BOX_MESSAGE(content[@"msg"]);
                        }
                        _cancelLike = NO;
                    }];
                }
            }];
        }
    }
}

- (void)replaceShowArrayDataWith:(NSIndexPath *)indexPath type:(LikeOrDislike)type info:(NSString *)operate  {
    FFDynamicModel *model = self.showArray[indexPath.row];
    if (type == like) {
        model.likes_number = [NSString stringWithFormat:@"%ld",(model.likes_number.integerValue + 1)];
    } else {
        model.dislikes_number = [NSString stringWithFormat:@"%ld",(model.dislikes_number.integerValue + 1)];
    }

    model.operate = operate;

    if (indexPath == nil) {
        [self.tableView reloadData];
    } else {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    }
}

- (void)cancelReplaceShowArrayDataWith:(NSIndexPath *)indexPath Type:(LikeOrDislike)type info:(NSString *)operate {
    FFDynamicModel *model = self.showArray[indexPath.row];
    if (type == like) {
        model.likes_number = [NSString stringWithFormat:@"%ld",(model.likes_number.integerValue - 1)];
    } else {
        model.dislikes_number = [NSString stringWithFormat:@"%ld",(model.dislikes_number.integerValue - 1)];
    }

    model.operate = operate;

    if (indexPath == nil) {
        [self.tableView reloadData];
    } else {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    }
}

static BOOL respondsSuccess;
- (void)respondsSharedButtonWithCell:(DriveInfoCell *)cell {
    syLog(@"分享");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    FFDynamicModel *model = cell.model;
    [dict setObject:cell.images forKey:@"images"];
    [dict setObject:model.content forKey:@"content"];
    [dict setObject:model.dynamic_id forKey:@"id"];
    dynamicsID = model.dynamic_id;
    respondsSuccess = NO;
    [FFSharedController sharedDynamicsWithDict:dict];
}

- (void)respondsToSharedDynamisSuccess {
    if (respondsSuccess) {
        return;
    }
    respondsSuccess = YES;
    [FFDriveModel userSharedDynamics:dynamicsID Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"shared success");
        if (success) {
            [self refreshNewData];
        }
    }];
}

#pragma mark - delete dynamic
- (void)deleteMyDynamics {
    FFDynamicModel *model = self.showArray[self.currentCellIndex];
    syLog(@"请求删除动态 %@",model);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
    [FFDriveModel userDeletePortraitWithDynamicsID:model.dynamic_id Completion:^(NSDictionary *content, BOOL success) {
        syLog(@"测试删除  == %@",content);
        [hud hideAnimated:YES];
        if (success) {
            [self.tableView.mj_header beginRefreshing];
        } else {
            BOX_MESSAGE(@"删除失败,请稍后尝试");
        }
    }];
}

#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DriveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.delegate = self;
    FFDynamicModel *model = self.showArray[indexPath.row];
    if ([self dynamicType] == attentionDynamic) {
        model.attention = @"1";
    }

    if (self.dynamicType == CheckUserDynamic) {
        model.showVerifyDynamics = YES;
    } else {
        model.showVerifyDynamics = NO;
    }

    cell.model = model;



    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FFDynamicModel *model = self.showArray[indexPath.row];
    if ([model.verifyDynamics isEqualToString:@"1"]) {
        [self pushDetailControllerWith:indexPath Comment:NO];
    }
}

- (void)pushDetailControllerWith:(NSIndexPath *)indexPath Comment:(BOOL)isComment {
    self.detailController.model = self.showArray[indexPath.row];
    self.detailController.indexPath = indexPath;
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:self.detailController animated:YES];
    SHOW_PARNENT_TABBAR;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isTouch = YES;
}

///用于判断手指是否离开了 要做到当用户手指离开了，tableview滑道顶部，也不显示出主控制器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.isTouch = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray<DriveInfoCell *> *cells = [self.tableView visibleCells];
    [cells enumerateObjectsUsingBlock:^(DriveInfoCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[DriveInfoCell class]]) {
            CGRect frame = [obj convertRect:obj.bounds toView:self.view];
            if (frame.origin.y < -100 || frame.origin.y > 300) {
                [obj stopGif];
            } else {
                [obj starGif];
            }
        }
    }];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    syLog(@"??????????");
}


- (void)canScroll:(UIScrollView *)scrollView {
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        if (!self.isTouch) {//当手指离开了，也不允许显示主控制器，这里可以根据实际需求做处理
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kLeaveTopNtf" object:@1];
        self.canScroll = NO;
        scrollView.contentOffset = CGPointZero;
    }
}


#pragma mark - cell delegate
- (void)DriveInfoCell:(DriveInfoCell *)cell didClickButtonWithType:(CellButtonType)type {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (type) {
        case likeButton: {
            [self respondsToLikeOrDislikeButtonWithModel:cell.model Type:like index:indexPath];
        }
            break;
        case dislikeButton: {
            [self respondsToLikeOrDislikeButtonWithModel:cell.model Type:dislike index:indexPath];
        }
            break;
        case sharedButton: {
            [self respondsSharedButtonWithCell:cell];
        }
            break;
        case commentButoon: {
            [self pushDetailControllerWith:indexPath Comment:YES];
        }
            break;
        case noonButton: {

        }
            break;

        default:
            break;
    }
}

- (void)DriveInfoCell:(DriveInfoCell *)cell didClickIconWithUid:(NSString *)uid WithIconImage:(UIImage *)iconImage {
    syLog(@"click icon with uid == %@", uid);
    
    if (SSKEYCHAIN_UID == nil || SSKEYCHAIN_UID.length < 1) {
        Class test = NSClassFromString(@"FFLoginViewController");
        HIDE_TABBAR;
        HIDE_PARNENT_TABBAR;
        [self.navigationController pushViewController:[test new] animated:YES];
        SHOW_TABBAR;
        SHOW_PARNENT_TABBAR;
    } else {
        FFDriveMineViewController *vc = [FFDriveMineViewController new];
        vc.iconImage = iconImage;
        vc.model = cell.model;
        //    vc.uid = cell.model.present_user_uid;
        HIDE_TABBAR;
        HIDE_PARNENT_TABBAR;
        [self.navigationController pushViewController:vc animated:YES];
        SHOW_TABBAR;
        SHOW_PARNENT_TABBAR;
    }
}




#pragma mark - detail delegate
- (void)FFDriveDetailController:(FFDriveDetailInfoViewController *)controller replaceDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath {
    syLog(@"点赞????");
//    [self.showArray replaceObjectAtIndex:indexPath.row withObject:dict];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}

- (void)FFDriveDetailController:(FFDriveDetailInfoViewController *)controller SharedWith:(NSIndexPath *)indexPath {
    DriveInfoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self respondsSharedButtonWithCell:cell];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [FFViewFactory creatTableView:_tableView WithFrame:CGRectNull WithDelegate:self];

        MJRefreshNormalHeader *customRefreshHeader = [FFViewFactory customRefreshHeaderWithTableView:_tableView WithTarget:self];

        //下拉刷新
        [customRefreshHeader setRefreshingAction:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  @selector(refreshNewData)];
        //上拉加载更多
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

        _tableView.tableFooterView = [UIView new];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1];
        _tableView.tableHeaderView = line;

        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.showsVerticalScrollIndicator = YES;

    }
    return _tableView;
}

- (DynamicType)dynamicType {
    return allDynamic;
}

- (FFDriveDetailInfoViewController *)detailController {
    if (!_detailController) {
        _detailController = [[FFDriveDetailInfoViewController alloc] init];
        _detailController.delegate = self;
    }
    return _detailController;
}

- (FFDriveUserModel *)userModel {
    return [FFDriveUserModel sharedModel];
}

- (FFDynamicModel *)model {
    if (!_model) {
        _model = [[FFDynamicModel alloc] init];
    }
    return _model;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SharedDynamicsSuccess object:nil];
}



@end












