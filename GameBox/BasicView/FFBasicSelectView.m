//
//  FFBasicSelectView.m
//  GameBox
//
//  Created by 燚 on 2018/4/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicSelectView.h"
#import "FFColorManager.h"

#define ButtonTag 10086

@interface FFBasicSelectView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger selectTitleIndex;
@property (nonatomic, strong) UIView *cursorView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation FFBasicSelectView {
    CGRect totalFrame;
    CGSize scorllViewContentSize;
    CGRect buttonBounds;
    bool isAnimation;
    UIButton *lastButton;
};

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDataSource];
        [self initUserInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDataSource];
        [self initUserInterface];
        totalFrame = frame;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame WithHeaderTitleArray:(NSArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDataSource];
        [self initUserInterface];
        totalFrame = frame;
        self.headerTitleArray = array;
    }
    return self;
}


- (void)initUserInterface {
    [self addSubview:self.scrollView];
    [self addSubview:self.lineView];
}

- (void)initDataSource {
    _titleSize = CGSizeMake(0, 0);
    _titleNormalColor = [UIColor grayColor];
    _titleSelectColor = [FFColorManager blue_dark];
    _titleBackGroundColor = [UIColor clearColor];
    _cursorWidthEqualToTitleWidth = YES;
    _selectTitleIndex = 0;
    self.showCursorView = YES;
    totalFrame = CGRectMake(0, 0, kSCREEN_WIDTH, 50);
    self.cursorView.bounds = CGRectMake(0, 0, 0, 3);
}

#pragma mark - responds
/** responds button */
- (void)respondsToTitleButton:(UIButton *)sender {
    if (isAnimation) {

    } else {
        self.selectTitleIndex = sender.tag - ButtonTag;
        if (self.delegate && [self.delegate respondsToSelector:@selector(FFSelectHeaderView:didSelectTitleWithIndex:)]) {
            [self.delegate FFSelectHeaderView:self didSelectTitleWithIndex:sender.tag - ButtonTag];
        }
    }
}

#pragma mark - method
/** create button */
- (void)creatTitleButtonWithTitleArray:(NSArray<NSString *> *)titleArray {
    if (titleArray == nil || titleArray.count == 0) {
        return;
    }
    if (_titleButtonArray.count > 0 && _titleButtonArray.count == titleArray.count) {
        [_titleButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setTitle:titleArray[idx] forState:(UIControlStateNormal)];
        }];
        return;
    }

    _titleButtonArray = [NSMutableArray arrayWithCapacity:titleArray.count];

    [titleArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {

        UIButton *button = [self creatButtonWithIndex:idx WidthTitle:obj];

        [_titleButtonArray addObject:button];

        [self.scrollView addSubview:button];
    }];
}

- (UIButton *)creatButtonWithIndex:(NSUInteger)idx WidthTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(idx * self.titleSize.width, 0, self.titleSize.width, self.titleSize.height);
    [button setTitle:title forState:(UIControlStateNormal)];
    [button setTitleColor:self.titleNormalColor forState:(UIControlStateNormal)];
    button.tag = ButtonTag + idx;
    button.backgroundColor = self.titleBackGroundColor;
    [button addTarget:self action:@selector(respondsToTitleButton:) forControlEvents:(UIControlEventTouchUpInside)];
    return button;
}


@synthesize titleSize = _titleSize;
@synthesize cursorColor = _cursorColor;
@synthesize cursorCenter_Y = _cursorCenter_Y;
#pragma mark - setter
/** set frame */
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    totalFrame = frame;
    [self setButtonsHight:frame.size.height];
    self.lineView.frame = CGRectMake(0, frame.size.height - 2, kSCREEN_WIDTH, 2);
}

/** set button hight */
- (void)setButtonsHight:(CGFloat)hight {
    if (self.titleButtonArray.count > 0) {
        for (UIButton *button in self.titleButtonArray) {
            CGRect frame = button.frame;
            frame.size.height = hight;
            button.frame = frame;
        }
        self.cursorCenter_Y = hight - 4;
        self.lineView.frame = CGRectMake(0, hight - 2, kSCREEN_WIDTH, 2);
    }
}

- (void)setSelectTitleIndex:(NSInteger)selectTitleIndex {
    _selectTitleIndex = selectTitleIndex;

    if (_cursorWidthEqualToTitleWidth) {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize retSize = [self.titleButtonArray[0].titleLabel.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / self.titleButtonArray.count, 30) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        self.cursorView.bounds = CGRectMake(0, 0, (retSize.width + 5), _cursorView.bounds.size.height);
    } else {
        self.cursorView.bounds = CGRectMake(0, 0, _cursorView.bounds.size.width, _cursorView.bounds.size.height);
    }


    [self setButtonHighlightedWintIndex:_selectTitleIndex];

    [self.scrollView sendSubviewToBack:self.cursorView];
    isAnimation = YES;

    [UIView animateWithDuration:0.3 animations:^{
        self.cursorView.center = CGPointMake(self.titleButtonArray[_selectTitleIndex].center.x, self.cursorView.center.y);
    } completion:^(BOOL finished) {
        isAnimation = NO;
        [self.scrollView sendSubviewToBack:self.cursorView];
    }];
}


