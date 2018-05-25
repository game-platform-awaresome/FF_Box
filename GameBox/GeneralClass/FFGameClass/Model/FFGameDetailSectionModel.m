//
//  FFGameDetailSectionModel.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameDetailSectionModel.h"
#import "FFCurrentGameModel.h"
#import "FFColorManager.h"

#import "FFGameDetailCell.h"
#import "FFSRcommentCell.h"
#import "FFGameViewController.h"
#import "FFGameGifTableViewCell.h"

#import <SDWebImageManager.h>

@interface FFGameDetailSectionModel () <FFSRcommentCellDelegate>

@property (nonatomic, strong) UILabel *sectionFooterLabel;
@property (nonatomic, strong) UIImageView *sectionFooterImageView;

@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, strong) FFGameGifTableViewCell *gifCell;

@end

@implementation FFGameDetailSectionModel

+ (instancetype)initWithType:(SecTionType)type {
    FFGameDetailSectionModel *model = [[FFGameDetailSectionModel alloc] init];
    model.sectionType = type;
    model.openUp = NO;
    return model;
}


#pragma makr - setter
- (void)setSectionType:(SecTionType)sectionType {
    _sectionType = sectionType;
    self.sectionItemNumber = 1;
    self.sectionHeaderHeight = 44;
    switch (_sectionType) {
        case SecTionTypeGameIntroduction:
            self.sectionHeaderTitle = @"游戏简介";
            self.cell = [self creatGamedetailCell];
            self.contentString = CURRENT_GAME.game_introduction;
            self.sectionFooterHeight = (self.normalHeight == self.openUpHeight) ? 0 : 44;
            break;
        case SecTionTypeFeature:
            self.sectionHeaderTitle = @"游戏特征";
            self.cell = [self creatGamedetailCell];
            self.contentString = CURRENT_GAME.game_feature;
            self.sectionFooterHeight = (self.normalHeight == self.openUpHeight) ? 0 : 44;
            break;
        case SecTionTypeActivity:
            self.sectionHeaderTitle = @"独家活动";
            self.cell = [self creatGamedetailCell];
            self.contentString = CURRENT_GAME.game_version;
            self.sectionFooterHeight = 0;
            break;
        case SecTionTypeGif:
            self.sectionHeaderTitle = @"精彩时刻";
            self.cell = [self creaGametGifCell];
            [self refreshGifCell];
            self.sectionFooterHeight = 0;
            break;
        case SecTionTypeVip:
            self.sectionHeaderTitle = @"VIP 价格";
            self.cell = [self creatGamedetailCell];
            self.contentString = CURRENT_GAME.game_vip_amount;
            self.sectionFooterHeight = (self.normalHeight == self.openUpHeight) ? 0 : 44;
            break;
        case SecTionTypeLike:
            self.sectionHeaderTitle = @"猜你喜欢";
            self.sectionFooterHeight = 0;
            self.cell = [self creatLikeCell];
            [self.cell setValue:CURRENT_GAME.like forKey:@"gameArray"];
            break;
        default:
            break;
    }
}

- (void)refreshDataWith:(SecTionType)type {
    self.sectionType = type;
}

- (void)setOpenUp:(BOOL)openUp {
    _openUp = openUp;
    self.sectionFooterTitle = openUp ? @"收起" :@"展开";
}

- (void)setSectionFooterTitle:(NSString *)sectionFooterTitle {
    _sectionFooterTitle = sectionFooterTitle;
    self.sectionFooterLabel.text = sectionFooterTitle;
    [self.sectionFooterLabel sizeToFit];
    self.sectionFooterLabel.center = CGPointMake(kSCREEN_WIDTH / 2, 22);
}

