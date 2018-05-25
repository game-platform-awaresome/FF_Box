//
//  FFGameActivityCell.h
//  GameBox
//
//  Created by 燚 on 2018/5/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^GameActivityCellBlock)(NSDictionary *dict);

@interface FFGameActivityCell : UITableViewCell


@property (nonatomic, strong) GameActivityCellBlock block;

@property (nonatomic, strong) NSArray *acitivityArray;



@end
