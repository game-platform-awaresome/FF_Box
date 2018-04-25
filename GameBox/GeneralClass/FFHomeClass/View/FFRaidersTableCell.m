//
//  FFRaidersCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/26.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFRaidersTableCell.h"
#import "UIImageView+WebCache.h"

@interface FFRaidersTableCell ()


@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end


@implementation FFRaidersTableCell

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

    [self setGameLogo:dict[@"logo"]];
    [self setAutor:dict[@"author"]];
    [self setTime:dict[@"release_time"]];
    [self setcontent:dict[@"title"]];
    [self setGameName:dict[@"gamename"]];

}

- (void)setGameLogo:(NSString *)string {
    if (string) {
        [self.gameLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,string]] placeholderImage:[UIImage imageNamed:@"aboutus_icon"]];
    }
}

- (void)setAutor:(NSString *)string {
    if (string == nil || string.length == 0 || [string isKindOfClass:[NSNull class]]) {
        self.authorLabel.text = @" ";
    } else {
        self.authorLabel.text = [NSString stringWithFormat:@"%@",string];
    }
}

- (void)setTime:(NSString *)string {
    if (string == nil || string.length == 0 || [string isKindOfClass:[NSNull class]]) {
        self.timeLabel.text = @" ";
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"%@",string];
    }
}

- (void)setcontent:(NSString *)string {
    if (string == nil || string.length == 0 || [string isKindOfClass:[NSNull class]]) {
        self.contentLabel.text = @" ";
    } else {
        self.contentLabel.text = [NSString stringWithFormat:@"%@",string];
    }
}

- (void)setGameName:(NSString *)string {
    if (string == nil || string.length == 0 || [string isKindOfClass:[NSNull class]]) {
        self.gameNameLabel.text = @" ";
    } else {
        self.gameNameLabel.text = [NSString stringWithFormat:@"%@",string];
    }
}



@end










