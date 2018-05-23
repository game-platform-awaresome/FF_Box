//
//  FFSystemDetailView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/12/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFSystemDetailView.h"
#import "SDWebImageDownloader.h"

@interface FFSystemDetailView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *receiveButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView *FFImageView;

@property (nonatomic, strong) NSString *descString;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *isGet;

@end


@implementation FFSystemDetailView

#pragma mark - responds



#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;

    self.descString = [NSString stringWithFormat:@"%@",dict[@"desc"]];
    self.timeString = [NSString stringWithFormat:@"%@",dict[@"create_time"]];
    self.image = [NSString stringWithFormat:@"%@",dict[@"image"]];
    self.isGet = [NSString stringWithFormat:@"%@",dict[@"is_get"]];
}

- (void)setTitle:(NSString *)title {
    NSMutableString *string = [title mutableCopy];
    [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.titleLabel.text = string;
}

- (void)setDescString:(NSString *)descString {
    self.descLabel.text = descString;
}

- (void)setTimeString:(NSString *)timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeString.integerValue];
    self.timeLabel.text = [formatter stringFromDate:date];
}

- (void)setShowReceiveButton:(NSString *)showReceiveButton {
    if (showReceiveButton.integerValue == 2) {
        self.receiveButton.hidden = NO;
        self.receiveButton.layer.cornerRadius = 8;
        self.receiveButton.layer.masksToBounds = YES;
    } else {
        self.receiveButton.hidden = YES;
    }
}

- (void)setIsGet:(NSString *)isGet {
    if (isGet.boolValue) {
        self.receiveButton.backgroundColor = [UIColor grayColor];
        [self.receiveButton setTitle:@"已领取" forState:(UIControlStateNormal)];
        self.receiveButton.userInteractionEnabled = NO;
    } else {
        [self.receiveButton setTitle:@"领取" forState:(UIControlStateNormal)];
        self.receiveButton.userInteractionEnabled = YES;
    }
}

- (void)setImage:(NSString *)image {
    if (image.length == 0) {
        CGRect frame = self.FFImageView.frame;
        self.FFImageView.frame = CGRectMake(frame.origin.x, frame.origin.y, 0, 0);
        self.scrollView.hidden = YES;
    } else {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:image] options:(SDWebImageDownloaderHighPriority) progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            syLog(@"image === %@",image);
            self.FFImageView.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, (image.size.width / 2 /  self.scrollView.bounds.size.width) * (image.size.height / 2));
            self.FFImageView.image = image;
            self.scrollView.contentSize = self.FFImageView.frame.size;
            [self.scrollView addSubview:self.FFImageView];
        }];
    }
}

#pragma mark - getter
- (UIImageView *)FFImageView {
    if (!_FFImageView) {
        _FFImageView = [[UIImageView alloc] init];
    }
    return _FFImageView;
}




@end





