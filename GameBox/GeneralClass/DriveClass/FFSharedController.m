//
//  FFSharedController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFSharedController.h"
#import <UIKit/UIKit.h>
#import "FFUserModel.h"
#import "FFMapModel.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import <WXApi.h>

#import "FFDeviceInfo.h"
#import "FFStatisticsModel.h"

#define SHARED_WINDOW [FFSharedController sharedWindow]
#define SHARED_VIEW [FFSharedController sharedView]
#define BACKGROUND_VIEW [FFSharedController sharedController].backGroundView
#define IS_INVITE [FFSharedController sharedController].isInvite
#define BUTTON_TAG 10086

#define SHARED_TITLE @"185手游充值大返利!!!!!快来加入!"
#define SHARED_SUB_TITLE @"邀请你加入!!"
#define SHARED_INVITE_URL [FFSharedController inviteUrl]
#define SHARED_INVITE_IMAGE [UIImage imageNamed:@"aboutus_icon"]
#define GAME_INFO [FFSharedController sharedController].gameInfo
#define FFSharedType ([FFSharedController sharedController].sharedType)

typedef enum : NSUInteger {
    invitedFirend,
    games,
    dynamics,
} SharedType;


@interface FFSharedController ()

@property (nonatomic, strong) UIWindow *sharedWindow;

@property (nonatomic, strong) UIView *sharedView;


@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSDictionary *gameInfo;

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isInvite;

@property (nonatomic, assign) SharedType sharedType;
@property (nonatomic, strong) NSDictionary *dynamicsDict;

@end

static FFSharedController *controller = nil;

@implementation FFSharedController {

}


+ (FFSharedController *)sharedController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[FFSharedController alloc] init];
    });
    return controller;
}


+ (void)inviteFriend {
    if ([FFSharedController sharedController].isShow) {
        return;
    }
    IS_INVITE = YES;
    customEvents(@"shared_Box", @{@"shared_Box":@"邀请好友"});
    [FFSharedController sharedController].sharedType = invitedFirend;
    [FFSharedController sharedController].isShow = YES;
    [FFSharedController sharedController].cancelButton.userInteractionEnabled = NO;
    SHARED_VIEW.userInteractionEnabled = NO;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:SHARED_VIEW];
    BACKGROUND_VIEW.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.3 + 20 + 44);
    [UIView animateWithDuration:0.3 animations:^{
        BACKGROUND_VIEW.frame = CGRectMake(0, kSCREEN_HEIGHT - kSCREEN_WIDTH * 0.3 - 20 - 44, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.3 + 20 + 44);
    } completion:^(BOOL finished) {
        if (finished) {
            [FFSharedController sharedController].isShow = NO;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(respondsToTap:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [SHARED_VIEW addGestureRecognizer:tap];
            SHARED_VIEW.userInteractionEnabled = YES;
            [FFSharedController sharedController].cancelButton.userInteractionEnabled = YES;
        }
    }];
}

+ (void)sharedGameWith:(id)info {
    IS_INVITE = NO;
    if ([info isKindOfClass:[NSDictionary class]]) {
        if (![info[@"url"] isEqualToString:[FFSharedController sharedController].gameInfo[@"url"]]) {
            [FFSharedController sharedController].gameInfo = info;
        }
    }

    customEvents(@"shared_Game", @{@"game_name":info[@"gamename"]});

    if ([FFSharedController sharedController].isShow) {
        return;
    }
    [FFSharedController sharedController].sharedType = games;
    [FFSharedController sharedController].isShow = YES;
    [FFSharedController sharedController].cancelButton.userInteractionEnabled = NO;
    SHARED_VIEW.userInteractionEnabled = NO;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:SHARED_VIEW];
    BACKGROUND_VIEW.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.3 + 20 + 44);
    [UIView animateWithDuration:0.3 animations:^{
        BACKGROUND_VIEW.frame = CGRectMake(0, kSCREEN_HEIGHT - kSCREEN_WIDTH * 0.3 - 20 - 44, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.3 + 20 + 44);
    } completion:^(BOOL finished) {
        if (finished) {
            [FFSharedController sharedController].isShow = NO;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(respondsToTap:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [SHARED_VIEW addGestureRecognizer:tap];
            SHARED_VIEW.userInteractionEnabled = YES;
            [FFSharedController sharedController].cancelButton.userInteractionEnabled = YES;
        }
    }];
}

