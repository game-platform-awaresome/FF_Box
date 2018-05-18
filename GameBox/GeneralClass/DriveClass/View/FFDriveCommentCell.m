//
//  FFDriveCommentCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/22.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveCommentCell.h"
#import "UIImageView+WebCache.h"

@interface FFDriveCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *vipImage;

@property (weak, nonatomic) IBOutlet UILabel *replayLabel;

@property (weak, nonatomic) IBOutlet UILabel *toUserNickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIImageView *topButton;

@end

@implementation FFDriveCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImage.layer.cornerRadius = 20;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderColor = [UIColor orangeColor].CGColor;
    self.iconImage.layer.borderWidth = 2;

    self.likeButton.tintColor = [UIColor grayColor];
    [self.likeButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];

    self.topButton.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    if (dict == nil) {
        return;
    }
    _dict = dict;
    [self setIconImageWith:dict[@"uid_iconurl"]];
    [self setNickNameWith:dict[@"uid_nickname"]];
    [self setToUidWith:dict[@"to_uid"]];
    [self setContentWith:dict[@"content"]];
    [self setTimeWith:dict[@"create_time"]];
    [self setToNickNameWith:dict[@"touid_nickname"]];
    [self setLikeWith:dict[@"likes"]];
    [self setLikeTypeWith:dict[@"like_type"]];
    [self setVipWith:dict[@"uid_vip"]];
    [self setTopButtonWithHidden:dict[@"order"]];
}

- (void)setIconImageWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
}

- (void)setNickNameWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    self.nickNameLabel.text = string;
}

- (void)setToNickNameWith:(NSString *)str {
    if (str == nil) {
        self.replayLabel.hidden = YES;
        self.toUserNickNameLabel.hidden = YES;
    } else {
        NSString *string = [NSString stringWithFormat:@"%@",str];
        self.replayLabel.hidden = NO;
        self.toUserNickNameLabel.hidden = NO;
        self.toUserNickNameLabel.text = string;
    }

}

- (void)setToUidWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    if (string.integerValue == 0) {
        self.replayLabel.hidden = YES;
        self.toUserNickNameLabel.hidden = YES;
    } else {
        self.replayLabel.hidden = NO;
        self.toUserNickNameLabel.hidden = NO;
    }
}

- (void)setToUserNickNameWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    self.toUserNickNameLabel.text = string;
}

- (void)setContentWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    self.contentLabel.text = string;
}

- (void)setTimeWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:string.integerValue];
    self.timeLabel.text = [formatter stringFromDate:date];
}

- (void)setLikeWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@" %@",str];
    [self.likeButton setTitle:string forState:(UIControlStateNormal)];
}

- (void)setLikeTypeWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    switch (string.integerValue) {
        case 0: {
            self.likeButton.tintColor = [UIColor grayColor];
            [self removeTargetButton:self.likeButton];
        }
            break;
        case 1: {
            self.likeButton.tintColor = [UIColor redColor];
            [self removeTargetButton:self.likeButton];
        }
            break;
        case 2: {
            self.likeButton.tintColor = [UIColor grayColor];
            [self addTargetButton:self.likeButton];
        }
            break;

        default:
            break;
    }
}

- (void)setTopButtonWithHidden:(NSString *)str {
    NSString *top = [NSString stringWithFormat:@"%@",str];
    if (top.integerValue == 1) {
        self.topButton.hidden = NO;
    } else {
        self.topButton.hidden = YES;
    }
}

- (void)addTargetButton:(UIButton *)button {
    [button addTarget:self action:@selector(respondsToLikeButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)removeTargetButton:(UIButton *)button {
    [button removeTarget:self action:@selector(respondsToLikeButton) forControlEvents:(UIControlEventTouchUpInside)];
}


- (void)setVipWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    if (string.integerValue == 1) {
        self.vipImage.hidden = NO;
    } else {
        self.vipImage.hidden = YES;
    }
}

#pragma mark - responds
- (void)respondsToLikeButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFDriveCommentCell:didClickLikeButtonWith:)]) {
        [self.delegate FFDriveCommentCell:self didClickLikeButtonWith:self.dict];
    }
}





@end
