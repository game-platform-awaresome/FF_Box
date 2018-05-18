//
//  FFPostStatusImageCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/24.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFPostStatusImageCell.h"

@implementation FFPostStatusImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.frame = self.contentView.bounds;
        self.imageView.clipsToBounds = YES;
        self.imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imageView];

//        self.playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-15, self.bounds.size.height/2-15, 30, 30)];
//        self.playImageView.image = [UIImage imageNamed:@"playVideo"];
//        self.playImageView.userInteractionEnabled = YES;
//        [self.contentView addSubview:self.playImageView];
    }
    return self;
}

- (void)setType:(PostCellType)type {
    _type = type;
    if (type == addImage) {
        self.imageView.image = [UIImage imageNamed:@"Community_AddImage"];
    } else {
        self.imageView.image = nil;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
}








@end
