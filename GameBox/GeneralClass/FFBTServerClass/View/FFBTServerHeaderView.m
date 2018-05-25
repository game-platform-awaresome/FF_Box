//
//  FFBTServerHeaderView.m
//  GameBox
//
//  Created by 燚 on 2018/5/10.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBTServerHeaderView.h"
#import "FFBasicBannerView.h"
#import <FFTools/FFTools.h>
#import "FFColorManager.h"
#import "FFImageManager.h"

#define BTN_TAG 12345

@interface FFBTServerHeaderView () <FFBasicBannerViewDelegate>

@property (nonatomic, strong) FFBasicBannerView *bannerView;

@property (nonatomic, strong) UIView *selectButtonView;

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;

@property (nonatomic, strong) UIView *buttonView;

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
    [self addSubview:self.searchView];
    [self.searchView addSubview:self.searchBarView];
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

#pragma mark - responds to button
- (void)respondsToTitleButton:(UIButton *)sender {
    syLog(@"点击按钮  === %@",self.buttonArray[sender.tag - BTN_TAG]);
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFBTServerHeaderView:didSelectButtonWithInfo:)]) {
        [self.delegate FFBTServerHeaderView:self didSelectButtonWithInfo:[NSNumber numberWithInteger:(sender.tag - BTN_TAG)]];
    }
}

- (void)respondsToSearchView:(UITapGestureRecognizer *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFBTServerHeaderView:didSelectSearchViewWithInfo:)]) {
        [self.delegate FFBTServerHeaderView:self didSelectSearchViewWithInfo:nil];
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
        [self addSubview:self.bannerView];
        self.selectButtonView.frame = CGRectMake(0, CGRectGetMaxY(self.bannerView.frame) + 10, kSCREEN_WIDTH, 100);
    } else {
        [self.bannerView removeFromSuperview];
        self.selectButtonView.frame = CGRectMake(0, 54, kSCREEN_WIDTH, 100);
    }
    [self setSelfBounds];
}

- (void)setSelfBounds {
    self.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, CGRectGetMaxY(self.selectButtonView.frame));
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    if (self.buttonArray.count == titleArray.count) {
        unsigned i = 0;
        for (UIButton *button in self.buttonArray) {
            [button setTitle:titleArray[i] forState:(UIControlStateNormal)];
            [button layoutButtonWithImageStyle:(FFButtonImageOnTop) imageTitleSpace:0];
            i++;
        }
    } else {
        if (self.buttonArray) {
            for (UIButton *button in self.buttonArray) {
                [button removeFromSuperview];
            }
        }
        self.buttonArray = [NSMutableArray arrayWithCapacity:titleArray.count];
        [titleArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [self creatButtonWithIdx:idx];
            [button setNormalTitle:obj HighlightedTitle:nil NormalImage:nil HighlightedImage:nil NormalTitleColor:[UIColor blackColor] HighlightedTitleColor:[FFColorManager blue_dark]];
            [self.buttonArray addObject:button];
        }];
    }
    [self layoutButtons];
}

- (void)setImageArray:(NSArray<UIImage *> *)imageArray {
    _imageArray = imageArray;
    if (self.buttonArray.count == imageArray.count) {
        unsigned i = 0;
        for (UIButton *button in self.buttonArray) {
            [button setImage:imageArray[i] forState:(UIControlStateNormal)];
            i++;
        }
    } else {
        if (self.buttonArray) {
            for (UIButton *button in self.buttonArray) {
                [button removeFromSuperview];
            }
        }
        self.buttonArray = [NSMutableArray arrayWithCapacity:imageArray.count];
        [imageArray enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [self creatButtonWithIdx:idx];
            [button setNormalTitle:nil HighlightedTitle:nil NormalImage:obj HighlightedImage:nil NormalTitleColor:[UIColor blackColor] HighlightedTitleColor:[FFColorManager blue_dark]];
            [self.buttonArray addObject:button];
        }];
    }
    [self layoutButtons];
}

- (UIButton *)creatButtonWithIdx:(NSUInteger)idx {
    UIButton *button = [UIButton createButton];
    [button setImage:[FFImageManager Home_activity] forState:(UIControlStateNormal)];
    button.tag = BTN_TAG + idx;
    button.frame = CGRectMake(20 + (((kSCREEN_WIDTH - 280) / 3) + 60) * idx, 0, 60, 100);
    [button addTarget:self action:@selector(respondsToTitleButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.selectButtonView addSubview:button];
    return button;
}

- (void)layoutButtons {
    for (UIButton * button in self.buttonArray) {
        [button layoutButtonWithImageStyle:(FFButtonImageOnTop) imageTitleSpace:4];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
}


#pragma mark - getter
- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH * 0.05, 5, kSCREEN_WIDTH * 0.9, 30)];
        _searchView.backgroundColor = [FFColorManager home_search_view_background_color];
        _searchView.layer.cornerRadius = 8;
        _searchView.layer.masksToBounds = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSearchView:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_searchView addGestureRecognizer:tap];
    }
    return _searchView;
}
- (UIImageView *)searchBarView {
    if (!_searchBarView) {
        _searchBarView = [[UIImageView alloc] initWithImage:[FFImageManager Home_search_image]];
//        _searchBarView.bounds = CGRectMake(0, 0, 20, 20);
        _searchBarView.center = CGPointMake(self.searchView.bounds.size.width / 2, self.searchView.bounds.size.height / 2);
    }
    return _searchBarView;
}

- (FFBasicBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[FFBasicBannerView alloc] initWithFrame:CGRectMake(4, 44, kSCREEN_WIDTH - 8, kSCREEN_WIDTH * 0.4)];
        _bannerView.delegate = self;
        _bannerView.layer.masksToBounds = YES;
    }
    return _bannerView;
}

- (UIView *)selectButtonView {
    if (!_selectButtonView) {
        _selectButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kSCREEN_WIDTH, 100)];
        _selectButtonView.backgroundColor = [UIColor whiteColor];
    }
    return _selectButtonView;
}





@end











