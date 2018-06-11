//
//  FFBusinessHeaderView.m
//  GameBox
//
//  Created by 燚 on 2018/6/11.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessHeaderView.h"

#define Button_tag 10085
#define Button_Height 60

@interface FFBusinessHeaderView ()



@end


@implementation FFBusinessHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, Button_Height + 20);
    [self creatButton];
}

- (void)creatButton {
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.tag = Button_tag + i;
        [button addTarget:self action:@selector(respondsToButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Business_%d",i]] forState:(UIControlStateNormal)];
        button.frame = CGRectMake((kSCREEN_WIDTH - Button_Height * 4) / 8 + ((kSCREEN_WIDTH - Button_Height * 4) / 4 + Button_Height) * i, 20, Button_Height, Button_Height);
        [self addSubview:button];
    }
}


- (void)respondsToButton:(UIButton *)sender {
    if (&clickButton) {
        clickButton(sender.tag - Button_tag);
    }
}




@end




