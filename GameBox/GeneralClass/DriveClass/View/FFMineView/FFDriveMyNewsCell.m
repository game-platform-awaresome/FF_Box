//
//  FFDriveMyNewsCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/2/6.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveMyNewsCell.h"
#import "UIImageView+WebCache.h"

#define CELL_STRING NSString *string = [NSString stringWithFormat:@"%@",str]
#define APPENDSTRING(string) [_beginningString stringByAppendingString:string]
#define CELL_DICT(key) dict[APPENDSTRING(key)]
#define CELL_SET_METHOD(name) - (void)setnameWith:(NSString *)str

@interface FFDriveMyNewsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *dynamicImageView;
@property (weak, nonatomic) IBOutlet UILabel *dynamicNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dynamicContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *dynamicCommentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DynamicLikeCommentHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dynamicsImageWidth;


@end

@implementation FFDriveMyNewsCell {
    NSString *_beginningString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width / 2;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.borderColor = NAVGATION_BAR_COLOR.CGColor;
    self.iconImageView.layer.borderWidth = 2;
    self.sexImageView.hidden = YES;
    self.dynamicImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.dynamicImageView.clipsToBounds = YES;
}



#pragma mark - setter
- (void)setType:(NSUInteger)type {
    _type = type;
    switch (type) {
        case 1:_beginningString = @"c_";
            break;
        case 2:_beginningString = @"cl_";
            break;
        case 3:_beginningString = @"dl_";
            break;
        default:_beginningString = @"c_";
            break;
    }

//    if (type == 2) {
//        self.DynamicLikeCommentHight.constant = 30;
//    } else {
//        self.DynamicLikeCommentHight.constant = 0;
//    }
}
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    syLog(@" === %@",dict);

    //iconImage
    [self setIconImageWith:CELL_DICT(@"uid_iconurl")];
    //nickname
    [self setNickNameWith:CELL_DICT(@"uid_nickname")];
    //time
    [self setTimeWith:_dict[@"create_time"]];
    //sex
//    [self setSexWith:CELL_DICT(@"uid_vip")];

    ///////////dynamic////////////
    //image
    [self setDynamicImage:dict[@"d_img"]];
    //nick name
    [self setDynamicNickName:dict[@"d_uid_nickname"]];
    //content
    [self setDynamicContent:dict[@"d_content"]];

    ////////// content label ////////
    [self setContentWith:CELL_DICT(@"content")];

    [self setDynamicComment:dict[@"c_content"]];
}

/** 设置发起人头像 */
- (void)setIconImageWith:(NSString *)str {
    CELL_STRING;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
}

/** 设置发起人昵称 */
- (void)setNickNameWith:(NSString *)str {
    CELL_STRING;
    self.nickNameLabel.text = string;
}

/** 设置发起人时间 */
- (void)setTimeWith:(NSString *)str  {
    CELL_STRING;
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:string.integerValue];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    self.timeLabel.text = [formatter stringFromDate:date];
}

/** 设置发起人性别 */
- (void)setSexWith:(NSString *)str {
    CELL_STRING;
    self.sexImageView.hidden = NO;
    if (string.integerValue == 1) {
        self.sexImageView.tintColor = [UIColor blueColor];
        self.sexImageView.image = [UIImage imageNamed:@"Community_Sex_Male"];
    } else if (str.integerValue == 2) {
        self.sexImageView.tintColor = [UIColor redColor];
        self.sexImageView.image = [UIImage imageNamed:@"Community_Sex_Female"];
    } else {
        self.sexImageView.hidden = YES;
    }
}

/** 发起人 vip */
- (void)setVipWith:(NSString *)str {
    CELL_STRING;
    if (string.integerValue == 1) {
        self.vipImageView.hidden = NO;
    } else {
        self.vipImageView.hidden = YES;
    }
}


////////////////// 作者动态 ////////////////////////////
/** 动态图片 */
- (void)setDynamicImage:(NSString *)str {
    CELL_STRING;
    self.dynamicsImageWidth.constant = (string.length < 5) ? 0 : 60;
    [self.dynamicImageView sd_setImageWithURL:[NSURL URLWithString:string]];
}

/** 动态作者昵称 */
- (void)setDynamicNickName:(NSString *)str {
    CELL_STRING;
    self.dynamicNickNameLabel.text = string;
}

/** 动态内容 */
- (void)setDynamicContent:(NSString *)str {
    CELL_STRING;
    self.dynamicContentLabel.text = string;
}

/** 中间的内容 */
- (void)setContentWith:(NSString *)str {
    CELL_STRING;
    if (self.type == 1) {
        self.contentLabel.text = [NSString stringWithFormat:@"回复了 : %@",string];
    } else if (self.type == 2) {
        self.contentLabel.text = @"赞了这条评论";
    } else if (self.type == 3) {
        self.contentLabel.text = @"赞了这条动态";
    }
}

/** 动态的评论 */
- (void)setDynamicComment:(NSString *)str {
    CELL_STRING;
    if (string.length > 0 && str != nil) {
        self.DynamicLikeCommentHight.constant = 30;
    } else {
        self.DynamicLikeCommentHight.constant = 0;
    }
    self.dynamicCommentLabel.text = string;
}








@end


















