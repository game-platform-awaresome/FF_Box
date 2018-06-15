//
//  FFCommodityCell.m
//  GameBox
//
//  Created by 燚 on 2018/6/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFCommodityCell.h"
#import "FFImageManager.h"
#import <SDWebImageDownloader.h>
#import <UIImageView+WebCache.h>

@interface FFCommodityCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;


@property (weak, nonatomic) IBOutlet UIImageView *pimageView;


@end

@implementation FFCommodityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.pimageView.image) {
        self.imageHeight.constant = self.pimageView.bounds.size.width * self.pimageView.image.size.width / self.pimageView.image.size.height;
    }
}

- (void)setImageUrl:(NSString *)imageUrl {
    NSString *urlStr = [NSString stringWithFormat:@"%@",imageUrl];
    [self.pimageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[FFImageManager Basic_Banner_placeholder] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.imageHeight.constant = self.pimageView.bounds.size.width * image.size.height / image.size.width;
    }];
}



@end






