//
//  FFOpenServerSelectView.m
//  GameBox
//
//  Created by 燚 on 2018/5/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFOpenServerSelectView.h"
#import "FFColorManager.h"


#define ButtonTag 10086

@interface FFOpenServerSelectView ()

@property (nonatomic, strong) UIView *cursorView;

@property (nonatomic, strong) NSMutableArray <UIButton *> *buttonArray;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *titleWidthArray;

@property (nonatomic, assign) NSUInteger selectIdx;
@property (nonatomic, assign) CGRect buttonBounds;

@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, assign) BOOL isAnimation;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation FFOpenServerSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame WithHeaderTitleArray:(NSArray *)array {
    self = [super initWithFrame:frame];
    return self;
}

#pragma mark - responds
- (void)respondsToButton:(UIButton *)sender {
    if (_isAnimation) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFOpenServerSelectView:didSelectTitleWithIndex:)]) {
        [self.delegate FFOpenServerSelectView:self didSelectTitleWithIndex:sender.tag - ButtonTag];
        _isAnimation = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.selectIdx = sender.tag - ButtonTag;
        } completion:^(BOOL finished) {
            _isAnimation = NO;
        }];
    } else {
        syLog(@"%s error : not found delegate ",__func__);
    }
}

#pragma mark - method


- (void)creatButtonWithTitleArray {
    [_titleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setTitle:obj forState:(UIControlStateNormal)];
        button.frame = CGRectMake(idx * kSCREEN_WIDTH / _titleArray.count, 0, kSCREEN_WIDTH / _titleArray.count, self.bounds.size.height);
        [button setTitleColor:self.normolColor forState:(UIControlStateNormal)];
        button.tag = ButtonTag + idx;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(respondsToButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.buttonArray addObject:button];
        [self addSubview:button];
    }];

    //计算 title 宽度
    [self signTitleArrayWidthWithTitleArray];
    //选中第一个下标
    [self setSelectIdx:0];
}

//计算 title 宽度
- (void)signTitleArrayWidthWithTitleArray; {
    _titleWidthArray = [NSMutableArray arrayWithCapacity:_titleArray.count];
    CGFloat Max_width = 0;
    for (NSString *title in _titleArray) {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize retSize = [title boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / _titleArray.count, self.bounds.size.height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        NSNumber *width = [NSNumber numberWithFloat:retSize.width];
        if (retSize.width > Max_width) {
            Max_width = retSize.width;
        }
        [_titleWidthArray addObject:width];
    }
}

#pragma mark - setter
- (void)setTitleArray:(NSArray<NSString *> *)titleArray {
    if (_buttonArray.count == titleArray.count) {
        int idx = 0;
        for (UIButton *button in _buttonArray) {
            [button setTitle:titleArray[idx] forState:(UIControlStateNormal)];
            idx++;
        }
    } else {
        _titleArray = titleArray;
        _buttonArray = nil;
        [self creatButtonWithTitleArray];
    }
    [self addSubview:self.cursorView];
    [self addSubview:self.lineView];
}

- (void)setSelectIdx:(NSUInteger)selectIdx {
    _selectIdx = selectIdx;

    self.cursorView.bounds = CGRectMake(0, 0, _titleWidthArray[selectIdx].floatValue + 20, self.buttonArray[selectIdx].bounds.size.height - 15);
    self.cursorView.center = self.buttonArray[selectIdx].center;
    self.cursorView.layer.cornerRadius = self.cursorView.bounds.size.height / 2;

    [self setButtonHeightLightWithIndex:selectIdx];
}

- (void)setButtonHeightLightWithIndex:(NSUInteger)idx {
    if (_lastButton) {
        [_lastButton setTitleColor:self.normolColor forState:(UIControlStateNormal)];
    }
    UIButton *button = self.buttonArray[idx];
    [button setTitleColor:self.selectColor forState:(UIControlStateNormal)];
    _lastButton = button;
}



#pragma mark - getter
- (NSMutableArray<UIButton *> *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray arrayWithCapacity:self.titleArray.count];
    }
    return _buttonArray;
}

- (UIView *)cursorView {
    if (!_cursorView) {
        _cursorView = [[UIView alloc] init];
        _cursorView.backgroundColor = [UIColor clearColor];
        _cursorView.layer.cornerRadius = 10;
        _cursorView.layer.masksToBounds = YES;
        _cursorView.layer.borderColor = [FFColorManager blue_dark].CGColor;
        _cursorView.layer.borderWidth = 1;
    }
    return _cursorView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 1, kSCREEN_WIDTH, 1)];
        _lineView.backgroundColor = [FFColorManager view_separa_line_color];
    }
    return _lineView;
}



@end
