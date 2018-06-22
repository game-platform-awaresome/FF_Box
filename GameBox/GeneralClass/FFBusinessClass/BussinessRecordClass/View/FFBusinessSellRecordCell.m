//
//  FFBusinessSellRecordCell.m
//  GameBox
//
//  Created by 燚 on 2018/6/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessSellRecordCell.h"
#import "FFColorManager.h"

@interface FFBusinessSellRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@property (weak, nonatomic) IBOutlet UILabel *offReeasonLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offReasonHeight;



@end


@implementation FFBusinessSellRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (IBAction)respondsToStatusButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFBusinessSellRecordCell:clickButtonWithInfo:)]) {
        [self.delegate FFBusinessSellRecordCell:self clickButtonWithInfo:nil];
    }
}


- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    syLog(@"cell dict == %@",dict);
    [self setGameName:dict[@"game_name"]];
    [self setTitle:dict[@"title"]];
    [self setAmount:dict[@"price"] ?: dict[@"money"]];
    [self setTime:dict[@"create_time"]];
    [self setType:[NSString stringWithFormat:@"%@",dict[@"status"]].integerValue];
    [self setOffReason:dict[@"off_reason"]];
}



- (void)setGameName:(NSString *)gameName {
    self.gameNameLabel.text = [NSString stringWithFormat:@"游戏名称 : %@",gameName];
}

- (void)setTitle:(NSString *)title {
    self.pTitleLabel.text = [NSString stringWithFormat:@"标题 : %@",title];
}

- (void)setAmount:(NSString *)amount {
    self.pAmountLabel.text = [NSString stringWithFormat:@"金额 : %@元",amount];
}

- (void)setTime:(NSString *)time {
    time = [NSString stringWithFormat:@"%@",time];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"YYYY-MM-dd";
    self.timeLabel.text = [formatter stringFromDate:date];
}

- (void)setType:(FFBusinessUserSellType)type {
    self.statusButton.hidden = NO;
    if (self.isBuy) {
        switch (type) {
            case 1: {
                [self.statusButton setTitle:@"支付成功" forState:(UIControlStateNormal)];
                break;
            }
            case 3: {
                [self.statusButton setTitle:@"退款" forState:(UIControlStateNormal)];
                break;
            }
            case 4: {
                [self.statusButton setTitle:@"交易完成" forState:(UIControlStateNormal)];
                break;
            }
            default:
                [self.statusButton setHidden:YES];
                break;
        }
    } else {
        switch (type) {
            case FFBusinessUserSellTypeUnderReview: {
                [self.statusButton setTitle:@"审核中" forState:(UIControlStateNormal)];
                break;
            }
            case FFBusinessUserSellTypeSelling: {
                [self.statusButton setTitle:@"下架" forState:(UIControlStateNormal)];
                break;
            }
            case FFBusinessUserSellTypeSold: {
                [self.statusButton setTitle:@"已出售" forState:(UIControlStateNormal)];
                break;
            }
            case FFBusinessUserSellTypeTransacton: {
                [self.statusButton setTitle:@"出售中" forState:(UIControlStateNormal)];
                break;
            }
            case FFBusinessUserSellTypeCancel: {
                [self.statusButton setTitle:@"上架" forState:(UIControlStateNormal)];
                break;
            }
            default:
                [self.statusButton setHidden:YES];
                break;
        }
    }
    self.statusButton.layer.cornerRadius = self.statusButton.bounds.size.height / 2;
    self.statusButton.layer.masksToBounds = YES;
    self.statusButton.layer.borderWidth = 1;
    self.statusButton.layer.borderColor = [FFColorManager blue_dark].CGColor;
}

- (void)setOffReason:(NSString *)string {
    if (string && [string isKindOfClass:[NSString class]] && [NSString stringWithFormat:@"%@",string].length > 0) {
        self.offReeasonLabel.text = [NSString stringWithFormat:@"%@",string];
        self.offReasonHeight.constant = 20;
    } else {
        self.offReeasonLabel.text = @"";
        self.offReasonHeight.constant = 0;
    }
}



@end




