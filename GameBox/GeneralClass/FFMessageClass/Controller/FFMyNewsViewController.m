//
//  FFMyNewViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/23.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMyNewsViewController.h"
#import "FFRebateSelectView.h"

#import "FFNewsViewController.h"
#import "FFNotificationViewController.h"
#import "FFSystemInfoController.h"


@interface FFMyNewsViewController () <FFRebateSelectViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) FFRebateSelectView *selectView;
@property (nonatomic, strong) UIScrollView *scrollView;

/** 系统通知 */
@property (nonatomic, strong) FFSystemInfoController *systemInfoController;
/** 评论回复 */
@property (nonatomic, strong) FFNewsViewController *newsController;
/** 开服通知 */
@property (nonatomic, strong) FFNotificationViewController *noticicationController;

@end

static FFMyNewsViewController *controller = nil;

@implementation FFMyNewsViewController

+ (FFMyNewsViewController *)sharedController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[FFMyNewsViewController alloc] init];
    });
    return controller;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.newsController refreshData];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
    [self initDataSource];
}

- (void)initUserInterface {
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationItem.title = @"我的消息";
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.scrollView];
}

- (void)initDataSource {

}

#pragma mark - select view delegate
- (void)FFRebateSelectView:(FFRebateSelectView *)selectView didSelectBtnAtIndexPath:(NSInteger)idx {
    [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * idx, 0) animated:YES];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    //设置选择视图的浮标

    [self.selectView reomveLabelWithX:(x / scrollView.contentSize.width * kSCREEN_WIDTH)];

    if (x == kSCREEN_WIDTH * 2) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空开服通知" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];
    }  else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - responds
- (void)respondsToRightButton {
//    [self.noticicationController deleteAllNotification];
}

#pragma mark - getter
- (FFRebateSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[FFRebateSelectView alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 60) WithBtnArray:@[@"系统消息",@"评论回复",@"开服通知"]];
        [_selectView setLineColor:BACKGROUND_COLOR];
        _selectView.delegate = self;
    }
    return _selectView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - (CGRectGetMaxY(self.selectView.frame)))];
        _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * 3, _scrollView.frame.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:self.newsController.view];
        [_scrollView addSubview:self.noticicationController.view];
        [_scrollView addSubview:self.systemInfoController.view];
        [_scrollView setScrollEnabled:NO];
    }
    return _scrollView;
}

- (FFSystemInfoController *)systemInfoController {
    if (!_systemInfoController) {
        _systemInfoController = [[FFSystemInfoController alloc] init];
        _systemInfoController.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.selectView.frame));
        [_systemInfoController willMoveToParentViewController:self];
        [self addChildViewController:_systemInfoController];
    }
    return _systemInfoController;
}

- (FFNewsViewController *)newsController {
    if (!_newsController) {
        _newsController = [[FFNewsViewController alloc] init];
        _newsController.view.frame = CGRectMake(kSCREEN_WIDTH, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.selectView.frame));
        [_newsController willMoveToParentViewController:self];
        [self addChildViewController:_newsController];
    }
    return _newsController;
}

- (FFNotificationViewController *)noticicationController {
    if (!_noticicationController) {
        _noticicationController = [[FFNotificationViewController alloc] init];
        _noticicationController.view.frame = CGRectMake(kSCREEN_WIDTH * 2, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.selectView.frame));
        [_noticicationController willMoveToParentViewController:self];
        [self addChildViewController:_noticicationController];
    }
    return _noticicationController;
}









@end
