//
//  FFTransferNotesCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFTransferNotesCell.h"

@implementation FFTransferNotesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setDict:(NSDictionary *)dict {
    self.tTitleLabel.text = dict[@"content"];
}


@end
