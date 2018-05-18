//
//  FFBasicSSTableViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicSSTableViewController.h"

@interface FFBasicSSTableViewController ()

@end

@implementation FFBasicSSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView.mj_header = nil;
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

- (void)refresh {
    
}

- (void)viewDidLayoutSubviews {
    self.tableView.frame = self.view.bounds;
}




@end
