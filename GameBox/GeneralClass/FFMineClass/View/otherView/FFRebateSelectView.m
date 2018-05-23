//
//  FFRebateSelectView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/2.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRebateSelectView.h"

#define BTNTAG 1400
#define BUTTON_SIZE [_buttons[_index].titleLabel.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / _buttons.count, 30)\
options:NSStringDrawingTruncatesLastVisibleLine |\
NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading\
attributes:attribute context:nil].size

@interface FFRebateSelectView()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;


@property (nonatomic, strong) UIButton *lastBtn;


@end

@implementation FFRebateSelectView

- (instancetype)initWithFrame:(CGRect)frame WithBtnArray:(NSArray *)btnNameArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnNameArray = btnNameArray;
        _isAnimation = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.line.frame = CGRectMake(0, frame.size.height - 3, kSCREEN_WIDTH, 3);
}


- (void)setBtnNameArray:(NSArray *)btnNameArray {
    _btnNameArray = btnNameArray;

    _buttons = [NSMutableArray arrayWithCapacity:btnNameArray.count];

    [_btnNameArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {

        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(idx * kSCREEN_WIDTH / _btnNameArray.count, 0, kSCREEN_WIDTH / self.btnNameArray.count, self.frame.size.height - 3);

        [button setTitle:obj forState:(UIControlStateNormal)];

        button.tag = BTNTAG + idx;
        button.backgroundColor = [UIColor whiteColor];

        [button addTarget:self action:@selector(respondstoBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        if (idx == 0) {
            [button setTitleColor:self.textColor forState:(UIControlStateNormal)];
            _lastBtn = button;
        } else {
            [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        }

        [_buttons addObject:button];

        [self addSubview:button];
    }];

    [self addSubview:self.line];
    [self addSubview:self.seleView];
}

- (void)setIndex:(NSInteger)index {
    _index = index;

    if (_lastBtn) {
        [_lastBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    }

    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize retSize = [_buttons[_index].titleLabel.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / _buttons.count, 30)
                                                                    options:NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                                                 attributes:attribute context:nil].size;

    [_buttons[_index] setTitleColor:self.textColor forState:(UIControlStateNormal)];

    self.seleView.bounds = CGRectMake(0, 0, (retSize.width + 10), 3);

//    [UIView animateWithDuration:0.3 animations:^{
//        self.seleView.center = CGPointMake(_buttons[_index].center.x, self.line.center.y);
//    }];

    _lastBtn = _buttons[_index];
}

- (void)setLineColor:(UIColor *)lineColor {
    self.line.backgroundColor = lineColor;
}


- (void)reomveLabelWithX:(CGFloat)x {
    CGFloat count = (float)_buttons.count;
    x += _buttons[0].center.x;
    self.seleView.center = CGPointMake(x, self.line.center.y);
    NSInteger index = x / (kSCREEN_WIDTH / count);
    if (index != _index) {
        [self setSelectButtonWithIndex:index];
    }
}

- (void)setSelectButtonWithIndex:(NSInteger)index {
    _index = index;

    if (_lastBtn) {
        [_lastBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    }

    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize retSize = [_buttons[_index].titleLabel.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / _buttons.count, 30)
                                                                    options:NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                                                 attributes:attribute context:nil].size;

    self.seleView.bounds = CGRectMake(0, 0, (retSize.width + 10), 3);
    [_buttons[_index] setTitleColor:self.textColor forState:(UIControlStateNormal)];

    _lastBtn = _buttons[_index];
}

#pragma mark - respondstoBtn
- (void)respondstoBtn:(UIButton *)sender {
    if (_isAnimation) {

    } else {
        self.index = sender.tag - BTNTAG;
        if (self.delegate && [self.delegate respondsToSelector:@selector(FFRebateSelectView:didSelectBtnAtIndexPath:)]) {
            [self.delegate FFRebateSelectView:self didSelectBtnAtIndexPath:sender.tag - BTNTAG];
        }
    }
}


#pragma mark - getter
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    }
    return _line;
}


- (UIView *)seleView {
    if (!_seleView) {
        _seleView = [[UIView alloc] init];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize retSize = [_buttons[0].titleLabel.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / _buttons.count, 30) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        _seleView.bounds = CGRectMake(0, 0, (retSize.width + 10), 3);
        _seleView.center = CGPointMake(_buttons[0].center.x, self.line.center.y);
        _seleView.backgroundColor = [UIColor orangeColor];
        _seleView.layer.cornerRadius = 1;
        _seleView.layer.masksToBounds = YES;
    }
    return _seleView;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = [UIColor orangeColor];
    }
    return _textColor;
}





@end
