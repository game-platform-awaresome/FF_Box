//
//  FFMyprizeCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/28.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMyprizeCell.h"

@interface FFMyprizeCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;



@end

@implementation FFMyprizeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.resultLabel.textColor = NAVGATION_BAR_COLOR;
}


- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:((NSString *)dict[@"create_time"]).integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd  HH:mm";

    self.timeLabel.text = [formatter stringFromDate:date];
    self.resultLabel.text = dict[@"name"];
}








@end
