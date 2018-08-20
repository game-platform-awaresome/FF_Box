//
//  FFGameGuideViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameDetailGuideViewController.h"

#import "FFWebViewController.h"
#import "FFCurrentGameModel.h"

#import "FFGameDetailGuideCell.h"
#import "FFGameDetailGuideModel.h"
#import "FFSharedController.h"

#define CELL_IDE @"FFGameDetailGuideCell"

@interface FFGameDetailGuideViewController ()

@property (nonatomic, strong) FFWebViewController *webViewController;

@property (nonatomic, strong) NSDictionary *currentDict;

@end

@implementation FFGameDetailGuideViewController

- (void)viewWillAppear:(BOOL)animated {
    if (self.canRefresh) {
        [self refreshData];
    }
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.mj_footer = nil;
    self.tableView.mj_header = self.refreshHeader;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[FFGameDetailGuideCell class] forCellReuseIdentifier:CELL_IDE];
    [self.tableView.mj_header beginRefreshing];
}

- (void)initDataSource {
    [super initDataSource];

    //点赞
    static BOOL isLiking;
    [GuideDetailModel setLikeButton:^(NSDictionary *dict, NSIndexPath *indexPath) {
        syLog(@"点赞");
        if (isLiking) {

        } else {
            isLiking = YES;
            [FFGameModel guideLikeTypeWith:(FFGuideTypeLike) GuideID:[NSString stringWithFormat:@"%@",dict[@"article_id"]] Completion:^(NSDictionary * _Nonnull content, BOOL success) {
                isLiking = NO;
                if (success) {
                    NSMutableDictionary *reDict = [dict mutableCopy];
                    [reDict setObject:@"1" forKey:@"like_type"];
                    NSString *likes = [NSString stringWithFormat:@"%@",dict[@"likes"]];
                    [reDict setObject:[NSString stringWithFormat:@"%ld",(likes.integerValue + 1)] forKey:@"likes"];
                    [self.showArray replaceObjectAtIndex:indexPath.row withObject:reDict];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
                }
            }];
        }
    }];
    //点踩
    [GuideDetailModel setDislikeButton:^(NSDictionary *dict, NSIndexPath *indexPath) {
        syLog(@"点踩");
        if (isLiking) {

        } else {
            isLiking = YES;
            [FFGameModel guideLikeTypeWith:(FFGuideTypeDislike) GuideID:[NSString stringWithFormat:@"%@",dict[@"article_id"]] Completion:^(NSDictionary * _Nonnull content, BOOL success) {
                isLiking = NO;
                if (success) {
                    NSMutableDictionary *reDict = [dict mutableCopy];
                    [reDict setObject:@"0" forKey:@"like_type"];
                    NSString *dislikes = [NSString stringWithFormat:@"%@",dict[@"dislikes"]];
                    [reDict setObject:[NSString stringWithFormat:@"%ld",(dislikes.integerValue + 1)] forKey:@"dislikes"];
                    [self.showArray replaceObjectAtIndex:indexPath.row withObject:reDict];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
                }
            }];
        }
    }];
    //分享
    WeakSelf;
    [GuideDetailModel setSharedBuntton:^(NSDictionary *dict, NSIndexPath *indexPath) {
        syLog(@"分享");
        weakSelf.currentDict = dict;
        [FFSharedController sharedGuideWith:dict];
    }];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondsTosharedSuccess) name:SharedGuideSuccess object:nil];
}

- (void)respondsTosharedSuccess {
    [FFGameModel guideSharedWithGuideID:self.currentDict[@"article_id"] Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        syLog(@"分享 攻略 == %@",content);
        if (success) {
            [self refreshData];
        }
    }];
}

- (void)viewDidLayoutSubviews {
    self.tableView.frame = self.view.bounds;
}

- (void)refreshData {
    [super refreshData];
    [FFGameModel gameGuideWithGameID:CURRENT_GAME.game_id Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            syLog(@"game guide === %@",content);
            id data = content[@"data"][@"list"];
            if ([data isKindOfClass:[NSNull class]] || data == nil) {
                self.showArray = nil;
            } else {
                self.showArray = [content[@"data"][@"list"] mutableCopy];
            }
            [self.tableView reloadData];
        }
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFGameDetailGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    cell.dict = self.showArray[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.webViewController.webURL = self.showArray[indexPath.row][@"info_url"];
    self.parentViewController.parentViewController.hidesBottomBarWhenPushed = YES;
    [self pushViewController:self.webViewController];
}

- (FFWebViewController *)webViewController {
    if (!_webViewController) {
        _webViewController = [[FFWebViewController alloc] init];
    }
    return _webViewController;
}



@end
