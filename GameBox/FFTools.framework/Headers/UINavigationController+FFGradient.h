//
//  UINavigationController+FFGradient.h
//  FFTools
//
//  Created by 燚 on 2018/4/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+FFGradient.h"

@interface UINavigationController (FFGradient) <UINavigationBarDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *FFGradient;

- (void)setNeedsNavigationBackground:(CGFloat)alpha;



@end
