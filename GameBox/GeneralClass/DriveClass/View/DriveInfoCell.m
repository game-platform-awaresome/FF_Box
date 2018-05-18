//
//  DriveInfoCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/12.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "DriveInfoCell.h"
#import "UIImageView+WebCache.h"
//#import "XLPhotoBrowser.h"
#import "FFDriveModel.h"
#import "FLAnimatedImage.h"
#import "ZLPhotoActionSheet.h"
#import "ZLPhotoManager.h"
#import "FFDriveCommentCell.h"
#import "FFDriveModel.h"
#import "FFViewFactory.h"

#define CELL_IDE @"FFDriveCommentCell"

@interface DriveInfoCell ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageVIew;

@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *ImageContentView;

@property (weak, nonatomic) IBOutlet UIButton *FavorButton;

@property (weak, nonatomic) IBOutlet UIButton *unFavorButton;

@property (weak, nonatomic) IBOutlet UIButton *sharedButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *showArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UIImageView *recommendButton;

//@property (nonatomic, assign) CGFloat rowHeight;
@property (weak, nonatomic) IBOutlet UILabel *EditCommentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *EditCommentLabelHeight;

@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;

/** 审核标签 */
@property (nonatomic, strong) UILabel *verifyLabel;


@property (nonatomic, strong) NSString *dynamicsID;

@property (nonatomic, strong) UIImage *gifImage;
@property (nonatomic, strong) UIImage *normalImage;

@end



@implementation DriveInfoCell {
    CGFloat imageContentViewWidth;
    CGFloat imageviewWidth;
    CellButtonType buttonType;
    BOOL delegateCallBack;
    BOOL isNoonButton;
    NSMutableArray *gifImages;
    BOOL isGifImage;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //attentionButton
    self.attentionButton.layer.borderColor = NAVGATION_BAR_COLOR.CGColor;
    self.attentionButton.layer.borderWidth = 1;
    self.attentionButton.layer.cornerRadius = 4;
    self.attentionButton.layer.masksToBounds = YES;
    self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.attentionButton addTarget:self action:@selector(respondsToAttentionButton) forControlEvents:(UIControlEventTouchUpInside)];
    //tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.userInteractionEnabled = NO;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    _showArray = @[@"",@""];
    //icon
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width / 2;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.borderColor = [[UIColor orangeColor] CGColor];
    self.iconImageView.layer.borderWidth = 3;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.ImageContentView.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, 200);
    self.rowHeight = 78;

    imageContentViewWidth = kSCREEN_WIDTH - 32;

    [self addRespondsToButton:self.sharedButton];
    [self addRespondsToButton:self.commentButton];

    [self.FavorButton setTintColor:[UIColor grayColor]];
    [self.unFavorButton setTintColor:[UIColor grayColor]];
    [self.sharedButton setTintColor:[UIColor grayColor]];
    [self.commentButton setTintColor:[UIColor grayColor]];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToIcon)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView addGestureRecognizer:tap];


    [self.contentView addSubview:self.verifyLabel];

    CALayer *line = [CALayer new];
    line.frame = CGRectMake(0, 0, kSCREEN_WIDTH - 32, 1);
    line.backgroundColor = [UIColor lightGrayColor].CGColor;
//    [self.contentView.layer addSublayer:line];
    self.EditCommentLabel.textColor = NAVGATION_BAR_COLOR;
//    self.EditCommentLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.EditCommentLabel.layer.borderWidth = 1;
    [self.EditCommentLabel.layer addSublayer:line];
    self.EditCommentLabel.hidden = YES;
}

//点击关注
- (void)respondsToAttentionButton {
    if (![self.model.verifyDynamics isEqualToString:@"1"]) {
        return;
    }
    FF_is_login;
    syLog(@"关注 %@",self.model.present_user_uid);
    START_NET_WORK;
    [FFDriveModel userAttentionWith:self.model.present_user_uid Type:(self.model.attention.integerValue == 0) ? attention : cancel  Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"attention === %@",content);
        STOP_NET_WORK;
        if (success) {
//            [self refreshNewData];
            if (self.model.attention.integerValue == 0) {
                self.model.attention = @"1";
            } else {
                self.model.attention = @"0";
            }
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }

        [self setAttentionWith:self.model.attention];
    }];

    syLog(@"关注");
}

