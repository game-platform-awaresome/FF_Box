//
//  NSTimer+FFTimer.h
//  FFTools
//
//  Created by 燚 on 2018/8/30.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FFTimerCallback)(NSTimer *timer);

@interface NSTimer (FFTimer)


/**
 *  Create a timer with time interval, repeat or not, and callback.
 *
 *  @param interval    Time interval
 *  @param repeats    Whether repeat to schedule.
 *  @param callback The callback block.
 *
 *  @return Timer object.
 */
+ (NSTimer *)ff_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                       repeats:(BOOL)repeats
                                      callback:(FFTimerCallback)callback;

/**
 *  Create a timer with time interval, repeat count, and callback.
 *
 *  @param interval    Time interval
 *  @param count        When count <= 0, it means repeat.
 *  @param callback    The callback block
 *
 *  @return Timer object
 */
+ (NSTimer *)ff_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         count:(NSInteger)count
                                      callback:(FFTimerCallback)callback;


/**
 *    Start timer immediately.
 */
- (void)ff_fireTimer;

/**
 *    Pause timer immediately
 */
- (void)ff_unfireTimer;

/**
 *    Make timer invalidate.
 */
- (void)ff_invalidate;





@end
