//
//  SYH5Instance.h
//  SY185H5SDK
//
//  Created by 燚 on 2018/7/10.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import "SYH5Configuration.h"
#import <WebKit/WebKit.h>
@class SYH5Instance;


@protocol SYH5InstanceDelegate <NSObject>

@optional
/** 接收到的之前添加的 JS 的调用原生的方法 */
- (void)SYH5Instance:(SYH5Instance *)instance respondsToJSCustomMessage:(WKScriptMessage *)message;

- (void)SYH5Instance:(SYH5Instance *)instance respondsToLogin:(id)info;
- (void)SYH5Instance:(SYH5Instance *)instance respondsToSignOut:(id)info;
- (void)SYH5Instance:(SYH5Instance *)instance respondsToPay:(id)info;
- (void)SYH5Instance:(SYH5Instance *)instance respondsToSubmitData:(id)info;

@end



@interface SYH5Instance : UIViewController


@property (nonatomic, strong) SYH5Configuration         *config;
@property (nonatomic, strong) UIWindow                  *window;
@property (nonatomic, strong, readonly) NSString        *url;
@property (nonatomic, weak)   id<SYH5InstanceDelegate>  delegate;

+ (SYH5Instance *)sharedInstance;

- (UIWindow *)showWithConfiguration:(SYH5Configuration *)config;
- (UIWindow *)show;
- (UIWindow *)hide;
- (void)loadRequest;

/** 添加 js 调用的方法 */
- (void)addScriptMessageName:(NSString *)name;
/** 添加 回调 js 的方法 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id message, NSError * _Nullable error))completionHandler;

/** 支付回调 */
- (void)CallBackToJSWithSuccess:(BOOL)success completionHandler:(void (^ _Nullable)(_Nullable id message, NSError * _Nullable error))completionHandler;


@end