+ (void)sharedDynamicsWithDict:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        [FFSharedController sharedController].dynamicsDict = dict;
    }
    if ([FFSharedController sharedController].isShow) {
        return;
    }
    [FFSharedController sharedController].sharedType = dynamics;
    [FFSharedController sharedController].isShow = YES;
    [FFSharedController sharedController].cancelButton.userInteractionEnabled = NO;
    SHARED_VIEW.userInteractionEnabled = NO;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:SHARED_VIEW];
    BACKGROUND_VIEW.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.3 + 20 + 44);
    [UIView animateWithDuration:0.3 animations:^{
        BACKGROUND_VIEW.frame = CGRectMake(0, kSCREEN_HEIGHT - kSCREEN_WIDTH * 0.3 - 20 - 44, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.3 + 20 + 44);
    } completion:^(BOOL finished) {
        if (finished) {
            [FFSharedController sharedController].isShow = NO;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(respondsToTap:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [SHARED_VIEW addGestureRecognizer:tap];
            SHARED_VIEW.userInteractionEnabled = YES;
            [FFSharedController sharedController].cancelButton.userInteractionEnabled = YES;
        }
    }];
}

- (void)respondsToTap:(UITapGestureRecognizer *)sender {
    [FFSharedController sharedController].cancelButton.userInteractionEnabled = NO;
    SHARED_VIEW.userInteractionEnabled = NO;
    BACKGROUND_VIEW.frame = CGRectMake(0, kSCREEN_HEIGHT - kSCREEN_WIDTH * 0.3 - 20 - 44, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.3 + 20 + 44);
    [UIView animateWithDuration:0.3 animations:^{
        BACKGROUND_VIEW.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.3 + 20 + 44);
    } completion:^(BOOL finished) {
        [SHARED_VIEW removeFromSuperview];
        SHARED_VIEW.userInteractionEnabled = YES;
        [FFSharedController sharedController].cancelButton.userInteractionEnabled = YES;
    }];
}


+ (UIWindow *)sharedWindow {
    return [FFSharedController sharedController].sharedWindow;
}

+ (UIView *)sharedView {
    return [FFSharedController sharedController].sharedView;
}

#pragma mark - ===========================微信分享======================================
/** 朋友圈 */
+ (void)shareToFirednCircleWithTitle:(NSString *)title
                            SubTitle:(NSString *)subTitle
                                 Url:(NSString *)url
                               Image:(UIImage *)image {

    WXWebpageObject *object = [WXWebpageObject object];
    object.webpageUrl = url;

    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = subTitle;
    [message setThumbImage:[self imageWithImage:image scaledToSize:CGSizeMake(80, 80)]];
    message.mediaObject = object;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;

    [WXApi sendReq:req];
//    [WXApi send]
}

/** 微信好友 */
+ (void)shareToWexinFirendWithTitle:(NSString *)title
                       SubTitle:(NSString *)subTitle
                            Url:(NSString *)url
                          Image:(UIImage *)image {
    WXWebpageObject *object = [WXWebpageObject object];
    object.webpageUrl = url;

    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = subTitle;
    [message setThumbImage:[self imageWithImage:image scaledToSize:CGSizeMake(80, 80)]];
    message.mediaObject = object;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;

    [WXApi sendReq:req];
}

/** QQ空间 */
+ (void)shareToQQZoneWithTitle:(NSString *)title
                      SubTitle:(NSString *)subTitle
                           Url:(NSString *)url
                         Image:(NSData *)imageData {

    QQApiNewsObject *object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:subTitle previewImageData:imageData];

    object.shareDestType = ShareDestTypeQQ;

    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];

    [QQApiInterface SendReqToQZone:req];
}

/** QQ 好友 */
+ (void)shareToQQFriendWithTitle:(NSString *)title
                        SubTitle:(NSString *)subTitle
                             Url:(NSString *)url
                           Image:(NSData *)imageData {

    QQApiNewsObject *object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:subTitle previewImageData:imageData];

    object.shareDestType = ShareDestTypeQQ;

    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];

    [QQApiInterface sendReq:req];
}

//压缩图片
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);

    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];

    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();

    // End the context
    UIGraphicsEndImageContext();

    // Return the new image.
    return newImage;
}


#pragma mark - shared invite method
+ (NSString *)inviteUrl {
    NSString *url = [NSString stringWithFormat:@"%@?c=%@&u=%@",[FFMapModel map].FREND_RECOM,Channel,SSKEYCHAIN_UID];
    return url;
}

+ (NSString *)dynamicsUrl {
    NSString *url = [NSString stringWithFormat:@"%@?id=%@",[FFMapModel map].DYNAMICS_WAP_INFO,[FFSharedController sharedController].dynamicsDict[@"id"]];
    return url;
}

+ (void)sharedInviteToFriendCircle {
    [FFSharedController shareToFirednCircleWithTitle:SHARED_TITLE SubTitle:SHARED_SUB_TITLE Url:SHARED_INVITE_URL Image:SHARED_INVITE_IMAGE];
}

