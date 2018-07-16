//
//  SYH5Configuration.h
//  SY185H5SDK
//
//  Created by 燚 on 2018/7/10.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYH5Configuration : NSObject

@property (nonatomic, strong) NSString              *urlString;
@property (nonatomic, strong) NSString              *userID;
@property (nonatomic, strong) NSString              *token;
@property (nonatomic, strong) NSString              *deviceType;
@property (nonatomic, strong) NSString              *platform;
@property (nonatomic, strong) NSString              *appKey;
@property (nonatomic, strong, readonly) NSString    *sign;


@end
