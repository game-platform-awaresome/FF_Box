//
//  FFRRebateViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/2.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRRebateViewController.h"
#import "FFRebateSelectView.h"
#import "FFApplyRebateViewController.h"
#import "FFRebateRecordViewController.h"
#import "FFRebateNoticeViewController.h"
#import "FFRebateModel.h"

@interface FFRRebateViewController ()<FFRebateSelectViewDelegate, UIScrollViewDelegate>

/** 滚动返利 */
@property (nonatomic, strong) UIView *titleScrollView;
@property (nonatomic, strong) UILabel *titleScrollViewA;
@property (nonatomic, strong) UILabel *titleScrollViewB;
@property (nonatomic, strong) NSArray *titleScrollArray;
@property (nonatomic, assign) NSInteger titleScrollIndex;

/** 选择视图 */
@property (nonatomic, strong) FFRebateSelectView *selectView;
/** 分割视图 */
@property (nonatomic, strong) UIView *separateView;
/** 右边视图 */
@property (nonatomic, strong) UIBarButtonItem *rightButton;

/** 申请返利视图 */
@property (nonatomic, strong) FFApplyRebateViewController *applyReabeViewController;
/** 返利记录 */
@property (nonatomic, strong) FFRebateRecordViewController *rebateRecordViewController;
/** 返利须知 */
@property (nonatomic, strong) FFRebateNoticeViewController *rebateNoticeViewController;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *hChildControllers;

@end

@implementation FFRRebateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}



- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"申请返利";
    self.navigationItem.rightBarButtonItem = self.rightButton;
    [self.titleScrollView addSubview:self.titleScrollViewA];
    [self.titleScrollView addSubview:self.titleScrollViewB];
    [self.view addSubview:self.titleScrollView];
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.separateView];
    [self.view addSubview:self.scrollView];
}


- (void)initDataSource {
    _hChildControllers = @[self.applyReabeViewController, self.rebateRecordViewController];
    [self addChildViewController:self.applyReabeViewController];
    [self.scrollView addSubview:self.applyReabeViewController.view];
    [self.applyReabeViewController didMoveToParentViewController:self];
    _titleScrollIndex = 0;
    self.titleScrollArray = nil;
    [self loadScrollTitleData];
}

- (void)loadScrollTitleData {
    [FFRebateModel rebateScrollTitleWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            syLog(@"rebate scroll title == %@",content);
            NSArray *array = content[@"data"];
            if (array.count > 0) {
                self.titleScrollArray = array;
                [self scrollTitleView];
            }
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loadScrollTitleData];
            });
        }
    }];
}





/** 上方标题滚动 */
- (void)scrollTitleView {
    CGRect normalFrame = self.titleScrollView.bounds;
    CGRect downFrame = CGRectMake(0, self.titleScrollView.bounds.size.height, kSCREEN_WIDTH, self.titleScrollView.bounds.size.height);
    CGRect upFrame = CGRectMake(0, -self.titleScrollView.bounds.size.height, kSCREEN_WIDTH, self.titleScrollView.bounds.size.height);

    if (_titleScrollIndex == (self.titleScrollArray.count)) {
        _titleScrollIndex = 0;
    }

    id detail = self.titleScrollArray[_titleScrollIndex];
    if ([detail isKindOfClass:[NSDictionary class]]) {
        NSString *name = detail[@"rolename"] ? detail[@"rolename"] : detail[@"username"];
        self.titleScrollViewB.text = [NSString stringWithFormat:@"%@申请了%@元返利",name,detail[@"amount"]];
    } else if ([detail isKindOfClass:[NSString class]]) {
        self.titleScrollViewB.text = self.titleScrollArray[(_titleScrollIndex)];
    }

    [UIView animateWithDuration:2 animations:^{
        self.titleScrollViewA.frame = upFrame;
        self.titleScrollViewB.frame = normalFrame;
    } completion:^(BOOL finished) {
        self.titleScrollViewA.text = self.titleScrollViewB.text;
        self.titleScrollViewA.frame = normalFrame;
        self.titleScrollViewB.frame = downFrame;
        _titleScrollIndex++;
        if (self.titleScrollArray > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self scrollTitleView];
            });
        }
    }];

}


