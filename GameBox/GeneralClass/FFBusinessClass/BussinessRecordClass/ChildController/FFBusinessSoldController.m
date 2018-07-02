//
//  FFBusinessSoldController.m
//  GameBox
//
//  Created by 燚 on 2018/6/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessSoldController.h"

@interface FFBusinessSoldController ()

@property (nonatomic, strong) UIView *remindeHeader;

@end

@implementation FFBusinessSoldController

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.tableHeaderView = self.remindeHeader;
}

- (FFBusinessUserSellType)type {
    return FFBusinessUserSellTypeSold;
}

- (UIView *)remindeHeader {
    if (!_remindeHeader) {
        _remindeHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 70)];
        _remindeHeader.backgroundColor = [FFColorManager navigation_bar_white_color];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, kSCREEN_WIDTH - 16, 70)];
        label.text = @"交易成功后所得收入扣去服务费后将会自动转入您的支付宝，我们也会给您发送短信，如果长时间未收到请及时联系客服进行沟通";
        label.textColor = [FFColorManager blue_dark];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:13];
        [label sizeToFit];
        label.frame = CGRectMake(8, 8, kSCREEN_WIDTH - 16, label.bounds.size.height);

        _remindeHeader.frame = CGRectMake(0, 0, kSCREEN_WIDTH, label.bounds.size.height + 16);

        [_remindeHeader addSubview:label];
        [_remindeHeader.layer addSublayer:[self creatLineWithFrame:CGRectMake(0, _remindeHeader.bounds.size.height - 1, kSCREEN_WIDTH, 1)]];
    }
    return _remindeHeader;
}



@end






