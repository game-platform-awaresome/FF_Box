//
//  NSArray+FFArray.h
//  FFTools
//
//  Created by Sans on 2018/8/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FFArray)


/**
 *  It's safe to call this method to reetrieve element.
 *
 *  @param index    The index.
 *
 *  @return The element in the index if index is valid, otherwise nil.
 */
- (id)ff_objectAtIndex:(NSUInteger)index;



@end
