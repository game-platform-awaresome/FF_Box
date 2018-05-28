//
//  LaunchScreen.m
//  GameBox
//
//  Created by 石燚 on 2017/5/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "FFLaunchScreen.h"

@interface FFLaunchScreen ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *imageNameArray;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation FFLaunchScreen

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    //    [self addSubview:self.loginBtn];
    [self addScrollImage];
}

#pragma mark - method
- (void)clickLoginBtn {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}


//添加滚动图片的方法
- (void)addScrollImage {
    for (NSInteger index = 0; index < self.imageNameArray.count; index++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(kSCREEN_WIDTH * index, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        imageView.image = [UIImage imageNamed:self.imageNameArray[index]];
        //添加图片视图到滚动视图
        [self.scrollView addSubview:imageView];
    }
    //添加完后根据视图设置滚动范围
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * self.imageNameArray.count, 0);
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.loginBtn];
}

#pragma mark - 滚动中监听方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获得当前偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    // 转换成页数
    NSInteger pageNum = offsetX / kSCREEN_WIDTH + 0.5;
    // 设置分页器的当前页数
    self.pageControl.currentPage = pageNum;
}


#pragma mark - getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = RGBCOLOR(246, 171, 27);
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 3, 30);
        _pageControl.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.9);
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _loginBtn.frame = CGRectMake(kSCREEN_WIDTH - 100, 40, 74, 40);
        [_loginBtn setTitle:@"跳过" forState:(UIControlStateNormal)];
        [_loginBtn setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.6]];
        
        
        [_loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_loginBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateHighlighted)];
        
        _loginBtn.layer.cornerRadius = 20;
        _loginBtn.layer.masksToBounds = YES;
//        _loginBtn.layer.borderWidth = 2;
//        _loginBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    }
    return _loginBtn;
}


- (NSArray *)imageNameArray {
    if (!_imageNameArray) {
        _imageNameArray = @[@"yindaoye1",@"yindaoye2",@"yindaoye3"];
    }
    return _imageNameArray;
}




@end
