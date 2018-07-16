//
//  H5Handler.m
//  GameBox
//
//  Created by 燚 on 2018/7/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "H5Handler.h"
#import <SY185H5SDK/SY185H5SDK.h>
#import "FFUserModel.h"

@interface H5Handler ()<SYH5InstanceDelegate>

@property (nonatomic, strong) NSString      *appID;
@property (nonatomic, strong) NSString      *clientKey;
@property (nonatomic, strong) NSString      *urlString;
@property (nonatomic, strong) NSString      *username;
@property (nonatomic, strong) NSString      *password;


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

    }
    return self;
}

+ (void)initWithAppID:(NSString *)appID ClientKey:(NSString *)clientKey H5Url:(NSString *)H5Url {
    [self handler].appID = appID;
    [self handler].clientKey = clientKey;
    [self handler].urlString = H5Url;

    //初始化 SDK.

    [[self handler] loadRequest];
}


- (void)loadRequest {
    if (self.username == nil || self.password == nil) {
        return;
    }

    //登录




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

}

- (void)SYH5Instance:(SYH5Instance *)instance respondsToPay:(id)info {

}

- (void)SYH5Instance:(SYH5Instance *)instance respondsToSubmitData:(id)info {

}








@end
