//
//  FFBasicBannerView.m
//  GameBox
//
//  Created by 燚 on 2018/5/11.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicBannerView.h"
#import "FFImageManager.h"
#import <UIImageView+WebCache.h>

#define CELLIDE @"FFBasicBannerViewCell"


@interface FFBasicBannerView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
/**滚动视图*/
@property (nonatomic, strong) UICollectionView * collectionView;

/**分页控制器*/
@property (nonatomic, strong) UIPageControl * pageControl;

/**计时器*/
@property (nonatomic, strong) NSTimer * timer;

@end



@implementation FFBasicBannerView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface {
    [self addSubview:self.collectionView];
}

#pragma mark - setter
- (void)setRollingArray:(NSArray *)rollingArray {
    [self stopTimer];

    if (rollingArray.count != 0) {
        _rollingArray = [rollingArray mutableCopy];
        [_rollingArray insertObject:rollingArray[_rollingArray.count - 1] atIndex:0];
        [_rollingArray addObject:rollingArray[0]];
    }

    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(kSCREEN_WIDTH, 0)];

    self.pageControl.numberOfPages = rollingArray.count;
    self.pageControl.center = CGPointMake(kSCREEN_WIDTH / 2, self.bounds.size.height - 20);
    [self startTimer];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.collectionView.frame = self.bounds;
    if (self.bounds.size.height < 1) {
        [self.pageControl removeFromSuperview];
    } else {
        self.pageControl.center = CGPointMake(kSCREEN_WIDTH / 2, self.bounds.size.height - 20);
        [self addSubview:self.pageControl];
    }
    self.layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

#pragma mark - 自动转换视图
//定时器的监听
- (void)autoImage {
    CGFloat offset = self.collectionView.contentOffset.x;
    [self.collectionView setContentOffset:CGPointMake(offset + kSCREEN_WIDTH, 0) animated:YES];
}

// 开启定时器
- (void)startTimer {
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(autoImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

// 停止定时器
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

//滚动结束时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    if (offset > kSCREEN_WIDTH * (self.rollingArray.count - 2)) {
        scrollView.contentOffset = CGPointMake(kSCREEN_WIDTH, 0);
    }
    if (offset < kSCREEN_WIDTH) {
        scrollView.contentOffset = CGPointMake(kSCREEN_WIDTH * (self.rollingArray.count - 2), 0);
    }
}

// 动画时候调用的代理方法(结束滚动时候调用)
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

#pragma mark - 当手动拖拽的时候
// 手动即将拖拽的时候停止计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

// 手动拖拽结束的时候开启计时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

#pragma mark - 滚动中监听方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获得当前偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    // 转换成页数
    NSInteger pageNum = offsetX / kSCREEN_WIDTH + 0.5;
    // 设置分页器的当前页数
    self.pageControl.currentPage = pageNum - 1;
}


#pragma mark - collectionviewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rollingArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLIDE forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.backgroundColor = [UIColor orangeColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,self.rollingArray[indexPath.row][@"slide_pic"]]] placeholderImage:[FFImageManager Basic_Banner_placeholder]];
    [cell addSubview:imageView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFBasicBannerView:didSelectImageWithInfo:)]) {
        [self.delegate FFBasicBannerView:self didSelectImageWithInfo:_rollingArray[indexPath.item]];
    }
}

#pragma mark - getter
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELLIDE];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.bounds = CGRectMake(0, 0, 100, 20);
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}



@end
