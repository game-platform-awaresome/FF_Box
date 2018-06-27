//
//  FFActivityTableViewCell.m
//  GameBox
//
//  Created by 燚 on 2018/6/27.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFActivityTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface FFActivityTableViewCell()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@property (weak, nonatomic) IBOutlet UIImageView *gameImage;


@end


@implementation FFActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    [self setTitleL:dict[@"title"]];
    [self setImagel:dict[@"slide_pic"]];
}

- (void)setTitleL:(NSString *)string {
    self.titleLabel.text = [NSString stringWithFormat:@"%@",string];
}

- (void)setImagel:(NSString *)string {
    [self.gameImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",string]]];
}





@end
