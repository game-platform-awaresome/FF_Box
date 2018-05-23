//
//  FFPlatformCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFPlatformCell.h"

@implementation FFPlatformCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDict:(NSDictionary *)dict {
    self.type = dict[@"type"];
    self.change = dict[@"platform_change"];
    self.balance = dict[@"platform_counts"];
    self.time = dict[@"create_time"];
}



- (void)setType:(NSString *)type {
    switch (type.integerValue) {
        case 1:
            self.typeLabel.text = @"金币兑换";
            break;
        case 2:
            self.typeLabel.text = @"游戏支付";
            break;
        case 3:
            self.typeLabel.text = @"金币抽奖";
            break;
        case 4:
            self.typeLabel.text = @"后台补发";
            break;
        case 5:
            self.typeLabel.text = @"VIP充值";
            break;
        default:
            self.typeLabel.text = @"其他";
            break;
    }
}

- (void)setChange:(NSString *)change {
    if (change) {
        self.changeLabel.text = change;
    } else {
        self.changeLabel.text = @"0";
    }
}

- (void)setBalance:(NSString *)balance {
    if (balance) {
        self.balanceLabel.text = balance;
    } else {
        self.balanceLabel.text = @"0";
    }
}

- (void)setTime:(NSString *)time {
    if (time) {
        self.timeLabel.text = [time stringByReplacingOccurrencesOfString:@" "withString:@"\n"];
    } else {
        self.timeLabel.text = @"0";
    }
}


@end
