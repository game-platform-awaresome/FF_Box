//
//  FFRankHeaderView.h
//  GameBox
//
//  Created by 燚 on 2018/8/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RespondsToGame)(NSDictionary *dict);

@interface FFRankHeaderView : UIView

@property (nonatomic, strong) NSArray   *showArray;
@property (nonatomic, strong) RespondsToGame clickGame;

@end
