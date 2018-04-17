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



#pragma mark - getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
    }
    return _scrollView;
}










@end