//点击头像的响应
- (void)respondsToIcon {
    if (![self.model.verifyDynamics isEqualToString:@"1"]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(DriveInfoCell:didClickIconWithUid:WithIconImage:)]) {
//        NSString *uid = [NSString stringWithFormat:@"%@",self.dict[@"dynamics"][@"uid"]];
        //这里回调直接传的 cell, 所以在 响应代理的控制器里面直接用的 cell 的 model, uid 没有用
         [self.delegate DriveInfoCell:self didClickIconWithUid:nil WithIconImage:self.iconImageView.image];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - button add target
- (void)addRespondsToButton:(UIButton *)button {
    [button addTarget:self action:@selector(respondsToButton:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)removeRespondsToButton:(UIButton *)button {
    [button removeTarget:self action:@selector(respondsToButton:) forControlEvents:(UIControlEventTouchUpInside)];
}


#pragma mark - responds
- (void)respondsToButton:(UIButton *)sender {
    if (![self.model.verifyDynamics isEqualToString:@"1"]) {
        return;
    }
    if (sender == self.FavorButton) {
//        isNoonButton ? (buttonType = noonButton) : (buttonType = likeButton);
        buttonType = likeButton;
    } else if (sender == self.unFavorButton) {
//        isNoonButton ? (buttonType = noonButton) : (buttonType = dislikeButton);
        buttonType = dislikeButton;
    } else if (sender == self.sharedButton) {
        buttonType = sharedButton;
    } else if (sender == self.commentButton) {
        buttonType = commentButoon;
    }
    [self delegateCallBackWithType:buttonType];
}

- (void)delegateCallBackWithType:(CellButtonType)type {
    if (![self.model.verifyDynamics isEqualToString:@"1"]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(DriveInfoCell:didClickButtonWithType:)]) {
        [self.delegate DriveInfoCell:self didClickButtonWithType:type];
    }
}

#pragma mark - setter
- (void)setModel:(FFDynamicModel *)model {
    _model = model;
//    syLog(@"model === %@",model);
    self.nickNameLabel.text = model.present_user_nickName;
    self.timeLabel.text = model.creat_time;
    self.vipImageView.hidden = !model.isVip;
//    [self setVipWith:model.present_user_vip];
    [self setSexWith:model.present_user_sex];
    [self.iconImageView sd_setImageWithURL:model.present_user_iconImageUrl];
    [self setLikeWith:model.likes_number];
    [self setUnLikeWith:model.dislikes_number];
    [self setSharedWith:model.shared_number];
    [self setCommentWith:model.comments_number];
    [self setImagesWith:model.imageUrlStringArray];
    [self setcontentWith:model.content];
    [self setOperateWith:model.operate];

    //set stableView
    [self setTableViewShowArray:model.comments_Array];

    //
    [self setAttentionWith:model.attention];

    //设置审核
    [self setVerify:model.verifyDynamics];
    //显示审核
    if (model.showVerifyDynamics == YES && [model.present_user_uid isEqualToString:SSKEYCHAIN_UID]) {
        self.verifyLabel.hidden = NO;
    } else {
        self.verifyLabel.hidden = YES;
    }
    //显示关注按钮
    self.attentionButton.hidden = [model.present_user_uid isEqualToString:SSKEYCHAIN_UID];

    //推荐显示
    [self setRecommend:model.ratings];
    //小编点评
    [self setEditCommentString:model.remark];
}

/** 设置推荐 */
- (void)setRecommend:(NSString *)str {
    self.recommendButton.hidden = ![str isEqualToString:@"1"];
}

/** 设置审核 */
- (void)setVerify:(NSString *)str {
    switch (str.integerValue) {
        case 1:
            [self verifyLabelTitle:@"审核成功" TitleColor:RGBCOLOR(50,150,50) Hidden:NO];
            break;
        case 2:
            [self verifyLabelTitle:@"等待审核" TitleColor:RGBCOLOR(50,233,182) Hidden:NO];
            break;
        case 3:
            [self verifyLabelTitle:@"审核失败" TitleColor:[UIColor redColor] Hidden:NO];
            break;
        default:
            break;
    }
}

- (void)verifyLabelTitle:(NSString *)title TitleColor:(UIColor *)color Hidden:(BOOL)hidden {
    self.verifyLabel.text = title;
    self.verifyLabel.textColor = color;
    self.verifyLabel.hidden = hidden;
}

- (void)setSexWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        self.sexImageVIew.hidden = NO;
        if (str.integerValue == 1) {
            self.sexImageVIew.tintColor = [UIColor blueColor];
            self.sexImageVIew.image = [UIImage imageNamed:@"Community_Sex_Male"];
        } else if (str.integerValue == 2) {
            self.sexImageVIew.tintColor = [UIColor redColor];
            self.sexImageVIew.image = [UIImage imageNamed:@"Community_Sex_Female"];
        } else {
            self.sexImageVIew.hidden = YES;
        }
    } else {
        self.sexImageVIew.hidden = YES;
    }
}

