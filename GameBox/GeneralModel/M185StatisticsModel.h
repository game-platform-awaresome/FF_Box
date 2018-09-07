/**
 *  2018-09-07. 投放要求添加的数据统计.
 *
 *  这个数据统计设计的很迷, 别问, 问了也不知道为什么这么设计.
 *  出一次文档, 一次文档的需求都不一样.
 *  现在这个类, 后续很难升级,如果有新的需求 ,很不好添加修改.
 */


#import <Foundation/Foundation.h>
#import "FFGameModel.h"

@interface M185StatisticsModel : NSObject


@property (nonatomic, strong) NSMutableArray *dataArray;


M185StatisticsModel * m185StatisticsModel(void);


void m185Statistics(NSString * message , FFGameServersType type);

void m185StatisticsUploadData(void);


@end


























