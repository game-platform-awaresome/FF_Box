//
//  FFBTServerHeaderView.m
//  GameBox
//
//  Created by 燚 on 2018/5/10.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBTServerHeaderView.h"
#import "FFBasicBannerView.h"

@interface FFBTServerHeaderView () <FFBasicBannerViewDelegate>

@property (nonatomic, strong) FFBasicBannerView *bannerView;

@property (nonatomic, strong) UIView *selectButtonView;


@end



@implementation FFBTServerHeaderView

- (instancetype)init {
    if (self = [super init]) {
        [self initUserInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    [self addSubview:self.searchBarView];
    [self addSubview:self.bannerView];
    [self addSubview:self.selectButtonView];
    [self setSelfBounds];
}


#pragma makr - Banner view delegate
- (void)FFBasicBannerView:(FFBasicBannerView *)view didSelectImageWithInfo:(NSDictionary *)info {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFBTServerHeaderView:didSelectImageWithInfo:)]) {
        [self.delegate FFBTServerHeaderView:self didSelectImageWithInfo:info];
    } else {
        syLog(@"%s error : delegate no exist",__func__);
    }
}

#pragma mark - setter
- (void)setBannerArray:(NSArray *)bannerArray {
    if ([bannerArray isKindOfClass:[NSArray class]] && bannerArray.count > 0) {
        self.bannerView.rollingArray = [bannerArray mutableCopy];
    } else {
        self.bannerView.rollingArray = nil;
    }

    if (self.bannerView.rollingArray) {
        self.bannerView.frame = CGRectMake(0, CGRectGetMaxY(self.searchBarView.frame), kSCREEN_WIDTH, kSCREEN_WIDTH * 0.4);
        self.selectButtonView.frame = CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), kSCREEN_WIDTH, 100);
    }
    [self setSelfBounds];
}

- (void)setSelfBounds {
    self.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, CGRectGetMaxY(self.selectButtonView.frame));
}

#pragma mark - getter
- (UIImageView *)searchBarView {
    if (!_searchBarView) {
        _searchBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
        _searchBarView.backgroundColor = [UIColor blackColor];
    }
    return _searchBarView;
}

- (FFBasicBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[FFBasicBannerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBarView.frame), kSCREEN_WIDTH, 0)];
        _bannerView.delegate = self;
        _bannerView.layer.masksToBounds = YES;
    }
    return _bannerView;
}

- (UIView *)selectButtonView {
    if (!_selectButtonView) {
        _selectButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), kSCREEN_WIDTH, 100)];
        _selectButtonView.backgroundColor = [UIColor redColor];
    }
    return _selectButtonView;
}




@end