- (void)setVipWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]] && str!= nil && str.boolValue) {
        self.vipImageView.hidden = NO;
    } else {
        self.vipImageView.hidden = YES;
    }
}

- (void)setcontentWith:(NSString *)content {
    self.contentLabel.text = [NSString stringWithFormat:@"%@",content];
    [self.contentLabel sizeToFit];
}

- (void)setImagesWith:(NSArray *)images {
    CGFloat imageContentHeight;
//    syLog(@"images === %@",images);
    if (images != nil && images.count != 0) {
        switch (images.count) {
            case 1: {
                imageviewWidth = imageContentViewWidth / 3;
                imageContentHeight = imageviewWidth;
                break;
            }
            case 2: {
                imageviewWidth = imageContentViewWidth / 3 - 5;
                imageContentHeight = imageviewWidth;
                break;
            }
            case 3: {
                imageviewWidth = imageContentViewWidth / 3 - 5;
                imageContentHeight = imageviewWidth;
                break;
            }
            case 4: {
                imageviewWidth = imageContentViewWidth / 3 - 5;
                imageContentHeight = imageviewWidth * 2 + 5;
                break;
            }

            default: {
                imageContentHeight = 2;
            }
                break;
        }
    } else {
        imageContentHeight = 2;
    }
    [self setImageViewWith:images];

    self.imageHeight.constant = imageContentHeight;
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
            imageView = [[FLAnimatedImageView alloc] init];
            
            if ([obj hasSuffix:@".gif"]) {
                isGifImage = YES;
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *iamgeData = [self imageDataFromDiskCacheWithKey:obj];
                    if (iamgeData) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.gifImage = [ZLPhotoManager transformToGifImageWithData:iamgeData];
                            self.normalImage = [UIImage imageWithData:iamgeData];
                            imageView.image = self.gifImage;
                            [_images addObject:self.gifImage];
                        });
                    } else {
                        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:obj] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        }  completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            if (finished) {
                                [[[SDWebImageManager sharedManager] imageCache] storeImageDataToDisk:data forKey:obj];

                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.gifImage = [ZLPhotoManager transformToGifImageWithData:data];
                                    self.normalImage = [UIImage imageWithData:data];
                                    imageView.image = self.gifImage;
                                    if (self.gifImage) {
                                        [_images addObject:imageView.image];
                                    }
                                });
                            }

                        }];
                    }
                });

            } else {
                isGifImage = NO;
                [imageView sd_setImageWithURL:[NSURL URLWithString:obj] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if ([obj hasSuffix:@".gif"]) {
                        NSData *data = UIImagePNGRepresentation(image);
                        imageView.image = [ZLPhotoManager transformToGifImageWithData:data];
                        self.gifImage = [UIImage imageWithData:data];
                        self.normalImage = [UIImage imageWithData:data];
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
            [self.ImageContentView addSubview:imageView];

        }];
    }

}

- (void)clickImage:(UITapGestureRecognizer *)sender {
    syLog(@"点击图片");
    [[self getPas] previewPhotos:self.images index:sender.view.tag - 10086 hideToolBar:YES complete:^(NSArray * _Nonnull photos) {

    }];
}

- (void)setDynamicsID:(NSString *)dynamicsID {
    NSString *string = [NSString stringWithFormat:@"%@",dynamicsID];
    (string.length > 0) ? (_dynamicsID = string) : (_dynamicsID = nil);
}

- (void)setLikeWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        [self.FavorButton setTitle:[NSString stringWithFormat:@"  %@赞",str] forState:(UIControlStateNormal)];
    }
}

- (void)setUnLikeWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        [self.unFavorButton setTitle:[NSString stringWithFormat:@"  %@踩",str] forState:(UIControlStateNormal)];
    }
}

- (void)setSharedWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        [self.sharedButton setTitle:[NSString stringWithFormat:@"  %@分享",str] forState:(UIControlStateNormal)];
    }
}

- (void)setCommentWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        [self.commentButton setTitle:[NSString stringWithFormat:@"  %@评论",str] forState:(UIControlStateNormal)];
    }
}

