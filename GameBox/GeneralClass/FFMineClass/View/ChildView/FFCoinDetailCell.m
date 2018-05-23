//
//  FFCoinDetailCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFCoinDetailCell.h"

@interface FFCoinDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;


@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *change;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *time;

@end


@implementation FFCoinDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.balanceLabel.textColor = NAVGATION_BAR_COLOR;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.type = dict[@"type"];
    self.change = dict[@"coin_change"];
    self.balance = dict[@"coin_counts"];
    self.time = dict[@"create_time"];
}

- (void)setType:(NSString *)type {
    switch (type.integerValue) {
        case 1:
            self.typeLabel.text = @"签到";
            break;
        case 2:
            self.typeLabel.text = @"评论";
            break;
        case 3:
            self.typeLabel.text = @"好友推荐";
            break;
        case 4:
            self.typeLabel.text = @"金币兑换";
            break;
        case 5:
            self.typeLabel.text = @"金币抽奖";
            break;
        case 6:
            self.typeLabel.text = @"后台";
            break;
        case 7:
            self.typeLabel.text = @"社区评论";
            break;
        case 8:
            self.typeLabel.text = @"社区点赞";
            break;
        case 9:
            self.typeLabel.text = @"社区开车";
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