+ (void)sharedInviteToWeixin {
    [FFSharedController shareToWexinFirendWithTitle:SHARED_TITLE SubTitle:SHARED_SUB_TITLE Url:SHARED_INVITE_URL Image:SHARED_INVITE_IMAGE];
}

+ (void)sharedInviteToQQZone {
    NSData *imageData = UIImagePNGRepresentation(SHARED_INVITE_IMAGE);
    [FFSharedController shareToQQZoneWithTitle:SHARED_TITLE SubTitle:SHARED_SUB_TITLE Url:SHARED_INVITE_URL Image:imageData];
}

+ (void)sharedInviteToQQFriend {
    NSData *imageData = UIImagePNGRepresentation(SHARED_INVITE_IMAGE);
    [FFSharedController shareToQQFriendWithTitle:SHARED_TITLE SubTitle:SHARED_SUB_TITLE Url:SHARED_INVITE_URL Image:imageData];
}

#pragma mark - shared game method
+ (void)sharedGameToFriendCircle {
    [FFSharedController shareToFirednCircleWithTitle:GAME_INFO[@"title"] SubTitle:@"充值大返利!!!" Url:GAME_INFO[@"url"] Image:GAME_INFO[@"image"]];
}

+ (void)sharedGameToWeixin {
    [FFSharedController shareToWexinFirendWithTitle:GAME_INFO[@"title"] SubTitle:@"充值大返利!!!" Url:GAME_INFO[@"url"] Image:GAME_INFO[@"image"]];
}

+ (void)sharedGameToQQZone {
    NSData *imageData = UIImagePNGRepresentation(GAME_INFO[@"image"]);
    [FFSharedController shareToQQZoneWithTitle:GAME_INFO[@"title"] SubTitle:@"充值大返利!!!" Url:GAME_INFO[@"url"] Image:imageData];
}

+ (void)sharedGameToQQFriend {
    NSData *imageData = UIImagePNGRepresentation(GAME_INFO[@"image"]);
    [FFSharedController shareToQQFriendWithTitle:GAME_INFO[@"title"] SubTitle:@"充值大返利!!!" Url:GAME_INFO[@"url"] Image:imageData];
}

#pragma mark - shared dynamics
+ (void)sharedDynamicsToFriendCircle {
    NSDictionary *dict = [FFSharedController sharedController].dynamicsDict;
    NSArray *images = dict[@"images"];
    UIImage *image = (images.count > 0) ? images.firstObject : [UIImage imageNamed:@"aboutus_icon"];
    [FFSharedController shareToFirednCircleWithTitle:dict[@"content"] SubTitle:nil Url:[FFSharedController dynamicsUrl] Image:image];
    [FFSharedController sharedDynamicsSuccess];
}

+ (void)sharedDynamicsToWeXin {
    NSDictionary *dict = [FFSharedController sharedController].dynamicsDict;
    NSArray *images = dict[@"images"];
    UIImage *image = (images.count > 0) ? images.firstObject : [UIImage imageNamed:@"aboutus_icon"];
    [FFSharedController shareToWexinFirendWithTitle:dict[@"content"] SubTitle:nil Url:[FFSharedController dynamicsUrl] Image:image];
    [FFSharedController sharedDynamicsSuccess];
}

+ (void)sharedDynamicsToQQZone {
    NSDictionary *dict = [FFSharedController sharedController].dynamicsDict;
    NSArray *images = dict[@"images"];
    UIImage *image = (images.count > 0) ? images.firstObject : [UIImage imageNamed:@"aboutus_icon"];
    NSData *imageData = UIImagePNGRepresentation([self imageWithImage:image scaledToSize:CGSizeMake(80, 80)]);
    [FFSharedController shareToQQZoneWithTitle:dict[@"content"] SubTitle:nil Url:[FFSharedController dynamicsUrl] Image:imageData];
    [FFSharedController sharedDynamicsSuccess];
}

+ (void)sharedDynamicsToQQFriend {
    NSDictionary *dict = [FFSharedController sharedController].dynamicsDict;
    NSArray *images = dict[@"images"];
    UIImage *image = (images.count > 0) ? images.firstObject : [UIImage imageNamed:@"aboutus_icon"];
    NSData *imageData = UIImagePNGRepresentation([self imageWithImage:image scaledToSize:CGSizeMake(80, 80)]);
    [FFSharedController shareToQQFriendWithTitle:dict[@"content"] SubTitle:nil Url:[FFSharedController dynamicsUrl] Image:imageData];
    [FFSharedController sharedDynamicsSuccess];
}

+ (void)sharedDynamicsSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:SharedDynamicsSuccess object:nil];
}


