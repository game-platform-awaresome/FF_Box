//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"
#import "FFBusinessModel.h"
#import "FFBusinessBuyModel.h"
#import <FFTools/FFTools.h>

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) {
            case WXSuccess:
                [UIAlertController showAlertMessage:@"支付成功" dismissTime:0.7 dismissBlock:nil];
                break;

            default:
                [FFBusinessBuyModel cancelOrder:nil];
                break;
        }

    } else {
        [UIAlertController showAlertMessage:@"发生未知错误" dismissTime:0.7 dismissBlock:nil];
    }
}



@end