- (void)setOperateWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    if (string != nil && string.length != 0) {
//        syLog(@"operate string === %@",str);
        switch (string.integerValue) {
            case 0: {
//                [self removeLikeButtonAndeDisLikeButtonSelect];
                [self addRespondsToButton:self.FavorButton];
                [self addRespondsToButton:self.unFavorButton];
                self.unFavorButton.tintColor = [UIColor redColor];
                self.FavorButton.tintColor = [UIColor grayColor];
//                isNoonButton = YES;
            }
                break;
            case 1: {
//                [self removeLikeButtonAndeDisLikeButtonSelect];
                [self addRespondsToButton:self.FavorButton];
                [self addRespondsToButton:self.unFavorButton];
                self.unFavorButton.tintColor = [UIColor grayColor];
                self.FavorButton.tintColor = [UIColor redColor];
//                isNoonButton = YES;
            }
                break;
            case 2: {
                [self addRespondsToButton:self.FavorButton];
                [self addRespondsToButton:self.unFavorButton];
                self.unFavorButton.tintColor = [UIColor grayColor];
                self.FavorButton.tintColor = [UIColor grayColor];
//                isNoonButton = NO;
            }
                break;

            default: {
                [self canNotRespondsToLikeButtonAndDislikeButton];
            }
                break;
        }
    } else {
        [self canNotRespondsToLikeButtonAndDislikeButton];
    }
}

- (void)canNotRespondsToLikeButtonAndDislikeButton {
    [self removeLikeButtonAndeDisLikeButtonSelect];
    self.unFavorButton.tintColor = [UIColor grayColor];
    self.FavorButton.tintColor = [UIColor grayColor];
    isNoonButton = YES;
}

- (void)removeLikeButtonAndeDisLikeButtonSelect {
    [self removeRespondsToButton:self.FavorButton];
    [self removeRespondsToButton:self.unFavorButton];
}

//是否关注
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

- (void)setTableViewShowArray:(NSArray *)array {
    self.showArray = array;
    if (self.showArray == nil || self.showArray.count == 0) {
        self.tableViewHeight.constant = 0;
    } else if (self.showArray.count == 1){
        self.tableViewHeight.constant = 20;
    } else {
        self.tableViewHeight.constant = 40;
    }

    [self.tableView reloadData];
}

/** 设置小编评论 */
- (void)setEditCommentString:(NSString *)string {
#warning 小编点评

    if (string.length < 1 || string == nil || [string isKindOfClass:[NSNull class]] || [string isEqualToString:@"<null>"]) {
        self.EditCommentLabel.hidden = YES;
        self.EditCommentLabel.text = @"";
        self.EditCommentLabelHeight.constant = 0.f;
    } else {
        self.EditCommentLabel.hidden = NO;
        self.EditCommentLabel.text = [NSString stringWithFormat:@"小编点评 : %@",string];
        [self.EditCommentLabel sizeToFit];
        self.EditCommentLabelHeight.constant = self.EditCommentLabel.bounds.size.height + 4;

        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.EditCommentLabel.text];
        [attString setValuesForKeysWithDictionary:@{}];
        NSRange range1 = [self.EditCommentLabel.text rangeOfString:@"小编点评 :"];
        [attString addAttribute:NSForegroundColorAttributeName value:NAVGATION_BAR_COLOR range:range1];
        range1 = [self.EditCommentLabel.text rangeOfString:string];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range1];

        self.EditCommentLabel.attributedText = attString;
    }
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"comment_cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"comment_cell"];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.showArray[indexPath.row];
    if (dict != nil || [dict isKindOfClass:[NSDictionary class]]) {
        NSString *string = [NSString stringWithFormat:@"%@ : %@",dict[@"username"],dict[@"content"]];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range1 = [string rangeOfString:[NSString stringWithFormat:@"%@",dict[@"username"]]];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:range1];
        range1 = [string rangeOfString:[NSString stringWithFormat:@"%@",dict[@"content"]]];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor darkTextColor] range:range1];
        cell.textLabel.attributedText = attributeString;
    }


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}


#pragma mark - getter
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

- (void)starGif {
    if (isGifImage) {
        [_imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.image = self.gifImage;
        }];
    }
}

- (void)stopGif {
    if (isGifImage) {
        [_imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.image = self.normalImage;
        }];
    }
}

- (UILabel *)verifyLabel {
    if (!_verifyLabel) {
        _verifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        _verifyLabel.center = CGPointMake(kSCREEN_WIDTH - 40, self.nickNameLabel.center.y);
        _verifyLabel.hidden = YES;
        _verifyLabel.font = [UIFont systemFontOfSize:14];
        _verifyLabel.text = @"审核中";
        _verifyLabel.textAlignment = NSTextAlignmentCenter;
//        _verifyLabel.layer.borderColor = NAVGATION_BAR_COLOR.CGColor;
//        _verifyLabel.layer.borderWidth = 1;
        _verifyLabel.layer.cornerRadius = 4;
        _verifyLabel.layer.masksToBounds = YES;
    }
    return _verifyLabel;
}



@end






