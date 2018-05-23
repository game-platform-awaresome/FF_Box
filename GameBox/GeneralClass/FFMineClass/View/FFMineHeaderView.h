//
//  FFMineHeaderView.h
//  GameBox
//
//  Created by 燚 on 2018/5/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef BOOL(^RespondsLoginBlock)(void);
typedef void(^RespondsModifyAvatar)(void);
typedef NSString*(^RespondsModifyNickName)(void);
typedef void(^RespondsOpenVip)(void);
typedef void(^RespondsGoldCenter)(void);
typedef void(^RespondsPlatform)(void);

@interface FFMineHeaderView : UIView


@property (nonatomic, strong) RespondsLoginBlock loginBlock;
@property (nonatomic, strong) RespondsModifyAvatar modifyAratarBlock;
@property (nonatomic, strong) RespondsModifyNickName modifyNickName;
@property (nonatomic, strong) RespondsOpenVip openVip;
@property (nonatomic, strong) RespondsGoldCenter goldCenter;
@property (nonatomic, strong) RespondsPlatform  platform;

- (void)refreshUserInterface;



@end
