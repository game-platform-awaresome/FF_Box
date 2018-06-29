//
//  FFMainWindow.m
//  GameBox
//
//  Created by 燚 on 2018/6/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFMainWindow.h"
#import "FFControllerManager.h"

@interface FFMainWindow ()


@end


static FFMainWindow *window = nil;
@implementation FFMainWindow

+ (FFMainWindow *)sharedWindow {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (window == nil) {
            window = [[FFMainWindow alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
            window.rootViewController = [FFControllerManager sharedManager].rootNavController;
        }
    });
    return window;
}


+ (BOOL)showWindowWithOriWindw:(UIWindow *)oriWindow {
    [oriWindow resignKeyWindow];
    oriWindow = nil;
    oriWindow = [self sharedWindow];
    if (oriWindow) {
        [oriWindow makeKeyAndVisible];
        return YES;
    } else {
        return NO;
    }
}




@end
