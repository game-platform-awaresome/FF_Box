//
//  FFCommodityCell.h
//  GameBox
//
//  Created by 燚 on 2018/6/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFCommodityCell : UITableViewCell


@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIImageView *pimageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;


@end
