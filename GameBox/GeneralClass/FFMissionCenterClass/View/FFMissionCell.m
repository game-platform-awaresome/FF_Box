//
//  FFMissionCell.m
//  GameBox
//
//  Created by 燚 on 2018/5/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFMissionCell.h"

@interface FFMissionCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (weak, nonatomic) IBOutlet UILabel *completeLabel;

@property (weak, nonatomic) IBOutlet UIView *completeView;


@end


@implementation FFMissionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.completeView.layer.cornerRadius = self.completeView.bounds.size.height / 2;
    self.completeView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.title.text = dict[@"title"];
    if ([dict[@"subTitle"] isKindOfClass:[NSString class]]) {
        self.subTitle.text = dict[@"subTitle"];
    } else if ([dict[@"subTitle"] isKindOfClass:[NSAttributedString class]]) {
        self.subTitle.attributedText = dict[@"subTitle"];
    }
    NSString *complete = dict[@"complete"];
    if (complete.integerValue == 0) {
        self.completeLabel.text = @"未完成";
        self.completeLabel.hidden = NO;
        self.completeView.hidden = NO;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (complete.integerValue == 1) {
        self.completeLabel.text = @"已完成";
        self.completeLabel.hidden = NO;
        self.completeView.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.completeLabel.hidden = YES;
        self.completeView.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}






@end







