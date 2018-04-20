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

@interface FFDeviceInfo : NSObject

+ (NSString *)channel;

+ (NSString *)deviceID;

+ (NSString *)DeviceIP;

+ (NSString *)phoneType;

+ (NSString *)systemVersion;

+ (NSString *)appVersion;

+ (NSString *)signWithParms:(NSDictionary *)params WithKeys:(NSArray *)keys;



@end
