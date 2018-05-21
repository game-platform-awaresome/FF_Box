//
//  FFGameOpenCell.m
//  GameBox
//
//  Created by 燚 on 2018/5/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameOpenCell.h"
#import "FFBoxModel.h"
#import "FFCurrentGameModel.h"
#import "FFColorManager.h"

@interface FFGameOpenCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *remindButton;


@end

@implementation FFGameOpenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)respondsToremindButtn:(UIButton *)sender {

    if ([sender.titleLabel.text isEqualToString:@"提醒我"]) {
        [FFBoxModel addNotificationWithDict:_dict Completion:^(NSDictionary *content, BOOL success) {
            if (success) {
                NSMutableDictionary *dict = [_dict mutableCopy];
                [dict setObject:@"1" forKey:@"isRemind"];
                _dict = [dict copy];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setOpenServerTime];
                });
            }
        }];
    } else {

    }
}

- (void)setAfterFrame:(NSDictionary *)dict {
    /** 开服时间 */
    [self setOpenServerTime];
}

#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    if (_dict != dict) {
        _dict = dict;
    }

    if ([FFBoxModel isAddNotificationWithDict:_dict]) {
        NSMutableDictionary *dNoti = [dict mutableCopy];
        [dNoti setObject:@"1" forKey:@"isRemind"];
        _dict = dNoti;
    }

    [self setAfterFrame:dict];
}



- (void)setOpenServerTime {
    //设置开服时间
    //游戏名称

    NSString *gameName = _dict[@"gamename"] ? _dict[@"gamename"] : CURRENT_GAME.game_name;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ - %@服",gameName,_dict[@"server_id"]];


    NSString *timeStr = _dict[@"start_time"];
    NSDate *starDate = [NSDate dateWithTimeIntervalSince1970:timeStr.integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    timeStr = [formatter stringFromDate:starDate];
    self.timeLabel.text = [NSString stringWithFormat:@"开服时间: %@",timeStr];
    //设置按钮
    self.remindButton.layer.cornerRadius = self.remindButton.bounds.size.height / 2;
    self.remindButton.layer.masksToBounds = YES;
    self.remindButton.layer.borderColor = [FFColorManager blue_dark].CGColor;
    self.remindButton.layer.borderWidth = 1;
    if ([[NSDate date] timeIntervalSinceDate:starDate] < 0.0f) {
        if ([_dict[@"isRemind"] isEqualToString:@"1"]) {
            [self.remindButton setTitle:@"已添加" forState:(UIControlStateNormal)];
            [self.remindButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            self.remindButton.backgroundColor = [FFColorManager blue_dark];
            [self.remindButton removeTarget:self action:@selector(respondsToremindButtn:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [self.remindButton setTitle:@"提醒我" forState:(UIControlStateNormal)];
            [self.remindButton setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];
            [self.remindButton setBackgroundColor:[UIColor clearColor]];
            [self.remindButton addTarget:self action:@selector(respondsToremindButtn:) forControlEvents:(UIControlEventTouchUpInside)];
        }
    } else {
        [self.remindButton setTitle:@"已开服" forState:(UIControlStateNormal)];
        [self.remindButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.remindButton setBackgroundColor:[UIColor lightGrayColor]];
        self.remindButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}










@end
