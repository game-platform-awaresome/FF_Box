//
//  NewServerTableViewCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "FFOpenServerCell.h"
#import <UIImageView+WebCache.h>
#import "FFBoxModel.h"
#import "FFColorManager.h"
#import "FFCurrentGameModel.h"

@interface FFOpenServerCell ()

/** 游戏名称标签 */
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;

/** 游戏开始标签 */
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;

/** 提醒按钮 */
@property (weak, nonatomic) IBOutlet UIButton *remindButton;

@property (nonatomic, strong) NSArray <UILabel *> *labelArray;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;


@end

@implementation FFOpenServerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label1.backgroundColor = [FFColorManager custom_cell_text1_color];
    self.label2.backgroundColor = [FFColorManager custom_cell_text2_color];
    self.label3.backgroundColor = [FFColorManager custom_cell_text3_color];
    self.labelArray = @[self.label1,self.label2,self.label3];
    for (UILabel *label in self.labelArray) {
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    //游戏 logo
    [self setGameLogoWithString:nil];
    /** 开服时间 */
    [self setOpenServerTime];
    //设置标签
    [self setGameLabel];
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


- (void)setGameLogoWithString:(NSString *)string {
    if ([_dict[@"logo"] isKindOfClass:[NSString class]]) {
        [self.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_dict[@"logo"]]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];
    }
}

- (void)setOpenServerTime {
    //设置开服时间
    //游戏名称

    NSString *gameName = _dict[@"gamename"] ? _dict[@"gamename"] : CURRENT_GAME.game_name;
    self.gameNameLabel.text = [NSString stringWithFormat:@"%@ - %@服",gameName,_dict[@"server_id"]];


    NSString *timeStr = _dict[@"start_time"];
    NSDate *starDate = [NSDate dateWithTimeIntervalSince1970:timeStr.integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    timeStr = [formatter stringFromDate:starDate];
    self.startTimeLabel.text = [NSString stringWithFormat:@"开服时间: %@",timeStr];
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

- (void)setGameLabel {
    NSString *labelString = _dict[@"label"];
    NSArray *labelArray = [labelString componentsSeparatedByString:@","];
    int idx = 0;
    for (NSString *obj in labelArray) {
        if (idx < 3) {
            self.labelArray[idx].text = [NSString stringWithFormat:@" %@ ",obj];
            self.labelArray[idx].hidden = NO;
        }
        idx++;
    }
    if (idx < 2) {
        for (; idx < self.labelArray.count; idx++) {
            self.labelArray[idx].hidden = YES;
        }
    }
}






@end









