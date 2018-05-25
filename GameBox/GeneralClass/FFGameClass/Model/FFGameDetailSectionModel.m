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
#import "FFGameActivityCell.h"

#import "FFGameViewController.h"
#import "FFGameGifTableViewCell.h"


#import <SDWebImageManager.h>

@interface FFGameDetailSectionModel () <FFSRcommentCellDelegate>

@property (nonatomic, strong) UILabel *sectionFooterLabel;
@property (nonatomic, strong) UIImageView *sectionFooterImageView;

@property (nonatomic, strong) UILabel *sectionHeaderLabel;

@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, strong) FFGameGifTableViewCell *gifCell;
@property (nonatomic, strong) FFGameActivityCell *activityCell;
@property (nonatomic, strong) NSArray *activityArray;

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
            //这个功能是后加入的, 回调参数并不是游戏详情统一返回的
            ///!!!!!!!!!!!!!!!!还的动态的很头痛!!!!!!!!!!!!!!\\\
            self.sectionHeaderTitle = @"独家活动";
            //游戏活动回调
            self.cell = [self creatActivityCell];
            [self setActivityBlock];
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

//活动的回调
- (void)setActivityBlock {
    [CURRENT_GAME setActivityCallBackBlock:^(NSDictionary *content, BOOL success) {
        syLog(@"游戏活动 == %@",content);
        NSArray *array = content[@"data"][@"list"];
        if (success && ![array isKindOfClass:[NSNull class]]) {
            self.activityArray = [array copy];
        } else {
            self.activityArray = nil;
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.sectionType] withRowAnimation:(UITableViewRowAnimationNone)];
        syLog(@"刷新游戏活动");
    }];
}

- (void)setActivityArray:(NSArray *)activityArray {
    _activityArray = activityArray;
    if (activityArray.count < 1) {
        self.isEmpty = YES;
        self.sectionHeaderHeight = 0;
        self.sectionFooterHeight = 0;
    } else {
        self.isEmpty = NO;
        self.sectionHeaderHeight = 44;
        self.sectionFooterHeight = 0;
        self.sectionHeaderLabel.text = @"独家活动";
        self.activityCell.acitivityArray = activityArray;
        self.activityCell.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 55 * activityArray.count);
    }
}

- (id)creatActivityCell {
    self.activityCell = [[FFGameActivityCell alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44 * self.activityArray.count)];;
    WeakSelf;
    [self.activityCell setBlock:^(NSDictionary *dict) {
        if (weakSelf.ActivityBlock) {
            weakSelf.ActivityBlock(dict);
        }
    }];
    return self.activityCell;
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
    if (_isEmpty)  return 0;
    if (self.sectionType == SecTionTypeLike)  return 120;
    if (self.sectionType == SecTionTypeGif) return kSCREEN_WIDTH * 0.618;
    if (self.sectionType == SecTionTypeActivity)  return 55 * self.activityArray.count;
    return 100;
}

- (CGFloat)openUpHeight {
    if (_isEmpty)  return 0;
    if (self.sectionType == SecTionTypeLike)  return 120;
    if (self.sectionType == SecTionTypeGif)  return kSCREEN_WIDTH * 0.618;
    if (self.sectionType == SecTionTypeActivity)  return 55 * self.activityArray.count;
    return (_openUpHeight < 100) ? 100.f : _openUpHeight;
}

- (void)modelTableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sectionType == SecTionTypeGif) {
        self.gifCell.gifUrl = CURRENT_GAME.gif_url;
        self.gifCell.isLoadGif = YES;
        return;
    }

    if (self.sectionType ==  SecTionTypeActivity) {

        return;
    }


    if (_isAnimation)  return;
    if (self.openUpHeight == 100) return;

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

        [_sectionHeaderView addSubview:self.sectionHeaderLabel];

        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0.5);
        layer.backgroundColor = [FFColorManager view_separa_line_color].CGColor;
        [_sectionHeaderView.layer addSublayer:layer];
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

- (UILabel *)sectionHeaderLabel {
    if (!_sectionHeaderLabel) {
        _sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, kSCREEN_WIDTH - 32, 44)];
        _sectionHeaderLabel.font = [UIFont systemFontOfSize:17];
    }
    return _sectionHeaderLabel;
}

- (void)setSectionHeaderTitle:(NSString *)sectionHeaderTitle {
    _sectionHeaderTitle = sectionHeaderTitle;
    self.sectionHeaderLabel.text = _sectionHeaderTitle;
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




