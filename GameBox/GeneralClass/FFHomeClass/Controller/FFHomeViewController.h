//
//  FFHomeViewController.h
//  GameBox
//
//  Created by 燚 on 2018/4/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicSelectViewController.h"
#import "FFHomeSelectView.h"

@interface FFHomeViewController : FFBasicSelectViewController

@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) FFHomeSelectView *homeSelectView;

@property (nonatomic, strong) UIImage *naviBarImage;
@property (nonatomic, strong) UIImage *naviBarlineImage;

@end
