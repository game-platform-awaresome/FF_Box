//
//  FFBasicSSTableViewCell.h
//  GameBox
//
//  Created by 燚 on 2018/5/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBasicSSTableViewController.h"


typedef void(^CellScrollViewScrollBlock)(BOOL isScroll);



@interface FFBasicSSTableViewCell : UITableViewCell


//子控制器是否可以滑动  YES可以滑动
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) NSArray<FFBasicSSTableViewController *> *dataArray;

@property (nonatomic, assign) BOOL canHorizontalScroll;

@property (nonatomic, strong) CellScrollViewScrollBlock scrollBlock;


+ (instancetype)cell;





@end
