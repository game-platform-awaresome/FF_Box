//
//  NSUserDefaults+FFUserDefaults.h
//  FFTools
//
//  Created by 燚 on 2018/8/30.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (FFUserDefaults)


/**
 *  Set safe object to the user defaults, it will filter all nil or Null object,
 *
 *  @param object       The object to be saved.
 *  @param key          The only key.
 */
- (BOOL)ff_setObject:(id)object forKey:(NSString *)key;


bool ff_userDefaultsSetObject(id object, NSString *key);



@end
