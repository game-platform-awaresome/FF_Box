//
//  GifTableViewCell.m
//  GameBox
//
//  Created by 石燚 on 2017/5/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "FFGameGifTableViewCell.h"

#import "FLAnimatedImage.h"
#import "UIImageView+WebCache.h"


@implementation FFGameGifTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setGifUrl:(NSString *)gifUrl {
    _gifUrl = gifUrl;
    
    NSString *imagePath = [NSString stringWithFormat:IMAGEURL,_gifUrl];

    //先从缓存中找 GIF 图,如果有就加载,没有就请求

        NSData *gifImageData = [self imageDataFromDiskCacheWithKey:[imagePath stringByAppendingString:@"gif"]];

        if (gifImageData) {
            self.gifImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifImageData];
            [self.label removeFromSuperview];
        } else {

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:imagePath];

            WeakSelf;

            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

                dispatch_async(dispatch_get_main_queue(), ^{
                    CGFloat progress = receivedSize * 1.f / expectedSize * 1.f;

                    weakSelf.label.text = [NSString stringWithFormat:@"加载中 %.2lf %%",progress * 100];
                    weakSelf.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
                    if (progress >= 1) {
                        [self.label removeFromSuperview];
                    }
                });

            }  completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {

                //缓存 gif 图
                [[[SDWebImageManager sharedManager] imageCache] storeImageDataToDisk:data forKey:[imagePath stringByAppendingString:@"gif"]];

                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.gifImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
                });

            }];
            });
        }

}


- (FLAnimatedImageView *)gifImageView {
    if (!_gifImageView) {
        _gifImageView = [[FLAnimatedImageView alloc] init];
        [self.contentView addSubview:_gifImageView];
    }
    return _gifImageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.618)];
        
//        _label.center = CGPointMake(kSCREEN_WIDTH / 2, 50);
        
        _label.textAlignment = NSTextAlignmentCenter;
        
        _label.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        
        _label.textColor = [UIColor whiteColor];
        
        _label.text = @"GIF";
        
//        [self.contentView addSubview:_label];
    }
    return _label;
}

- (NSData *)imageDataFromDiskCacheWithKey:(NSString *)key {
    NSString *path = [[[SDWebImageManager sharedManager] imageCache] defaultCachePathForKey:key];
    return [NSData dataWithContentsOfFile:path];
}








@end
