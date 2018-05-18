//
//  FFGameCommentListViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameCommentListViewController.h"
#import "FFCurrentGameModel.h"
#import "FFGameModel.h"


#import "FFDriveCommentCell.h"
#define CELL_IDE @"FFDriveCommentCell"

@interface FFGameCommentListViewController ()

/** 当前评论数 */
@property (nonatomic, assign) NSInteger currentComments;

@property (nonatomic, strong) NSString *topic_id;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, assign) BOOL isLiking;

/** 加载全部 */
@property (nonatomic, assign) BOOL isAll;


@end

@implementation FFGameCommentListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"更多评论";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)initDataSource {
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
    [self.tableView.mj_header beginRefreshing];
}
/**刷新数据*/
- (void)refreshNewData {
    self.currentPage = 1;
    WeakSelf;

//    [CURRENT_GAME getcomment]

//    [CURRENT_GAME getCommentListWithPage:New_page Completion:^(NSDictionary *content, BOOL success) {
//        syLog(@"game comment ========== %@",content);
//        //刷新评论数
//        syLog(@"刷新评论数目");
//        [CURRENT_GAME getCommentNumber];
//        if (success) {
//            NSArray *array = content[@"data"][@"list"];
//            if (array.count > 0) {
//                weakSelf.showArray = [NSMutableArray arrayWithArray:array];
//            } else {
//                weakSelf.showArray = nil;
//            }
//        } else {
//
//        }
//        [weakSelf.tableView.mj_header endRefreshing];
//        [weakSelf.tableView.mj_footer endRefreshing];
//        [weakSelf.tableView reloadData];
//    }];

}

/** 加载更多数据 */
- (void)loadMoreData {
    self.currentPage++;
    WeakSelf;
//    [CURRENT_GAME getCommentListWithPage:[NSString stringWithFormat:@"%lu",_currentPage] Completion:^(NSDictionary *content, BOOL success) {
//        syLog(@"game add comment ========== %@",content);
//        if (success) {
//            NSArray *array = content[@"data"][@"list"];
//            if (array.count > 0) {
//                [weakSelf.showArray addObjectsFromArray:array];
//                [weakSelf.tableView.mj_footer endRefreshing];
//            } else {
//                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        } else {
//            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
//        [weakSelf.tableView reloadData];
//    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FFDriveCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
//    cell.delegate = self;
    cell.dict = self.showArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    if (SSKEYCHAIN_UID == nil) {
////        BOX_MESSAGE(@"尚未登录");
//        return;
//    }
//
//    if (self.isLiking) {
//        return;
//    }

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
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//        [CURRENT_GAME deleteCommentWithCommentID:commentID Completion:^(NSDictionary *content, BOOL success) {
//            [hud hideAnimated:YES];
//            if (success) {
//                [UIAlertController showAlertMessage:@"删除成功" dismissTime:0.7 dismissBlock:nil];
//                [self.tableView.mj_header beginRefreshing];
//            }
//        }];
    } else {
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
//    [CURRENT_GAME likeCommentWithCommentID:commentID Completion:^(NSDictionary *content, BOOL success) {
//        syLog(@"like returen --- %@",content);
//        weakSelf.isLiking = NO;
//        if (success) {
//            NSMutableDictionary *rdict = [dict mutableCopy];
//            [rdict setObject:@"1" forKey:@"like_type"];
//            NSString *likes = [NSString stringWithFormat:@"%@",rdict[@"likes"]];
//            [rdict setObject:[NSString stringWithFormat:@"%lu",(likes.integerValue + 1)] forKey:@"likes"];
//            [weakSelf.showArray setObject:rdict atIndexedSubscript:indexPath.row];
//        }
//        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
//    }];
}

/** 取消赞 */
- (void)cancelLikeWithCommentID:(NSString *)commentID Dict:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
//    [CURRENT_GAME cancelLikeCommentWithCommentID:commentID Type:@"1" Completion:^(NSDictionary *content, BOOL success) {
//        syLog(@"like returen --- %@",content);
//        weakSelf.isLiking = NO;
//        if (success) {
//            NSMutableDictionary *rdict = [dict mutableCopy];
//            [rdict setObject:@"2" forKey:@"like_type"];
//            NSString *likes = [NSString stringWithFormat:@"%@",rdict[@"likes"]];
//            [rdict setObject:[NSString stringWithFormat:@"%lu",(likes.integerValue - 1)] forKey:@"likes"];
//            [weakSelf.showArray setObject:rdict atIndexedSubscript:indexPath.row];
//        }
//        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
//    }];
}






@end
