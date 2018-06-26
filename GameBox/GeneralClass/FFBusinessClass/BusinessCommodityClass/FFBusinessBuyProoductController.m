//
//  FFBusinessBuyProoductController.m
//  GameBox
//
//  Created by 燚 on 2018/6/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessBuyProoductController.h"
#import "FFImageManager.h"
#import "FFColorManager.h"
#import "FFBusinessModel.h"
#import <UIImageView+WebCache.h>
#import "FFCommodityHeaderView.h"
#import <FFTools/FFTools.h>
#import <MBProgressHUD.h>
#import <AlipaySDK/AlipaySDK.h>
#import <WechatOpenSDK/WXApi.h>
#import "FFDeviceInfo.h"
#import "FFBusinessBuyModel.h"

#define WxApiKey @"5fe35b38e8512d6d9eed5091cd4ae298"
#define WxAppID     @"wx998abec7ee53ed78"
#define SinWexinApi(dict,array) OX72444444444(dict,array)



@interface FFBusinessBuyProoductController ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *protuctTitle;
@property (weak, nonatomic) IBOutlet UILabel *productServer;
@property (weak, nonatomic) IBOutlet UILabel *productSystem;
@property (weak, nonatomic) IBOutlet UILabel *amount;

@property (weak, nonatomic) IBOutlet UIButton *alipayButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;

@property (nonatomic, strong) UIButton *buyButton;

@property (nonatomic, assign) FFBusinessPayType paytype;
@property (nonatomic, assign) BOOL isPaying;


@end


static NSString * OX72444444444(NSDictionary *dict,NSArray *array);


@implementation FFBusinessBuyProoductController

+ (instancetype)init {
    return [[UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FFBusinessBuyProoductController"];
}


- (instancetype)init {
    return [FFBusinessBuyProoductController init];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initDataSource];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[FFImageManager General_back_black] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
    self.navigationItem.title = @"购买商品";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.productImageView.layer.cornerRadius = 8;
    self.productImageView.layer.masksToBounds = YES;

    [self.view addSubview:self.buyButton];
    self.alipayButton.selected = YES;
}


- (void)initDataSource {
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[FFCommodityModel sharedModel].imageArray.firstObject]]];
    self.protuctTitle.text = [NSString stringWithFormat:@"游戏 : %@",[FFCommodityModel sharedModel].gameName];
    self.productServer.text = [NSString stringWithFormat:@"区服 : %@",[FFCommodityModel sharedModel].serverName];
    self.productSystem.text = [FFCommodityModel sharedModel].system;
    self.amount.text = [NSString stringWithFormat:@"%@元",[FFCommodityModel sharedModel].amount];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    syLog(@"%ld",indexPath.row);
    if (indexPath.row == 2) {
        self.alipayButton.selected = YES;
        self.wechatButton.selected = NO;
    } else if (indexPath.row == 3) {
        self.alipayButton.selected = NO;
        self.wechatButton.selected = YES;
    }
}



#pragma mark - responds
- (void)respondsToLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToBuyButton {
    syLog(@"购买");
    if (!self.alipayButton.isSelected && !self.wechatButton.isSelected) {
        [UIAlertController showAlertMessage:@"请选择一个支付方式" dismissTime:0.7 dismissBlock:nil];
        return;
    }
    if (_isPaying) {
        return;
    }
    if (self.alipayButton.isSelected) {
        self.paytype = FFBusinessPayAlipay;
    }

    if (self.wechatButton.isSelected) {
        self.paytype = FFBusinessPayWechat;
    }

    _isPaying = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FFBusinessModel payStartWithProductID:[FFCommodityModel sharedModel].productID Uid:[FFBusinessModel uid] Type:self.paytype Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [hud hideAnimated:YES];
        syLog(@"buy content === %@",content);
        if (success) {

            [FFBusinessBuyModel sharedModel].orderID = [NSString stringWithFormat:@"%@",CONTENT_DATA[@"id"]];

            if (self.paytype == FFBusinessPayAlipay && [CONTENT_DATA[@"token"] isKindOfClass:[NSString class]]) {

                NSString *token = [NSString stringWithFormat:@"%@",CONTENT_DATA[@"token"]];
                [[AlipaySDK defaultService] payOrder:token fromScheme:[[NSBundle mainBundle] bundleIdentifier] callback:^(NSDictionary *resultDic) {
                    syLog(@"123124412412351235123512351235");
                }];

            } else if (self.paytype == FFBusinessPayWechat && [CONTENT_DATA[@"token"] isKindOfClass:[NSDictionary class]]) {

                NSDictionary *token =   CONTENT_DATA[@"token"];
                NSMutableDictionary *dict = [CONTENT_DATA[@"token"] mutableCopy];

                PayReq* req     = [[PayReq alloc] init];
                req.partnerId   = [token objectForKey:@"partnerid"];
                req.prepayId    = [token objectForKey:@"prepayid"];
                req.nonceStr    = [token objectForKey:@"noncestr"];
                req.package     = @"Sign=WXPay";
                req.timeStamp   = [NSString stringWithFormat:@"%@",[token objectForKey:@"timestamp"]].intValue;
                req.sign        = OX72444444444(dict,nil);
                [WXApi sendReq:req];

                syLog(@"微信 支付 ?");
            }
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        self.isPaying = NO;
    }];
}


#pragma mark - getter
- (UIButton *)buyButton {
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _buyButton.backgroundColor = [FFColorManager blue_dark];
        _buyButton.frame = CGRectMake(10, kSCREEN_HEIGHT - 53 - CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH - 20, 44);
        [_buyButton setTitle:@"购买" forState:(UIControlStateNormal)];
        _buyButton.layer.cornerRadius = 22;
        _buyButton.layer.masksToBounds = YES;
        [_buyButton addTarget:self action:@selector(respondsToBuyButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _buyButton;
}





@end

NSString * OX72444444444(NSDictionary *dict,NSArray *array) {
    NSMutableString *signString = [NSMutableString string];
    NSString *string = [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=Sign=WXPay&partnerid=%@&prepayid=%@&timestamp=%@&key=%@",WxAppID,dict[@"noncestr"],dict[@"partnerid"],dict[@"prepayid"],dict[@"timestamp"],WxApiKey];
    syLog(@"sign string === %@\n appkey === %@",signString,WxApiKey);
    signString = [[FFDeviceInfo md5:string] copy];
    signString = [[signString uppercaseString] copy];
    return signString;
}






