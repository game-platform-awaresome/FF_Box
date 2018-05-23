//
//  FFMyNewsCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/23.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMyNewsCell.h"

@interface FFMyNewsCell ()

@property (weak, nonatomic) IBOutlet UILabel *whoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabe;

@end

@implementation FFMyNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDict:(NSDictionary *)dict {
    syLog(@"cell dict == %@",dict);
    //who
    [self setWho:[NSString stringWithFormat:@"%@",dict[@"nick_name"]]];
//    //time
    [self setTime:[NSString stringWithFormat:@"%@",dict[@"create_time"]]];
//    //content
    [self setContent:dict[@"content"]];
}

- (void)setWho:(NSString *)who {
//    syLog(@"who === %@",who);
    self.whoLabel.text = who;
}

- (void)setTime:(NSString *)time {
//    syLog(@"time === %@",time);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    time = [formatter stringFromDate:date];
//    syLog(@"time === %@",time);
    self.timeLabel.text = time;
}

- (void)setContent:(NSString *)content {
//    syLog(@"contetn === %@",content);
    self.contentLabe.text = content;
}


@end
