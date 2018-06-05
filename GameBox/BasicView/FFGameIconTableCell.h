//
//  FFGameIconTableCell.h
//  GameBox
//
//  Created by 燚 on 2018/6/4.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFGameIconTableCell;

@protocol FFGameIconTableCellDelegate <NSObject>

- (void)FFGameIconTableCell:(FFGameIconTableCell *)cell selectItemWithInfo:(id)info;

@end;

@interface FFGameIconTableCell : UITableViewCell

@property (nonatomic, weak) id<FFGameIconTableCellDelegate> delegate;
@property (nonatomic, strong) NSArray *array;


@end