#pragma mark - responds
- (void)respondsToSharedButton:(UIButton *)sender {
    switch (sender.tag - BUTTON_TAG) {
        case 0: {
            [FFSharedController sharedCircleWith:FFSharedType];
            syLog(@"朋友圈");
            break;
        }
        case 1: {
            [FFSharedController sharedWeiXinWith:FFSharedType];
             syLog(@"微信好友");
            break;
        }
        case 2: {
            [FFSharedController sharedQQZoneWith:FFSharedType];
             syLog(@"QQ空间");
            break;
        }
        case 3: {
            [FFSharedController sharedQQFirendWith:FFSharedType];
            syLog(@"QQ好友");
            break;
        }
        default:
            break;
    }
    [[FFSharedController sharedController] respondsToTap:nil];
}

+ (void)sharedCircleWith:(SharedType)type {
    switch (type) {
        case invitedFirend:[FFSharedController sharedInviteToFriendCircle];
            break;
        case games: [FFSharedController sharedGameToFriendCircle];
            break;
        case dynamics: [FFSharedController sharedDynamicsToFriendCircle];
            break;
        default:
            break;
    }
}

+ (void)sharedWeiXinWith:(SharedType)type {
    switch (type) {
        case invitedFirend:[FFSharedController sharedInviteToWeixin];
            break;
        case games: [FFSharedController sharedGameToWeixin];
            break;
        case dynamics: [FFSharedController sharedDynamicsToWeXin];
            break;
        default:
            break;
    }
}

+ (void)sharedQQZoneWith:(SharedType)type {
    switch (type) {
        case invitedFirend:[FFSharedController sharedInviteToQQZone];
            break;
        case games: [FFSharedController sharedGameToQQZone];
            break;
        case dynamics: [FFSharedController sharedDynamicsToQQZone];
            break;
        default:
            break;
    }
}

+ (void)sharedQQFirendWith:(SharedType)type {
    switch (type) {
        case invitedFirend:[FFSharedController sharedInviteToQQFriend];
            break;
        case games: [FFSharedController sharedGameToQQFriend];
            break;
        case dynamics: [FFSharedController sharedDynamicsToQQFriend];
            break;
        default:
            break;
    }
}

#pragma mark - getter
- (UIWindow *)sharedWindow {
    if (!_sharedWindow) {
        _sharedWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _sharedWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _sharedWindow.windowLevel = (UIWindowLevelNormal + 100);

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_sharedWindow addGestureRecognizer:tap];
    }
    return _sharedWindow;
}

- (UIView *)sharedView {
    if (!_sharedView) {
        _sharedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _sharedView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_sharedView addSubview:self.backGroundView];
    }
    return _sharedView;
}

- (UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - kSCREEN_WIDTH * 0.3 - 20 - 44, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.3 + 20 + 44)];
        _backGroundView.backgroundColor = [UIColor whiteColor];
        [_backGroundView addGestureRecognizer:[UITapGestureRecognizer new]];
        [_backGroundView addSubview:self.cancelButton];

        NSArray *titleArray = @[@"朋友圈",@"微信好友",@"QQ空间",@"QQ好友"];
        NSArray *imageArray = @[@"New_shared_friend",@"New_shared_weixin",@"New_shared_qqzone",@"New_shared_qq"];
        for (NSInteger i = 0; i < 4; i++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];

            button.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 6, kSCREEN_WIDTH / 6);
            button.center = CGPointMake(kSCREEN_WIDTH / 8 * ((2 * i) + 1), kSCREEN_WIDTH / 7);
//            button.backgroundColor = [UIColor blackColor];
            [button setImage:[UIImage imageNamed:imageArray[i]] forState:(UIControlStateNormal)];
            button.tag = BUTTON_TAG + i;
            [button addTarget:self action:@selector(respondsToSharedButton:) forControlEvents:(UIControlEventTouchUpInside)];
            [_backGroundView addSubview:button];

            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame), button.frame.size.width, 30)];
            title.textAlignment = NSTextAlignmentCenter;
            title.text = titleArray[i];
            title.font = [UIFont systemFontOfSize:14];
            title.textColor = [UIColor lightGrayColor];
            [_backGroundView addSubview:title];
        }
    }
    return _backGroundView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _cancelButton.frame = CGRectMake(0, kSCREEN_WIDTH * 0.3 + 20, kSCREEN_WIDTH, 44);
        [_cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [_cancelButton addTarget:self action:@selector(respondsToTap:) forControlEvents:(UIControlEventTouchUpInside)];
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 2);
        layer.backgroundColor = BACKGROUND_COLOR.CGColor;
        [_cancelButton.layer addSublayer:layer];
    }
    return _cancelButton;
}





@end
