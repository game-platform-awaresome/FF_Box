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
    [self addSubview:self.bannerView];
    [self addSubview:self.selectButtonView];
    [self setSelfBounds];
    self.layer.masksToBounds = YES;
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
    _bannerArray = bannerArray;
    if ([bannerArray isKindOfClass:[NSArray class]] && bannerArray.count > 0) {
        self.bannerView.rollingArray = [bannerArray mutableCopy];
    } else {
        self.bannerView.rollingArray = nil;
    }

    if (self.bannerView.rollingArray) {
        [self addSubview:self.bannerView];
        self.selectButtonView.frame = CGRectMake(0, CGRectGetMaxY(self.bannerView.frame) + 12, kSCREEN_WIDTH, 100);
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
            [button setTitle:obj forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [button setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateHighlighted)];
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
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [button setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateHighlighted)];
            [self.buttonArray addObject:button];
        }];
    }
    [self layoutButtons];
}

- (UIButton *)creatButtonWithIdx:(NSUInteger)idx {
    UIButton *button = [UIButton ff_instancetype];
    [button setTitleColor:[FFColorManager textColorDark] forState:(UIControlStateNormal)];
    [button setImage:[FFImageManager Home_activity] forState:(UIControlStateNormal)];
    button.tag = BTN_TAG + idx;
    button.frame = CGRectMake(4 + (((kSCREEN_WIDTH - 280 - 8) / 3) + 70) * idx, 0, 70, 100);
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
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(10, 12, kSCREEN_WIDTH - 20, 34)];
        self.searchHeaderFrame = _searchView.frame;
        self.searchScrollFrame = CGRectMake(kSCREEN_WIDTH - 54, 12, 44, 44);
        _searchView.backgroundColor = [FFColorManager home_search_view_background_color];
        _searchView.layer.cornerRadius = 8;
        _searchView.layer.masksToBounds = YES;

//        [_searchView addSubview:self.searchBarView];

        self.searchTitleButton = [UIButton hyb_buttonWithImage:[FFImageManager Home_search_image] superView:_searchView constraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointZero);
        } touchUp:^(UIButton *sender) {

        }];
        self.searchTitleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.searchTitleButton setTitleColor:[FFColorManager textColorLight] forState:(UIControlStateNormal)];

        self.searchScrollImage = [UIImageView hyb_imageViewWithImage:@"Home_scroll_search" superView:_searchView constraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointZero);
            make.size.mas_equalTo(CGSizeMake(57, 57));
        } onTaped:^(UITapGestureRecognizer *sender) {
            [self respondsToSearchView:sender];
        }];
        self.searchScrollImage.backgroundColor = kWhiteColor;
        self.searchScrollImage.alpha = 0;

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
        _bannerView = [[FFBasicBannerView alloc] initWithFrame:CGRectMake(10, 58, kSCREEN_WIDTH - 20, (kSCREEN_WIDTH - 20) * 0.4)];
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











