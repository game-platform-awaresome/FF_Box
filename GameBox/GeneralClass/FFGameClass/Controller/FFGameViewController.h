//
//  FFGameViewController.h
//  GameBox
//
//  Created by 燚 on 2018/4/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicScrollSelectController.h"

@interface FFGameViewController : FFBasicScrollSelectController

/** game id */
@property (nonatomic, strong) NSString *gid;

/** instancetype */ 
+ (instancetype)sharedController;



@end
