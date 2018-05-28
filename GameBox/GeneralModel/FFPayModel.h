//
//  FFPayModel.h
//  GameBox
//
//  Created by 燚 on 2018/5/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicModel.h"

/** 支付的枚举 */
typedef enum : NSUInteger {
    AliQRcode = 1,
    Alipay = 2,
    WechatQRcode = 3,
    WechatPay = 4,
    TenPay = 6,
    ChinaMobile = 7,
    ChinaTelecom = 8,
    ChinaUnicom = 9,
    platformCoin = 10
} PayType;


@interface FFPayModel : FFBasicModel

/** 支付用的参数 */
@property (nonatomic, strong) NSString *serverID;
@property (nonatomic, strong) NSString *serverNAME;
@property (nonatomic, strong) NSString *roleID;
@property (nonatomic, strong) NSString *roleNAME;
@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) NSString *productNAME;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *extend;
@property (nonatomic, assign) NSString *payType;
@property (nonatomic, strong) NSString *payModel;
@property (nonatomic, strong) NSString *cardID;
@property (nonatomic, strong) NSString *cardPass;
@property (nonatomic, strong) NSString *cardMoney;


+ (FFBasicModel *)sharedModel;

/** 准备支付 */
+ (void)payReadyWithCompletion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 发起支付 */
//- (void)payStartWithCompletion:(void(^)(NSDictionary *content, BOOL success))completion;

/** 开始支付 */
+ (void)payStartWithproductID:(NSString *)productID
                      payType:(NSString *)payType
                       amount:(NSString *)amount
                   Completion:(void(^)(NSDictionary *content, BOOL success))completion;

/** 支付状态查询 */
+ (void)payQueryWithOrderID:(NSString *)orderID
                 Completion:(void(^)(NSDictionary *content,BOOL success))completion;




@end
