//
//  FFSystemInfoCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/12/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFSystemInfoCell.h"

@interface FFSystemInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;

@end

@implementation FFSystemInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDict:(NSDictionary *)dict {
    _dict = dict;

    self.titleLabel.text = dict[@"title"];
    self.desLabel.text = dict[@"desc"];
    NSString *isRead = dict[@"is_read"];
    if (isRead.boolValue) {
        self.readLabel.text = @"已读";
        self.readLabel.textColor = [UIColor darkGrayColor];
    } else {
        self.readLabel.text = @"未读";
        self.readLabel.textColor = [UIColor redColor];
    }

}


@end
