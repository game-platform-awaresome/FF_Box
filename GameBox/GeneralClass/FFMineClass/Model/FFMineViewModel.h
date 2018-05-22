//
//  FFMineViewModel.h
//  GameBox
//
//  Created by 燚 on 2018/5/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FFMineInfoModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subimage;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *attributeString;

@property (nonatomic, strong) UIImage *image;

@end



@interface FFMineViewModel : NSObject

- (NSDictionary *)cellInfoWithIndexpath:(NSIndexPath *)indexPath;

- (NSUInteger)sectionNumber;

- (NSUInteger)itemNumberWithSection:(NSUInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@end




