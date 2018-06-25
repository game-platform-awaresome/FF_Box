//
//  FFBusinessSearchViewController.h
//  GameBox
//
//  Created by 燚 on 2018/6/12.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicTableViewController.h"
@class FFBusinessSearchViewController;

@protocol FFBusinessSearchDelegate <NSObject>

- (void)FFBusinessSearchViewController:(FFBusinessSearchViewController *)controller didSelectGameName:(id)gameName;


@end


@interface FFBusinessSearchViewController : FFBasicTableViewController

@property (nonatomic, weak) id <FFBusinessSearchDelegate> delegate;



@end
