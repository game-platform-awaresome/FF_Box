//
//  FFDetailHeaderView.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/19.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFDynamicModel.h"
@class FFDetailHeaderView;

@protocol FFDetailHeaderViewDelegate <NSObject>

- (void)FFDetailHeaderView:(FFDetailHeaderView *)view clickAttentionButton:(id)info;

@end

@interface FFDetailHeaderView : UIView

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) FFDynamicModel *model;
@property (nonatomic, weak) id<FFDetailHeaderViewDelegate> delegate;

- (void)setAttentionWith:(NSString *)str;


@end
