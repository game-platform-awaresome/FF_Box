//
//  FFCommodityHeaderView.h
//  GameBox
//
//  Created by 燚 on 2018/6/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FFCommodityModel : NSObject


@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *creatTime;
@property (nonatomic, strong) NSString *boxGameID;
@property (nonatomic, strong) NSString *pdescription;
@property (nonatomic, strong) NSString *gameLogoUrl;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *gameSize;
@property (nonatomic, strong) NSArray  *imageArray;
@property (nonatomic, strong) NSString *payMoney;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *serverName;
@property (nonatomic, strong) NSString *system;
@property (nonatomic, strong) NSString *title;


+ (FFCommodityModel *)sharedModel;

- (void)setInfoWithDict:(NSDictionary *)dict;


@end





@interface FFCommodityHeaderView : UIView


- (void)refreshData;


@end



















