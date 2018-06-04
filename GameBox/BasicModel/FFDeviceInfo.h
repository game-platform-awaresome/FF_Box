//
//  FFDeviceInfo.h
//  GameBox
//
//  Created by 燚 on 2018/3/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Channel             ([FFDeviceInfo channel])
#define DeviceID            ([FFDeviceInfo deviceID])
#define PhoneType           ([FFDeviceInfo phoneType])
#define AppVersion          ([FFDeviceInfo appVersion])

#define BOX_SIGN(dict, pamarasKey) [FFDeviceInfo signWithParms:dict WithKeys:pamarasKey]

#define AppID @"1013"
#define AppKey @"709931298992c123ba79f9394032e91e"

#define SS_SIGN     [dict setObject:BOX_SIGN(dict, pamarasKey) forKey:@"sign"];
#define SS_CHANNEL  [dict setObject:Channel forKey:@"channel"]
#define SS_SYSTEM   [dict setObject:@"2" forKey:@"system"]
#define SS_DEVICEID [dict setObject:DeviceID forKey:@"machine_code"]

@interface FFDeviceInfo : NSObject

+ (NSString *)channel;

+ (NSString *)deviceID;

+ (NSString *)DeviceIP;

+ (NSString *)phoneType;

+ (NSString *)systemVersion;

+ (NSString *)appVersion;

+ (NSString *)signWithParms:(NSDictionary *)params WithKeys:(NSArray *)keys;

+ (NSString *)cheackChannel;

+ (NSString *)cheackVersion;


@end