- (void)setContentString:(NSString *)contentString {
    _contentString = contentString;
    _openUpHeight = [self heightForString:contentString] + 10.f;
    [self.cell setValue:contentString forKey:@"content"];

    if (_contentString == nil || contentString.length < 1) {
        self.sectionHeaderHeight = 0;
        self.sectionFooterHeight = 0;
        _isEmpty = YES;
    } else {
        _isEmpty = NO;
    }
}

- (CGFloat)normalHeight {
    if (self.sectionType == SecTionTypeLike) {
        return 120;
    }
    if (self.sectionType == SecTionTypeGif) {
        return kSCREEN_WIDTH * 0.618;
    }
    if (_isEmpty) {
        return 0;
    }
    return 100;
}

- (CGFloat)openUpHeight {
    if (self.sectionType == SecTionTypeLike) {
        return 120;
    }
    if (self.sectionType == SecTionTypeGif) {
        return kSCREEN_WIDTH * 0.618;
    }
    if (_isEmpty) {
        return 0;
    }
    return (_openUpHeight < 100) ? 100.f : _openUpHeight;
}

- (void)modelTableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isAnimation) {
        return;
    }

    if (self.openUpHeight == 100) {
        return;
    }

    if (self.sectionType == SecTionTypeGif) {
        self.gifCell.gifUrl = CURRENT_GAME.gif_url;
//        [self.gifCell.gifImageView startAnimating];
        self.gifCell.isLoadGif = YES;
        return;
    }

    _isAnimation = YES;
    [tableview beginUpdates];
    self.openUp = !self.openUp;
    [tableview endUpdates];
    _isAnimation = NO;
}

#pragma mark - other
/** 计算字符串需要的尺寸 */
- (CGSize)sizeForString:(NSString *)string Width:(CGFloat)width Height:(CGFloat)height {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize retSize = [string boundingRectWithSize:CGSizeMake(width, height)
                                          options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    return retSize;
}

- (CGFloat)heightForString:(NSString *)string {
    return [self sizeForString:string Width:kSCREEN_WIDTH Height:MAXFLOAT].height;
}


- (UIView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
        _sectionHeaderView.backgroundColor = [UIColor whiteColor];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, kSCREEN_WIDTH - 32, 44)];
        label.font = [UIFont systemFontOfSize:17];
        label.text = self.sectionHeaderTitle;
        [_sectionHeaderView addSubview:label];

        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0.5);
        layer.backgroundColor = [FFColorManager view_separa_line_color].CGColor;
        [_sectionHeaderView.layer addSublayer:layer];

//        CALayer *layer2 = [[CALayer alloc] init];
//        layer2.frame = CGRectMake(0, 43, kSCREEN_WIDTH, 1);
//        layer2.backgroundColor = [FFColorManager light_gray_color].CGColor;
//        [_sectionHeaderView.layer addSublayer:layer2];
    }
    return _sectionHeaderView;
}

- (UIView *)sectionFooterView {
    if (!_sectionFooterView) {
        _sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
        _sectionFooterView.backgroundColor = [UIColor whiteColor];

        [_sectionFooterView addSubview:self.sectionFooterLabel];

        CALayer *layer2 = [[CALayer alloc] init];
        layer2.frame = CGRectMake(0, 43, kSCREEN_WIDTH, 0.5);
        layer2.backgroundColor = [FFColorManager light_gray_color].CGColor;
        [_sectionFooterView.layer addSublayer:layer2];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToFooterView)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;

        [_sectionFooterView addGestureRecognizer:tap];
    }
    return _sectionFooterView;
}

- (void)respondsToFooterView {
    [self modelTableView:self.tableView didSelectRowAtIndexPath:nil];
}

- (UILabel *)sectionFooterLabel {
    if (!_sectionFooterLabel) {
        _sectionFooterLabel = [[UILabel alloc] init];
        _sectionFooterLabel.font = [UIFont systemFontOfSize:17];
        _sectionFooterLabel.textAlignment = NSTextAlignmentCenter;
        _sectionFooterLabel.center = CGPointMake(kSCREEN_WIDTH / 2, 22);
    }
    return _sectionFooterLabel;
}

