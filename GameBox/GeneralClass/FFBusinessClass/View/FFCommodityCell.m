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







@end

@implementation FFCommodityCell {
    CGFloat image_width;
    CGFloat image_height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setImageUrl:(NSString *)imageUrl {
    NSString *urlStr = [NSString stringWithFormat:@"%@",imageUrl];
    [self.pimageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[FFImageManager Basic_Banner_placeholder] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        self.pimageView.bounds = CGRectMake(0, 0, self.pimageView.bounds.size.width,  self.pimageView.bounds.size.width * image.size.width / image.size.height);
//        self->image_width = image.size.width;
//        self->image_height = image.size.height;
//        self.imageHeight.constant = self.pimageView.bounds.size.width * self->image_height / self->image_width;

        CGFloat ratio = image.size.height / image.size.width;
        self.imageHeight.constant = self.pimageView.bounds.size.width * ratio;

//        if (image.size.height) {
//            /**  <根据比例 计算图片高度 >  */
//            /**  < 缓存图片高度 没有缓存则缓存 刷新indexPath >  */
//            if (self.tableView) {
//                [self.tableView beginUpdates];
//                [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                [self.tableView endUpdates];
//            }
//        }
    }];
}



@end






