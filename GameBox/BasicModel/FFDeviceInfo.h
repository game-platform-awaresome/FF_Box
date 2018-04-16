//
//  FFDeviceInfo.h
//  GameBox
//
//  Created by 燚 on 2018/3/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFDeviceInfo : NSObject

+ (NSString *)channel;

+ (NSString *)deviceID;

+ (NSString *)DeviceIP;

+ (NSString *)phoneType;

+ (NSString *)systemVersion;

+ (NSString *)appVersion;

+ (NSString *)signWithParms:(NSDictionary *)params WithKeys:(NSArray *)keys;



@end