- (void)setTitleSize:(CGSize)titleSize {
    _titleSize = titleSize;
    if (_titleButtonArray.count > 0) {
        int i = 0;
        for (UIButton *button in _titleButtonArray) {
            button.frame = CGRectMake(titleSize.width * i, 0, titleSize.width, titleSize.height);
            i++;
        }
    }
    if (_canScrollTitle) {
        self.scrollView.contentSize = CGSizeMake(titleSize.width * self.titleButtonArray.count, totalFrame.size.height);
        [self.titleButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(idx * titleSize.width, 0, titleSize.width, titleSize.height);
        }];
        [self setSelectTitleIndex:_selectTitleIndex];
    }
}

- (void)setCursorSize:(CGSize)cursorSize {
    if (!_cursorWidthEqualToTitleWidth) {
        _cursorSize = cursorSize;
        self.cursorView.bounds = CGRectMake(0, 0, cursorSize.width, cursorSize.height);
    }
}

- (void)setHeaderTitleArray:(NSArray *)headerTitleArray {
    _headerTitleArray = headerTitleArray;
    //creat title button
    [self creatTitleButtonWithTitleArray:_headerTitleArray];

    if (_cursorWidthEqualToTitleWidth) {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize retSize = [self.titleButtonArray[0].titleLabel.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / self.titleButtonArray.count, 30) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        self.cursorView.bounds = CGRectMake(0, 0, (retSize.width + 5), _cursorView.bounds.size.height);
    } else {
        self.cursorView.bounds = CGRectMake(0, 0, _cursorView.bounds.size.width, _cursorView.bounds.size.height);
    }

    [self setButtonHighlightedWintIndex:_selectTitleIndex];
    self.cursorView.center = CGPointMake(self.titleButtonArray[0].center.x, self.cursorView.center.y);
}

- (void)setShowCursorView:(BOOL)showCursorView {
    _showCursorView = showCursorView;
    if (showCursorView) {
        [self.scrollView addSubview:self.cursorView];
        //        [self.scrollView sendSubviewToBack:self.cursorView];
    } else {
        [self.cursorView removeFromSuperview];
    }
}

- (void)setCursorColor:(UIColor *)cursorColor {
    _cursorColor = cursorColor;
    self.cursorView.backgroundColor = cursorColor;
}

- (void)setCursorCenter_Y:(CGFloat)cursorCenter_Y {
    _cursorCenter_Y = cursorCenter_Y;
    self.cursorView.center = CGPointMake(self.cursorView.center.x, cursorCenter_Y);
}

- (void)setCursorX:(CGFloat)x {
    CGFloat count = (float)self.titleButtonArray.count;
    x += self.titleButtonArray[0].center.x;
    self.cursorView.center = CGPointMake(x, self.cursorView.center.y);
    NSInteger index = x / (kSCREEN_WIDTH / count);
    [self setButtonHighlightedWintIndex:index];
}

- (void)setButtonHighlightedWintIndex:(NSUInteger)idx {
    if (lastButton) {
        [lastButton setTitleColor:self.titleNormalColor forState:(UIControlStateNormal)];
    }
    UIButton *button = self.titleButtonArray[idx];

    [button setTitleColor:self.titleSelectColor forState:(UIControlStateNormal)];
    lastButton = button;
}

- (void)setLineColor:(UIColor *)lineColor {
    if (lineColor) {
        self.lineView.backgroundColor = lineColor;
    }
}

#pragma mark - getter
- (CGSize)titleSize {
    if (_titleSize.width == 0 || _titleSize.height == 0) {
        _titleSize = CGSizeMake(totalFrame.size.width / self.headerTitleArray.count, totalFrame.size.height - 4);
    }
    return _titleSize;
}

- (UIView *)cursorView {
    if (!_cursorView) {
        _cursorView = [[UIView alloc] init];
        _cursorView.center = CGPointMake(self.titleButtonArray[0].center.x, totalFrame.size.height - 4);
        _cursorView.backgroundColor = self.cursorColor;
        _cursorView.layer.cornerRadius = 1;
        _cursorView.layer.masksToBounds = YES;
    }
    return _cursorView;
}

- (UIColor *)cursorColor {
    if (!_cursorColor) {
        _cursorColor = [FFColorManager blue_dark];
    }
    return _cursorColor;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, totalFrame.size.width, totalFrame.size.height)];
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (CGFloat)cursorCenter_Y {
    if (_cursorCenter_Y == 0) {
        _cursorCenter_Y = totalFrame.size.height - 4;
    }
    return _cursorCenter_Y;
}

- (CALayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [[CALayer alloc] init];
        _lineLayer.bounds = CGRectMake(0, 0, totalFrame.size.width, 2);
    }
    return _lineLayer;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, totalFrame.size.height - 1, kSCREEN_WIDTH, 1)];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}



@end






