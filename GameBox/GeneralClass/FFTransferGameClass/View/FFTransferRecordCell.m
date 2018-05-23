//
//  FFTransferRecordCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/9.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFTransferRecordCell.h"

@interface FFTransferRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *oldGameName;

@property (weak, nonatomic) IBOutlet UILabel *transferGameName;
@property (weak, nonatomic) IBOutlet UILabel *oldGameServer;
@property (weak, nonatomic) IBOutlet UILabel *transferGameServer;
@property (weak, nonatomic) IBOutlet UILabel *oldCharacterName;

@property (weak, nonatomic) IBOutlet UILabel *transferCharacterName;

@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIButton *type;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end



@implementation FFTransferRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUserInterface];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)initUserInterface {
    [self setSubviewsFrame];
}


- (void)setSubviewsFrame {
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 19, kSCREEN_WIDTH, 1);
    layer.backgroundColor = BACKGROUND_COLOR.CGColor;
    [self.contentView.layer addSublayer:layer];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 20);

    self.oldGameName.frame = CGRectMake(0, 20, kSCREEN_WIDTH / 3, 20);
    self.arrow.bounds = CGRectMake(0, 0, 13, 26);
    self.arrow.center = CGPointMake(self.oldGameName.center.x, 60);
    self.transferGameName.frame = CGRectMake(0, 75, kSCREEN_WIDTH / 3, 20);

    self.oldGameServer.frame = CGRectMake(CGRectGetMaxX(self.oldGameName.frame), CGRectGetMinY(self.oldGameName.frame), kSCREEN_WIDTH / 3, 20);
    self.transferGameServer.frame = CGRectMake(CGRectGetMaxX(self.transferGameName.frame), CGRectGetMinY(self.transferGameName.frame), kSCREEN_WIDTH / 3, 20);

    self.oldCharacterName.frame = CGRectMake(CGRectGetMaxX(self.oldGameServer.frame), CGRectGetMinY(self.oldGameServer.frame), kSCREEN_WIDTH / 3, 20);
    self.type.bounds = CGRectMake(0, 0, 100, 80);
    self.type.center = CGPointMake(kSCREEN_WIDTH - 50, 60);
    self.transferCharacterName.frame = CGRectMake(CGRectGetMaxX(self.transferGameServer.frame), CGRectGetMinY(self.transferGameServer.frame), kSCREEN_WIDTH / 3, 20);
}

- (void)setDict:(NSDictionary *)dict {
//    syLog(@"transfer cel === %@",dict);
    self.timeLabel.text = dict[@"create_time"];
    [self.timeLabel sizeToFit];
    self.timeLabel.center = CGPointMake(self.timeLabel.frame.size.width / 2 + 10, 10);
    self.oldGameName.text = dict[@"origin_appname"];
    self.oldGameServer.text = dict[@"origin_servername"];
    self.oldCharacterName.text = dict[@"origin_rolename"];
    self.transferGameName.text = dict[@"new_appname"];
    self.transferGameServer.text  = dict[@"new_servername"];
    self.transferCharacterName.text = dict[@"new_rolename"];
    [self setTransformType:dict[@"status"]];
}


- (void)setTransformType:(NSString *)type {
    switch (type.integerValue) {
        case 1: {
            [self.type setImage:[UIImage imageNamed:@"New_transfer_success"] forState:(UIControlStateNormal)];
            break;
        }
        case 2: {
            [self.type setImage:[UIImage imageNamed:@"New_transfer_wating"] forState:(UIControlStateNormal)];
            break;
        }
        case 3: {
            [self.type setImage:[UIImage imageNamed:@"New_transfer_failure"] forState:(UIControlStateNormal)];
            break;
        }
        default:
            break;
    }
}





@end
















