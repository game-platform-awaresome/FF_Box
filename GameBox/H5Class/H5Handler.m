//
//  H5Handler.m
//  GameBox
//
//  Created by 燚 on 2018/7/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "H5Handler.h"
#import <SY185H5SDK/SY185H5SDK.h>
#import <SY_185SDK/SY_185SDK.h>
#import "FFUserModel.h"
#import "FFControllerManager.h"
#import <FFTools/FFTools.h>
#import <objc/runtime.h>


typedef void(^LoginBlock)(NSDictionary *content,BOOL success);


@interface H5Handler ()<SYH5InstanceDelegate, SY185SDKDelegate>

@property (nonatomic, strong) NSString      *appID;
@property (nonatomic, strong) NSString      *clientKey;
@property (nonatomic, strong) NSString      *urlString;
@property (nonatomic, strong) NSString      *username;
@property (nonatomic, strong) NSString      *password;


@property (nonatomic, strong) LoginBlock loginBLock;


@end


static H5Handler *_handler = nil;
@implementation H5Handler


+ (H5Handler *)handler {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_handler) {
            _handler = [[H5Handler alloc] init];
        }
    });
    return _handler;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [SY185SDK SDKShowMessage];
    }
    return self;
}

+ (void)initWithAppID:(NSString *)appID ClientKey:(NSString *)clientKey H5Url:(NSString *)H5Url {
    [self handler].appID = appID;
    [self handler].clientKey = clientKey;
    [self handler].urlString = H5Url;

//    [[FFControllerManager sharedManager].rootNavController presentViewController:[self handler].H5ViewController animated:YES completion:nil];


    //初始化 SDK.
    [SY185SDK initWithAppID:appID Appkey:clientKey Delegate:[self handler] UseWindow:YES];

}


- (void)loadRequest {
    if (self.username == nil || self.password == nil) {
        return;
    }
    [self setLoginBLock:^(NSDictionary *content, BOOL success) {
        syLog(@"登录 回调 === %@",content);
    }];
    //登录
    [self loginWith:[self username] Password:[self password]];
}

#pragma mark - method
- (void)loginWith:(NSString *)username Password:(NSString *)password  {
    NSString *classString = @"LoginController";
    Class LoginController = NSClassFromString(classString);
    if (LoginController) {
        syLog(@"find %@ success",classString);
        SEL SharedController = NSSelectorFromString(@"sharedController");
        if ([LoginController respondsToSelector:SharedController]) {
            IMP imp = [LoginController methodForSelector:SharedController];
            id (*func)(void) = (void *)imp;
            id controller = func();
            syLog(@"controller === %@",controller);
            if (controller) {
                SEL sharedSDK = NSSelectorFromString(@"sharedSDK");
                if ([SY185SDK respondsToSelector:sharedSDK]) {
                    IMP imp = [SY185SDK methodForSelector:sharedSDK];
                    SY185SDK * (*func)(void) = (void *)imp;
                    SY185SDK *sdk = func();
                    [controller setValue:sdk forKey:@"delegate"];
                    SEL loginSelector = NSSelectorFromString(@"loginWithUserName:Account:Password:WithController:");
                    if ([controller respondsToSelector:loginSelector]) {
                        IMP imp = [controller methodForSelector:loginSelector];
                        void (*func)(id,SEL,BOOL,id,id,id) = (void *)imp;
                        func(controller,loginSelector,YES,username,password,nil);
                    } else {
                        syLog(@"%@ error -> %@ not exist",controller,@"login method");
                    }
                } else {
                    syLog(@"sdk error -> login delegate not exist");
                }
            } else {
                syLog(@"%@ error -> %@ not exist",classString,@"sharedController");
            }
        }
    } else {
        syLog(@"%s error -> %@ not exist",__func__,classString);
    }
}


#pragma mark - setter


#pragma mark - getter
- (NSString *)username {
    return [FFUserModel UserName];
}

- (NSString *)password {
    return [FFUserModel passWord];
}

- (id)H5ViewController {
    if (self.username == nil || self.password == nil) {
        return nil;
    }
    return [SYH5Instance sharedInstance];
}


#pragma makr - h5 instance delegate
/** 接收到的之前添加的 JS 的调用原生的方法 */
//- (void)SYH5Instance:(SYH5Instance *)instance respondsToJSCustomMessage:(WKScriptMessage *)message;

- (void)SYH5Instance:(SYH5Instance *)instance respondsToLogin:(id)info {

}

