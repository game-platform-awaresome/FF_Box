//
//  FFOpenUUID.h
//  FFTools
//
//  Created by 燚 on 2018/9/10.
//  Copyright © 2018年 Sans. All rights reserved.
//
//  @see Main branches
//       iOS code: https://github.com/ylechelle/OpenUDID


#define ff_OpenUDIDErrorNone          0
#define ff_OpenUDIDErrorOptedOut      1
#define ff_OpenUDIDErrorCompromised   2

#import <Foundation/Foundation.h>

@interface FFOpenUDID : NSObject


+ (NSString *)ff_OpenUDID_Value;
+ (NSString *)valueWithError:(NSError**)error;

+ (void)setOptOut:(BOOL)optOutValue;

+ (NSString*)_generateFreshOpenUDID;


@end

/**
 *  OpenUUID origin Method
 *  @see code: https://github.com/ylechelle/OpenUDID
 */
NSString *ff_value(void);
NSString *ff_valueWithError(NSError *error);


