- (id)creatGamedetailCell {
    if (self.cell) {
        return self.cell;
    }
    id cell = [[NSBundle mainBundle] loadNibNamed:@"FFGameDetailCell" owner:nil options:nil].firstObject;
    [cell setValue:@(UITableViewCellSelectionStyleNone) forKey:@"selectionStyle"];
    return cell;
}   

- (id)creatLikeCell {
    if (self.cell) {
        return self.cell;
    }
    id cell = [[FFSRcommentCell alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 120)];
    [cell setValue:@(UITableViewCellSelectionStyleNone) forKey:@"selectionStyle"];
    [cell setValue:self forKey:@"delegate"];
    return cell;
}

- (void)FFSRcommentCell:(FFSRcommentCell *)cell didSelectItemInfo:(id)info {
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSString *gid = [NSString stringWithFormat:@"%@",(info[@"id"] ? info[@"id"] : info[@"gid"])];
        [FFGameViewController sharedController].gid = gid;
    }
}

- (id)creaGametGifCell {
    if (self.gifCell) return self.gifCell;
    self.gifCell = [[FFGameGifTableViewCell alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.618)];
    return self.gifCell;
}

- (void)refreshGifCell {
    if (CURRENT_GAME.gif_url == nil || CURRENT_GAME.gif_url.length < 1) {
        return;
    }
    //设置 GIF 图片大小和位置
    if ([CURRENT_GAME.gif_model isEqualToString:@"1"]) {
        self.gifCell.gifImageView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.618);
    } else {
        self.gifCell.gifImageView.frame = CGRectMake(0, 0, kSCREEN_WIDTH * 0.618 * 0.618, kSCREEN_WIDTH * 0.618);
        self.gifCell.gifImageView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH * 0.618 / 2);
    }

    NSString *imagePath = [NSString stringWithFormat:IMAGEURL,CURRENT_GAME.gif_url];
    //检查网络状况
    if ([FFNetWorkManager netWorkState] == FFNetworkReachabilityStatusReachableViaWiFi) {
        //先从缓存中找 GIF 图片
        //先从缓存中找 GIF 图,如果有就加载,没有就请求
        NSString *path = [[[SDWebImageManager sharedManager] imageCache] defaultCachePathForKey:[imagePath stringByAppendingString:@"gif"]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSData *gifImageData = [NSData dataWithContentsOfFile:path];
            if (gifImageData) {
                self.gifCell.gifImageView.image = [UIImage imageWithData:gifImageData];
            } else {
                self.gifCell.gifImageView.image = nil;
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imagePath] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    self.gifCell.gifImageView.image = image;
                    //缓存 gif 图
                    [[[SDWebImageManager sharedManager] imageCache] storeImageDataToDisk:data forKey:[imagePath stringByAppendingString:@"gif"]];
                }];
            }
            self.gifCell.gifImageView.animatedImage = nil;
        });
    } else {
        NSString *path = [[[SDWebImageManager sharedManager] imageCache] defaultCachePathForKey:[imagePath stringByAppendingString:@"gif"]];
        NSData *gifImageData = [NSData dataWithContentsOfFile:path];
        if (gifImageData) {
            self.gifCell.gifImageView.image = [UIImage imageWithData:gifImageData];
        } else {
            self.gifCell.gifImageView.image = nil;
        }
        self.gifCell.gifImageView.animatedImage = nil;
    }

    self.gifCell.isLoadGif = NO;
    if (self.gifCell.isLoadGif) {

    } else {
        if ([CURRENT_GAME.gif_model isEqualToString:@"0"]) {
                [self.gifCell.label removeFromSuperview];
        } else {
            [self.gifCell.contentView addSubview:self.gifCell.label];
        }
    }
    self.gifCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.gifCell.label.text = @"GIF";

}




@end