- (void)SYH5Instance:(SYH5Instance *)instance respondsToSignOut:(id)info {
    [SY185SDK signOut];
//    [[FFControllerManager sharedManager].currentNavController popViewControllerAnimated:YES];
}

- (void)SYH5Instance:(SYH5Instance *)instance respondsToPay:(id)info {
    NSLog(@"发起支付 == %@",info);
    NSString *buyNum = [NSString stringWithFormat:@"%@",info[@"buyNum"]];
    NSString *coinNum = [NSString stringWithFormat:@"%@",info[@"coinNum"]];
    NSString *extension = [NSString stringWithFormat:@"%@",info[@"extension"]];
    NSString *price = [NSString stringWithFormat:@"%@",info[@"price"]];
    NSString *productDesc = [NSString stringWithFormat:@"%@",info[@"productDesc"]];
    NSString *productId = [NSString stringWithFormat:@"%@",info[@"productId"]];
    NSString *productName = [NSString stringWithFormat:@"%@",info[@"productName"]];
    NSString *roleId = [NSString stringWithFormat:@"%@",info[@"roleId"]];
    NSString *roleName = [NSString stringWithFormat:@"%@",info[@"roleName"]];
    NSString *serverId = [NSString stringWithFormat:@"%@",info[@"serverId"]];
    NSString *serverName = [NSString stringWithFormat:@"%@",info[@"serverName"]];
    [SY185SDK payStartWithServerID:serverId serverName:serverName roleID:roleId roleName:roleName productID:productId productName:productName amount:price extension:extension];
}
- (void)SYH5Instance:(SYH5Instance *)instance respondsToSubmitData:(id)info {
    NSLog(@"上报数据 == %@",info);
    NSString *dataType = [NSString stringWithFormat:@"%@",info[@"dataType"]];
    NSString *moneyNum = [NSString stringWithFormat:@"%@",info[@"moneyNum"]];
    NSString *roleID = [NSString stringWithFormat:@"%@",info[@"roleID"]];
    NSString *roleLevel = [NSString stringWithFormat:@"%@",info[@"roleLevel"]];
    NSString *roleName = [NSString stringWithFormat:@"%@",info[@"roleName"]];
    NSString *serverID = [NSString stringWithFormat:@"%@",info[@"serverID"]];
    NSString *serverName = [NSString stringWithFormat:@"%@",info[@"serverName"]];
    NSString *vip = [NSString stringWithFormat:@"%@",info[@"vip"]];
    [SY185SDK submitExtraDataWithType:dataType.integerValue ServerID:serverID ServerName:serverName RoleID:roleID RoleName:roleName RoleLevel:roleLevel Money:moneyNum VipLevel:vip];
}
#pragma mark - 185 sdk delegate
//初始化回调
- (void)m185SDKInitCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *)dict {
    if (success) {
        [self loadRequest];
    } else {
        [[SYH5Instance sharedInstance] dismissViewControllerAnimated:YES completion:^{
            [UIAlertController showAlertMessage:@"游戏加载失败,请稍后尝试" dismissTime:0.7 dismissBlock:nil];
        }];
    }
}
//登录回调
- (void)m185SDKLoginCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *)dict {
    syLog(@"h5 登录回调");
    if (success) {
        NSString *username = [dict objectForKey:@"username"];
        NSString *token = [dict objectForKey:@"token"];
        SYH5Configuration *config = [[SYH5Configuration alloc] init];
        config.urlString = self.urlString;
        config.userID = username;
        config.token = token;
        config.deviceType = @"2";
        config.platform = @"185sy";
        config.appKey = self.clientKey;
        [SYH5Instance sharedInstance].delegate = self;
        [SYH5Instance sharedInstance].config = config;
        [[SYH5Instance sharedInstance] loadRequest];
    } else {
        [[SYH5Instance sharedInstance] dismissViewControllerAnimated:YES completion:^{
            [UIAlertController showAlertMessage:@"游戏加载失败,请稍后尝试" dismissTime:0.7 dismissBlock:nil];
        }];
    }
}
//登出回调
- (void)m185SDKLogOutCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *)dict {
    if (success) {
        [[FFControllerManager sharedManager].currentNavController popViewControllerAnimated:YES];
    }
}
//充值回调
- (void)m185SDKRechargeCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *)dict {
    [[SYH5Instance sharedInstance] CallBackToJSWithSuccess:success completionHandler:^(id _Nullable message, NSError * _Nullable error) {

    }];
}
//发送道具成功回调
- (void)m185SDKGMFunctionSendPropsCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *)dict {


}







@end
