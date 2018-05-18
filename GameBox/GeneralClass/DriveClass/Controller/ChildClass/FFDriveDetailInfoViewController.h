//
//  FFDriveDetailInfoViewController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/19.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveAllInfoViewController.h"
@class FFDriveDetailInfoViewController;


@protocol FFDriveDetailDelegate <NSObject>

@optional
- (void)FFDriveDetailController:(FFDriveDetailInfoViewController *)controller
                    replaceDict:(NSDictionary *)dict
                      indexPath:(NSIndexPath *)indexPath;

- (void)FFDriveDetailController:(FFDriveDetailInfoViewController *)controller
                     SharedWith:(NSIndexPath *)indexPath;
@end


@interface FFDriveDetailInfoViewController : FFDriveAllInfoViewController


@property (nonatomic, assign) BOOL isComment;

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) FFDynamicModel *detailModel;
@property (nonatomic, strong) NSString *dynamic_id;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <FFDriveDetailDelegate> delegate;


@end









