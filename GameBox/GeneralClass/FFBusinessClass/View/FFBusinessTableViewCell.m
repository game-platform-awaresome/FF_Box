//
//  FFBusinessTableViewCell.m
//  GameBox
//
//  Created by 燚 on 2018/6/11.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "FFImageManager.h"

@interface FFBusinessTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UILabel *systemLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;



@end


@implementation FFBusinessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.postImageView.layer.cornerRadius = 8;
    self.postImageView.layer.masksToBounds = YES;
    [self.postImageView setContentMode:(UIViewContentModeScaleAspectFill)];
}



- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    [self setTitle:dict[@"title"]];
    [self setPoster:dict[@"imgs"]];
    [self setSystem:dict[@"system"]];
    [self setServer:dict[@"server_name"]];
    [self setTime:dict[@"publish_time"]];
    [self setAmount:dict[@"price"]];
}

- (void)setTitle:(NSString *)string {
    self.titleLabel.text = [NSString stringWithFormat:@"%@",string];
}

- (void)setServer:(NSString *)string {
    self.serverLabel.text = [NSString stringWithFormat:@"区服 : %@",string];
}

- (void)setSystem:(NSString *)string {
    NSString *systemStr = [NSString stringWithFormat:@"%@",string];
    if (systemStr.integerValue == 1) {
        self.systemLabel.text = @"Android";
    } else {
        self.systemLabel.text = @"iOS";
    }
}

- (void)setPoster:(NSString *)string {
    NSString *urlStr = [NSString stringWithFormat:@"%@",string];
    [self.postImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[FFImageManager  gameLogoPlaceholderImage]];
}

- (void)setTime:(NSString *)string {
    NSString *timeStr = [NSString stringWithFormat:@"%@",string];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStr.integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    self.timeLabel.text = [formatter stringFromDate:date];
}

- (void)setAmount:(NSString *)string {
    self.amountLabel.text = [NSString stringWithFormat:@"%@元",string];
}




@end






