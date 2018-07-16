//
//  H5Handler.h
//  GameBox
//
//  Created by 燚 on 2018/7/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface H5Handler : NSObject

@property (nonatomic, strong) id H5ViewController;


+ (H5Handler *)handler;


+ (void)initWithAppID:(NSString *)appID ClientKey:(NSString *)clientKey H5Url:(NSString *)H5Url;






@end
