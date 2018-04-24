//
//  FFWaitIngManager.h
//  GameBox
//
//  Created by 燚 on 2018/4/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface FFWaitingManager : NSObject


+ (instancetype)SharedManager;

+ (void)startWaitingWithView:(UIView *)view;


+ (void)startWaiting;
+ (void)stopWatiting;


+ (void)startStatubarWaiting;
+ (void)stopStatubarWating;





@end


