//
//  FFBasicSelectViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicSelectViewController.h"

@interface FFBasicSelectViewController () <UIScrollViewDelegate>


@end


@implementation FFBasicSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



#pragma mark - method
- (void)initUserInterface {
    [super initUserInterface];
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.scrollView];
}

- (void)initDataSource {
    [super initDataSource];
    self.selectViewHight = 44;
    self.SelectViewFrame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, self.selectViewHight);
}



#pragma mark - select view delegate
- (void)FFSelectHeaderView:(FFBasicSelectView *)view didSelectTitleWithIndex:(NSUInteger)idx {

    if (_isAnimatining || self.lastViewController == self.selectChildViewControllers[idx] || self.selectChildViewControllers.count == 0) {
        return;
    }

    if (idx > self.selectChildViewControllers.count) {
        syLog(@"选择的标题大于可以选择的控制器!!!");
        return;
    }

    if (self.lastViewController != nil) {
        [self childControllerAdd:self.selectChildViewControllers[idx]];
        [self childControllerRemove:self.lastViewController];
    } else {
        [self childControllerAdd:self.selectChildViewControllers[idx]];
    }

    self.lastViewController = self.selectChildViewControllers[idx];
    [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * idx, 0) animated:NO];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    //设置选择视图的浮标
    [self.selectView setCursorX:(x / scrollView.contentSize.width * kSCREEN_WIDTH)];

    CGFloat index = x / kSCREEN_WIDTH;
    NSInteger afterIndex = index * 10000;
    NSInteger i = afterIndex / 10000;
    NSInteger other = afterIndex % 10000;

    if (i < self.selectChildViewControllers.count - 1 && other != 0) {
        [self childControllerAdd:self.selectChildViewControllers[i]];
        [self childControllerAdd:self.selectChildViewControllers[i + 1]];
    } else if (other == 0) {
        if (i > 0) {
            [self childControllerRemove:self.selectChildViewControllers[i - 1]];
            if (i != self.selectChildViewControllers.count - 1) {
                [self childControllerRemove:self.selectChildViewControllers[i + 1]];
            }
        } else {
            [self childControllerAdd:self.selectChildViewControllers[0]];
            [self childControllerRemove:self.selectChildViewControllers[i + 1]];
        }
    }

    NSArray *array = self.childViewControllers;
    if (array.count == 1) {
        self.lastViewController = array[0];
    } else {
        self.lastViewController = nil;
    }
}

- (void)childControllerAdd:(UIViewController *)controller {
    [self addChildViewController:controller];
    [self.scrollView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

- (void)childControllerRemove:(UIViewController *)controller {
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.selectView.userInteractionEnabled = NO;
    _isAnimatining = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.selectView.userInteractionEnabled = YES;
    _isAnimatining = NO;
}

#pragma mark - layout subviews


#pragma mark - setter
- (void)setSelectChildViewControllers:(NSArray<UIViewController *> *)selectChildViewControllers {
    if (selectChildViewControllers == nil) {
        for (UIViewController *vc in _selectChildViewControllers) {
            [self childControllerRemove:vc];
        }
        [_selectChildViewControllers removeAllObjects];
        return;
    }
    _selectChildViewControllers = selectChildViewControllers.mutableCopy;
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * selectChildViewControllers.count, 0);
    [self childControllerAdd:self.selectChildViewControllers[0]];
    [self.scrollView addSubview:self.selectChildViewControllers[0].view];
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)layoutSubViews {
    for (UIViewController *vc in self.selectChildViewControllers) {
        vc.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.scrollView.bounds.size.height);
    }
}


#pragma mark - getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (FFBasicSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[FFBasicSelectView alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, self.selectViewHight)];
        _selectView.delegate = self;
        _selectView.lineColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return _selectView;
}





@end
