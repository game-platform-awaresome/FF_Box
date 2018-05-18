//
//  FFViewFactory.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/31.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "MJRefresh.h"


#define BOX_MESSAGE(message) [FFViewFactory showAlertMessage:message dismissTime:0.8 dismiss:nil]
#define BOX_START_ANIMATION  [FFViewFactory startWaitAnimation]
#define BOX_STOP_ANIMATION [FFViewFactory stopWaitAnimation]
#define REQUEST_MESSAGE BOX_MESSAGE(content[@"msg"])

@interface FFViewFactory : NSObject

/** table view */
+ (UITableView *)creatTableView:(UITableView *)tablView WithFrame:(CGRect)frame WithDelegate:(id)delegate ;

/** mj view */
+ (MJRefreshNormalHeader *)customRefreshHeaderWithTableView:(UITableView *)tableView WithTarget:(id)target;

/** 显示提示框 */
+ (void)showAlertMessage:(NSString *)message dismissTime:(float)second dismiss:(void(^)(void))dismiss;

/** 开始等待动画 */
+ (void)startWaitAnimation;
/** 结束等待动画 */
+ (void)stopWaitAnimation;


@end
