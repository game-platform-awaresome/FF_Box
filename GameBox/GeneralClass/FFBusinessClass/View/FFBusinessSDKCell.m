//
//  FFBusinessSDKCell.m
//  GameBox
//
//  Created by 燚 on 2018/6/13.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessSDKCell.h"
#import <UIImageView+WebCache.h>
#import "FFImageManager.h"

@interface FFBusinessSDKCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;


@end

@implementation FFBusinessSDKCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.logoImageView.layer.cornerRadius = 3;
    self.logoImageView.layer.masksToBounds = YES;
}

- (void)setDict:(NSDictionary *)dict {
    [self setLogoImage:dict[@"logo"]];
    [self setGameName:dict[@"game_name"]];
}

- (void)setLogoImage:(NSString *)string {
    if ([string isKindOfClass:[NSString class]]) {
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[FFImageManager gameLogoPlaceholderImage]];
    } else {
        [self.logoImageView setImage:[FFImageManager gameLogoPlaceholderImage]];
    }
}

- (void)setGameName:(NSString *)string {
    self.gameNameLabel.text = [NSString stringWithFormat:@"%@",string];
}




@end