#pragma mark - responds
- (void)respondsToRightButton {
    HIDE_TABBAR;
    [self.navigationController pushViewController:self.rebateNoticeViewController animated:YES];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    //设置选择视图的浮标

    [self.selectView reomveLabelWithX:(x / scrollView.contentSize.width * kSCREEN_WIDTH)];

    CGFloat index = x / kSCREEN_WIDTH;
    NSInteger afterIndex = index * 10000;
    NSInteger i = afterIndex / 10000;
    NSInteger other = afterIndex % 10000;

    if (i < _hChildControllers.count - 1 && other != 0) {
        [self hAddChildViewController:_hChildControllers[i]];
        [self hAddChildViewController:_hChildControllers[i + 1]];
    } else if (other == 0) {
        if (i > 0) {
            [self hChildControllerRemove:_hChildControllers[i - 1]];
            if (i != _hChildControllers.count - 1) {
                [self hChildControllerRemove:_hChildControllers[i + 1]];
            }
        } else {
            [self hChildControllerRemove:_hChildControllers[i + 1]];
        }
    }
}

- (void)hAddChildViewController:(UIViewController *)controller {
    [self addChildViewController:controller];
    [self.scrollView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

- (void)hChildControllerRemove:(UIViewController *)controller {
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}


#pragma mark - select view delegate
- (void)FFRebateSelectView:(FFRebateSelectView *)selectView didSelectBtnAtIndexPath:(NSInteger)idx {
    [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * idx, 0) animated:YES];
}


#pragma mark - getter
- (UIView *)titleScrollView {
    if (!_titleScrollView) {
        _titleScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, 44)];
        _titleScrollView.backgroundColor = BOX_GRARCOLOR;
        [_titleScrollView setClipsToBounds:YES];
    }
    return _titleScrollView;
}

- (UILabel *)titleScrollViewA {
    if (!_titleScrollViewA) {
        _titleScrollViewA = [[UILabel alloc] initWithFrame:self.titleScrollView.bounds];
        _titleScrollViewA.text = @"返利详情";
        _titleScrollViewA.textAlignment = NSTextAlignmentCenter;
    }
    return _titleScrollViewA;
}

- (UILabel *)titleScrollViewB {
    if (!_titleScrollViewB) {
        _titleScrollViewB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScrollViewA.frame), kSCREEN_WIDTH, self.titleScrollView.bounds.size.height)];
        _titleScrollViewB.text = @"返利详情";
        _titleScrollViewB.textAlignment = NSTextAlignmentCenter;
    }
    return _titleScrollViewB;
}

- (NSArray *)titleScrollArray {
    if (!_titleScrollArray) {
        _titleScrollArray = @[@"返利详情",@"返利详情"];
    }
    return _titleScrollArray;
}

- (FFRebateSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[FFRebateSelectView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), kSCREEN_WIDTH, 60) WithBtnArray:@[@"申请返利",@"返利记录"]];

        _selectView.delegate = self;
    }
    return _selectView;
}

- (UIView *)separateView {
    if (!_separateView) {
        _separateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectView.frame), kSCREEN_WIDTH, 10)];
        _separateView.backgroundColor = BOX_GRARCOLOR;
    }
    return _separateView;
}

- (UIBarButtonItem *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIBarButtonItem alloc] initWithTitle:@"须知" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];
//        _rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];
    }
    return _rightButton;
}

- (FFApplyRebateViewController *)applyReabeViewController {
    if (!_applyReabeViewController) {
        _applyReabeViewController = [[FFApplyRebateViewController alloc] init];
        _applyReabeViewController.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - (CGRectGetMaxY(self.separateView.frame)));
    }
    return _applyReabeViewController;
}

- (FFRebateRecordViewController *)rebateRecordViewController {
    if (!_rebateRecordViewController) {
        _rebateRecordViewController = [[FFRebateRecordViewController alloc] init];
        _rebateRecordViewController.view.frame = CGRectMake(kSCREEN_WIDTH, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - (CGRectGetMaxY(self.separateView.frame)));
    }
    return _rebateRecordViewController;
}

- (FFRebateNoticeViewController *)rebateNoticeViewController {
    if (!_rebateNoticeViewController) {
        _rebateNoticeViewController = [[FFRebateNoticeViewController alloc] init];
    }
    return _rebateNoticeViewController;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.separateView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - (CGRectGetMaxY(self.separateView.frame)))];
        _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * 2, _scrollView.frame.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
#ifdef DEBUG
        _scrollView.backgroundColor = [UIColor grayColor];
#else
        _scrollView.backgroundColor = [UIColor whiteColor];
#endif
    }
    return _scrollView;
}




@end













