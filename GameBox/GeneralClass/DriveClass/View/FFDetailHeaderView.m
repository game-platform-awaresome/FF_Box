//
//  FFDetailHeaderView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/19.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDetailHeaderView.h"
#import "UIImageView+WebCache.h"
#import "ZLPhotoActionSheet.h"
#import "ZLPhotoManager.h"
#import "SYKeychain.h"

@interface FFDetailHeaderView()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIImageView *sexView;
@property (nonatomic, strong) UIImageView *vipView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *imageContentView;
@property (nonatomic, strong) UIView *grayLayer;
@property (nonatomic, strong) UIButton *attentionButton;

@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;
@property (nonatomic, strong) NSMutableArray<UIImage *> *images;

@end

@implementation FFDetailHeaderView {
    CGFloat imageviewWidth;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface {
    [self addSubview:self.iconView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.sexView];
    [self addSubview:self.vipView];
    [self addSubview:self.attentionButton];
    [self addSubview:self.contentLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.imageContentView];
}

#pragma mark - responds
- (void)respondsToAttentionButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFDetailHeaderView:clickAttentionButton:)]) {
        [self.delegate FFDetailHeaderView:self clickAttentionButton:nil];
    }
}



#pragma mark - setter
- (void)setModel:(FFDynamicModel *)model {
    _model = model;
    self.attentionButton.hidden = YES;
    [self.iconView sd_setImageWithURL:model.present_user_iconImageUrl];
    [self setNickNameWith:model.present_user_nickName];
    [self setSexWith:model.present_user_sex];
    [self setVipWith:model.present_user_vip];
    [self setTimeWith:model.creat_time];
    [self setcontentWith:model.content];
    [self setImagesWith:model.imageUrlStringArray];
    [self setShowAttention:model.present_user_uid];
}

- (void)setIconImageWith:(NSString *)url {
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

- (void)setNickNameWith:(NSString *)Str {
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@",Str];
    [self.nickNameLabel sizeToFit];
    self.nickNameLabel.center = CGPointMake(self.nickNameLabel.center.x, 25);
    self.sexView.center = CGPointMake(CGRectGetMaxX(self.nickNameLabel.frame) + 15, 25);
    self.vipView.center = CGPointMake(CGRectGetMaxX(self.sexView.frame) + 15, 25);
}

- (void)setSexWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        self.sexView.hidden = NO;
        if (str.integerValue == 1) {
            self.sexView.tintColor = [UIColor blueColor];
            self.sexView.image = [UIImage imageNamed:@"Community_Sex_Male"];
        } else {
            self.sexView.tintColor = [UIColor redColor];
            self.sexView.image = [UIImage imageNamed:@"Community_Sex_Female"];
        }
    } else {
        self.sexView.hidden = YES;
    }
}

- (void)setVipWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]] && str!= nil && str.boolValue) {
        self.vipView.hidden = NO;
    } else {
        self.vipView.hidden = YES;
    }
}

- (void)setAttentionWith:(NSString *)str {
    if (str.integerValue == 0) {
        [self.attentionButton setTitle:@"+关注" forState:(UIControlStateNormal)];
        [self.attentionButton setTitleColor:NAVGATION_BAR_COLOR forState:(UIControlStateNormal)];
        self.attentionButton.layer.borderColor = NAVGATION_BAR_COLOR.CGColor;
    } else {
        [self.attentionButton setTitle:@"已关注" forState:(UIControlStateNormal)];
        [self.attentionButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        self.attentionButton.layer.borderColor = [UIColor grayColor].CGColor;
    }
}

- (void)setShowAttention:(NSString *)str {
    if ([str isEqualToString:SSKEYCHAIN_UID]) {
        self.attentionButton.hidden = YES;
    } else {
        self.attentionButton.hidden = NO;
    }
}

- (void)setTimeWith:(NSString *)str {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:str.integerValue];
//    NSString *timeString = [formatter stringFromDate:date];
//    self.timeLabel.text  = timeString;
    self.timeLabel.text = str;
    [self.timeLabel sizeToFit];
}

- (void)setcontentWith:(NSString *)content {
    self.contentLabel.frame = CGRectMake(10, 80, kSCREEN_WIDTH - 20, 40);
    self.contentLabel.text = [NSString stringWithFormat:@"%@",content];
    [self.contentLabel sizeToFit];

    self.imageContentView.frame = CGRectMake(10, CGRectGetMaxY(self.contentLabel.frame) + 10, kSCREEN_WIDTH - 20, 30);
}

- (void)setImagesWith:(NSArray *)images {
    CGFloat imageContentHeight;
//    syLog(@"images === %@",images);
    if (images != nil && images.count != 0) {
        switch (images.count) {
            case 1: {
                imageviewWidth = (kSCREEN_WIDTH - 10) / 3;
                imageContentHeight = imageviewWidth;
                break;
            }
            case 2: {
                imageviewWidth = (kSCREEN_WIDTH - 10) / 3 - 5;
                imageContentHeight = imageviewWidth;
                break;
            }
            case 3: {
                imageviewWidth = (kSCREEN_WIDTH - 10) / 3 - 5;
                imageContentHeight = imageviewWidth;
                break;
            }
            case 4: {
                imageviewWidth = (kSCREEN_WIDTH - 10) / 3 - 5;
                imageContentHeight = imageviewWidth * 2 + 5;
                break;
            }

            default: {
                //                imageviewWidth = imageContentViewWidth / 2 - 5;
                imageContentHeight = 2;
            }
                break;
        }
    } else {
        imageContentHeight = 2;
    }
    [self setImageViewWith:images];

    CGRect frame = self.imageContentView.frame;
    frame.size.height = imageContentHeight;
    self.imageContentView.frame = frame;

    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, CGRectGetMaxY(self.imageContentView.frame) + 20);
    self.grayLayer.frame = CGRectMake(0, self.frame.size.height - 10, kSCREEN_WIDTH, 20);
    [self addSubview:self.grayLayer];
}

