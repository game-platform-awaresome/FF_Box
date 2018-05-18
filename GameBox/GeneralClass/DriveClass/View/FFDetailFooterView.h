//
//  FFDetailFooterView.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/19.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFDynamicModel.h"
@class FFDetailFooterView;

@protocol FFDetailFooterViewDelegate <NSObject>

- (void)FFDetailFooterView:(FFDetailFooterView *)view didClickButton:(NSUInteger)idx;


@end


@interface FFDetailFooterView : UIView

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;

@property (nonatomic, weak) id<FFDetailFooterViewDelegate> delegate;

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) FFDynamicModel *model;



@end
