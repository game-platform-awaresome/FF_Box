//
//  FFGameDetailCell.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameDetailCell.h"

@interface FFGameDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation FFGameDetailCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(id)content {
    syLog(@"ddddddddddd == %@",content);
    if ([content isKindOfClass:[NSString class]]) {
        _contentLabel.text = content;
    }
}





@end
