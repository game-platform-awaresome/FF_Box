//
//  FFRebateRecordCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/23.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRebateRecordCell.h"

@interface FFRebateRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *appname;
@property (weak, nonatomic) IBOutlet UILabel *servername;
@property (weak, nonatomic) IBOutlet UILabel *rolename;
@property (weak, nonatomic) IBOutlet UILabel *gamecoin;

@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UIButton *applyStatus;

@end

@implementation FFRebateRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 21, kSCREEN_WIDTH, 1);
    layer.backgroundColor = BACKGROUND_COLOR.CGColor;
    [self.contentView.layer addSublayer:layer];
    self.timelabel.textColor = [UIColor lightGrayColor];
    self.applyStatus.userInteractionEnabled = NO;
}




- (void)setDict:(NSDictionary *)dict {
    self.appname.text = dict[@"gamename"];
    self.rolename.text = dict[@"rolename"];
    self.servername.text = dict[@"servername"];
    self.gamecoin.text = dict[@"game_coin"];

    NSString *timeString = dict[@"create_time"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeString.integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.timeStyle = @"YYYY-MM-DD  HH:mm";
    [formatter setDateFormat:@"YYYY-MM-dd  HH:mm"];
    self.timelabel.text = [formatter stringFromDate:date];
    [self setType:dict[@"status"]];
}

- (void)setType:(NSString *)type {
    switch (type.integerValue) {
        case 1: {
            [self.applyStatus setImage:[UIImage imageNamed:@"New_transfer_success"] forState:(UIControlStateNormal)];
            break;
        }
        case 2: {
            [self.applyStatus setImage:[UIImage imageNamed:@"New_transfer_wating"] forState:(UIControlStateNormal)];
            break;
        }
        case 3: {
            [self.applyStatus setImage:[UIImage imageNamed:@"New_transfer_failure"] forState:(UIControlStateNormal)];
            break;
        }

        default: {
            [self.applyStatus setImage:nil forState:(UIControlStateNormal)];
            break;
        }
    }
}




@end