- (void)setImageViewWith:(NSArray *)images {
    if (_imageViews != nil) {
        for (UIImageView *view in _imageViews) {
            [view removeFromSuperview];
        }
    }
    _imageViews = [NSMutableArray arrayWithCapacity:images.count];
    _images = [NSMutableArray arrayWithCapacity:images.count];

    if (images.count > 0) {
        [images enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imageView = nil;
            imageView = [[UIImageView alloc] init];

            if ([obj hasSuffix:@".gif"]) {

                NSData *iamgeData = [self imageDataFromDiskCacheWithKey:obj];
                if (iamgeData) {
                    [[[SDWebImageManager sharedManager] imageCache] storeImageDataToDisk:iamgeData forKey:obj];
                    imageView.image = [ZLPhotoManager transformToGifImageWithData:iamgeData];
                    [_images addObject:imageView.image];
                } else {
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:obj] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    }  completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        [[[SDWebImageManager sharedManager] imageCache] storeImageDataToDisk:data forKey:obj];

                        dispatch_async(dispatch_get_main_queue(), ^{
                            imageView.image = [ZLPhotoManager transformToGifImageWithData:data];
                            [_images addObject:imageView.image];

                        });

                    }];
                }

            } else {
                [imageView sd_setImageWithURL:[NSURL URLWithString:obj] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if ([obj hasSuffix:@".gif"]) {
                        NSData *data = UIImagePNGRepresentation(image);
                        imageView.image = [ZLPhotoManager transformToGifImageWithData:data];
                    }
                    [_images addObject:imageView.image];
                }];
            }


            imageView.tag = idx + 10086;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            CGFloat y = 0;
            CGFloat x = 2.5 + (imageviewWidth + 5) * idx;
            if (images.count == 4 && idx < 2) {
                y = 0;
                x = 2.5 + (imageviewWidth + 5) * idx;
            } else if (images.count == 4 && idx >= 2) {
                y = imageviewWidth + 5;
                x = 2.5 + (imageviewWidth + 5) * (idx - 2);
            } else {

            }
            [_imageViews addObject:imageView];
            imageView.frame = CGRectMake(x, y, imageviewWidth, imageviewWidth);
            [self.imageContentView addSubview:imageView];

        }];
    }

}


- (void)clickImage:(UITapGestureRecognizer *)sender {
    syLog(@"点击图片");
    [[self getPas] previewPhotos:self.images index:sender.view.tag - 10086 hideToolBar:YES complete:^(NSArray * _Nonnull photos) {

    }];
}

#pragma mark - getter
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.frame = CGRectMake(10, 10, 60, 60);
        _iconView.layer.cornerRadius = 30;
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.borderColor = [UIColor orangeColor].CGColor;
        _iconView.layer.borderWidth = 4;
    }
    return _iconView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 30, 30)];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.textColor = [UIColor blackColor];
        _nickNameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _nickNameLabel;
}

- (UIImageView *)sexView {
    if (!_sexView) {
        _sexView = [[UIImageView alloc] init];
        _sexView.bounds = CGRectMake(0, 0, 15, 15);
        _sexView.center = CGPointMake(CGRectGetMaxX(self.nickNameLabel.frame) + 15, CGRectGetMidY(self.nickNameLabel.frame));
    }
    return _sexView;
}

- (UIImageView *)vipView {
    if (!_vipView) {
        _vipView = [[UIImageView alloc] init];
        _vipView.bounds = CGRectMake(0, 0, 15, 15);
        _vipView.center = CGPointMake(CGRectGetMaxX(self.sexView.frame) + 60, self.sexView.center.y);
        _vipView.image = [UIImage imageNamed:@"Community_Vip"];
    }
    return _vipView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 20, 20)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, kSCREEN_WIDTH - 20, 40)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:17];
    }
    return _contentLabel;
}

- (UIView *)imageContentView {
    if (!_imageContentView) {
        _imageContentView = [[UIView alloc] init];
    }
    return _imageContentView;
}

- (UIView *)grayLayer {
    if (!_grayLayer) {
        _grayLayer = [[UIView alloc] init];
        _grayLayer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        _grayLayer.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, 20);
    }
    return _grayLayer;
}

- (UIButton *)attentionButton {
    if (!_attentionButton) {
        _attentionButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _attentionButton.frame = CGRectMake(kSCREEN_WIDTH - 70, 10, 60, 30);
        _attentionButton.layer.borderColor = NAVGATION_BAR_COLOR.CGColor;
        _attentionButton.layer.borderWidth = 1;
        _attentionButton.layer.cornerRadius = 4;
        _attentionButton.layer.masksToBounds = YES;
        _attentionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_attentionButton addTarget:self action:@selector(respondsToAttentionButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _attentionButton;
}

- (ZLPhotoActionSheet *)getPas {
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.sender = [UIApplication sharedApplication].keyWindow.rootViewController;
    actionSheet.configuration.allowSelectGif = YES;
    actionSheet.configuration.navBarColor = NAVGATION_BAR_COLOR;
    actionSheet.configuration.bottomViewBgColor = NAVGATION_BAR_COLOR;
    return actionSheet;
}


- (NSData *)imageDataFromDiskCacheWithKey:(NSString *)key {
    NSString *path = [[[SDWebImageManager sharedManager] imageCache] defaultCachePathForKey:key];
    return [NSData dataWithContentsOfFile:path];
}


@end











