//
//  ActivityCell.h
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activityLogo;

@property (nonatomic, strong) NSDictionary *dict;

@end
