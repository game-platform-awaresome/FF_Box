//
//  FFPromiseCell.m
//  GameBox
//
//  Created by 燚 on 2018/5/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFPromiseCell.h"
#import "FFColorManager.h"

@interface FFPromiseCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *serverLabel;

//@property (nonatomic, strong) UIButton *qqButton;

@property (weak, nonatomic) IBOutlet UIButton *qqButton;

@end

@implementation FFPromiseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.qqButton setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];
}


- (void)setDict:(NSDictionary *)dict {
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSString *content = [NSString stringWithFormat:@"%@",dict[@"content"]];
        NSArray *array = [content componentsSeparatedByString:@"|||"];
//        syLog(@"cell === arayy === %@  array count === %ld",array,array.count);
        [self setContentString:array.firstObject];
        [self setServerString:array.lastObject];
        [self setQQbuttonTitle:dict[@"qq"]];
    }
}

- (void)setContentString:(NSString *)content {
    if (content && [content isKindOfClass:[NSString class]]) {
        self.contentLabel.text = [NSString stringWithFormat:@"%@",content];
    }
}


- (void)setServerString:(NSString *)content {
    if (content && [content isKindOfClass:[NSString class]]) {
        self.serverLabel.text = [NSString stringWithFormat:@"%@",content];
    }
}

- (void)setQQbuttonTitle:(NSString *)content {
    if (content && [content isKindOfClass:[NSString class]]) {
        [self.qqButton setTitle:[NSString stringWithFormat:@"%@",content] forState:(UIControlStateNormal)];
    }
}

- (IBAction)clickQQButton:(UIButton *)sender {
    syLog(@"button");
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFPromiseCell:clickQQButtonWithString:)]) {
        [self.delegate FFPromiseCell:self clickQQButtonWithString:sender.titleLabel.text];
    }
}

@end










