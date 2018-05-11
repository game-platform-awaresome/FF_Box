//
//  FFMapModel.m
//  GameBox
//
//  Created by 燚 on 2018/4/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFMapModel.h"
#import "FFNetWorkManager.h"


static NSString *const map_url = @ "http://api.185sy.com/index.php?g=api&m=indexbox&a=map";


@interface FFMapModel()


@end

static FFMapModel *model = nil;

@implementation FFMapModel

+ (instancetype)map {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[FFMapModel alloc] init];
            [model setAllPropertyWithDict:[FFMapModel mapDict]];
        }
    });
    return model;
}

+ (void)getMap {
    [FFNetWorkManager postRequestWithURL:map_url Params:nil Success:^(NSDictionary * _Nonnull content) {
        NSDictionary *dict = content[@"data"];
        syLog(@"map === %@",content);
        BOXLOG(@"map url initialize success");
        [[FFMapModel map] setAllPropertyWithDict:dict];
        BOXLOG(@"map plist writeing");
        [dict writeToFile:[FFMapModel plistPath] atomically:YES];
        BOXLOG(@"map plist writesuccess");
    } Failure:^(NSError * _Nonnull error) {
        BOXLOG(@"map url initialize failure");
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[FFMapModel plistPath]];
        if (dict == nil) {
            dict = [FFMapModel mapDict];
        }
        [[FFMapModel map] setAllPropertyWithDict:dict];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BOXLOG(@"map url reinitialize");
            [FFMapModel getMap];
        });
    }];
}

+ (NSString *)plistPath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"FFMapUrl.plist"];
    return filePath;
}


#pragma mark - getter
+ (NSDictionary *)mapDict {
    NSDictionary *mapDict =
    @{@"DOAMIN":@"http://www.185sy.com",
      @"GAME_BOX_INSTALL_INFO":@"http://www.185sy.com/api-game-boxInstallInfo",
      @"GAME_BOX_START_INFO":@"http://www.185sy.com/api-game-boxStartInfo",
      @"GAME_CHANNEL_DOWNLOAD":@"http://www.185sy.com/api-game-channelDownload",
      @"GAME_CHECK_CLIENT":@"http://www.185sy.com/api-game-checkClient",
      @"GAME_CLASS":@"http://www.185sy.com/api-game-gameClass",
      @"GAME_CLASS_INFO":@"http://www.185sy.com/api-game-gameClassInfo",
      @"GAME_COLLECT":@"http://www.185sy.com/api-game-collect",
      @"GAME_DOWNLOAD_RECORD":@"http://www.185sy.com/api-game-downloadRecord",
      @"GAME_ERROR_LOG":@"http://www.185sy.com/api-game-uploadErrorLog",
      @"GAME_GETALLNAME":@"http://www.185sy.com/api-game-getAllGameName",
      @"GAME_GETHOT":@"http://www.185sy.com/api-game-hotGameSearch",
      @"GAME_GET_START_IMGS":@"http://api.185sy.com/index.php?g=api&m=game&a=getStartImgs",
      @"GAME_GONGLUE":@"http://www.185sy.com/api-article-get_list_by_game",
      @"GAME_GRADE":@"http://www.185sy.com/api-game-gameGrade",
      @"GAME_INDEX":@"http://www.185sy.com/api-game-index",
      @"GAME_INFO":@"http://www.185sy.com/api-game-gameInfo",
      @"GAME_INSTALL":@"http://www.185sy.com/api-game-gameInstall",
      @"GAME_MY_COLLECT":@"http://www.185sy.com/api-game-myCollect",
      @"GAME_OPEN_SERVER":@"http://www.185sy.com/api-game-gameOpenServer",
      @"GAME_PACK":@"http://www.185sy.com/api-packs-get_list_by_game",
      @"GAME_SEARCH_LIST":@"http://www.185sy.com/api-game-gameSearchList",
      @"GAME_TYPE":@"http://www.185sy.com/api-game-gameType",
      @"GAME_UNINSTALL":@"http://www.185sy.com/api-game-gameUninstall",
      @"GAME_UPDATA":@"http://www.185sy.com/api-game-gameUpdata",
      @"INDEX_ARTICLE":@"http://www.185sy.com/api-article-get_list",
      @"INDEX_SLIDE":@"http://www.185sy.com",
      @"OPEN_SERVER":@"http://www.185sy.com/api-game-openServer",
      @"PACKS_LINGQU":@"http://www.185sy.com/api-packs-get_pack",
      @"PACKS_LIST":@"http://www.185sy.com/api-packs-get_list",
      @"PACKS_SLIDE":@"http://www.185sy.com/api-packs-get_slide",
      @"USER_CHECKMSG":@"http://www.185sy.com/api-user-check_smscode",
      @"USER_FINDPWD":@"http://www.185sy.com/api-user-forget_password",
      @"USER_LOGIN":@"http://www.185sy.com/api-user-login",
      @"USER_MODIFYNN":@"http://www.185sy.com/api-user-modify_nicename",
      @"USER_MODIFYPWD":@"http://www.185sy.com/api-user-modify_password",
      @"USER_PACK":@"http://www.185sy.com/api-packs-get_list_by_user",
      @"USER_REGISTER":@"http://www.185sy.com/api-user-register",
      @"USER_SENDMSG":@"http://www.185sy.com/api-user-send_message",
      @"USER_UPLOAD":@"http://www.185sy.com/api-user-upload_portrait",
      @"CHANGEGAME_APPLY":@"http://api.185sy.com/index.php?g=api&m=changegame&a=apply",
      @"CHANGEGAME_LOG":@"http://api.185sy.com/index.php?g=api&m=changegame&a=log",
      @"COIN_INFO":@"http://api.185sy.com/index.php?g=api&m=coin&a=coin_info",
      @"COIN_LOG":@"http://api.185sy.com/index.php?g=api&m=coin&a=log",
      @"COMMENT_COIN":@"http://api.185sy.com/index.php?g=api&m=comment&a=giveCoin",
      @"CUSTOMER_SERVICE":@"http://api.185sy.com/index.php?g=api&m=user&a=customer_service",
      @"DO_SIGN":@"http://api.185sy.com/index.php?g=api&m=sign&a=do_sign",
      @"FREND_RECOM":@"http://tg.sy218.com/user/register/friend_recom_register.html",
      @"FRIEND_RECOM_INFO":@"http://api.185sy.com/index.php?g=api&m=userbox&a=friend_recom_info",
      @"MY_COIN":@"http://api.185sy.com/index.php?g=api&m=coin&a=my_coin",
      @"PAY_QUERY":@"http://api.185sy.com/index.php?g=api&m=pay&a=payQuery",
      @"PAY_READY":@"http://api.185sy.com/index.php?g=api&m=pay&a=payReady",
      @"PAY_START":@"http://api.185sy.com/index.php?g=api&m=pay&a=payStart",
      @"PLAT_EXCHANGE":@"http://api.185sy.com/index.php?g=api&m=platformmoney&a=exchange",
      @"PLAT_LOG":@"http://api.185sy.com/index.php?g=api&m=platformmoney&a=log",
      @"REBATE_INFO":@"http://api.185sy.com/index.php?g=api&m=selfRebate&a=rebateInfo",
      @"REBATE_NOTICE":@"http://api.185sy.com/index.php?g=api&m=selfRebate&a=rebateNotice",
      @"REBATE_RECORD":@"http://api.185sy.com/index.php?g=api&m=selfRebate&a=rebateRecord",
      @"SIGN_INIT":@"http://api.185sy.com/index.php?g=api&m=sign&a=sign_init",
      @"USER_CENTER":@"http://api.185sy.com/index.php?g=api&m=userbox&a=user_center",
      @"VIP_OPTION":@"http://api.185sy.com/index.php?g=api&m=pay&a=getVipOption",
      @"REBATE_APPLY":@"http://api.185sy.com/index.php?g=api&m=selfRebate&a=rebateApply",
      @"REBATE_KNOW":@"http://api.185sy.com/index.php?g=api&m=selfRebate&a=rebateKnow",
      @"CHANGEGAME_NOTICE":@"http://api.185sy.com/index.php?g=api&m=changegame&a=notice",
      @"USER_BIND_MOBILE":@"http://api.185sy.com/index.php?g=api&m=user&a=bind_mobile",
      @"USER_UNBIND_MOBILE":@"http://api.185sy.com/index.php?g=api&m=user&a=unbind_mobile",
      @"MY_PRIZE":@"http://api.185sy.com/index.php?g=api&m=luckydraw&a=myPrize",
      @"APP_NOTICE":@"http://api.185sy.com/index.php?g=api&m=userbox&a=notice",
      @"MESSAGE_LIST":@"http://api.185sy.com/index.php?g=api&m=message&a=get_message_list",
      @"PLAT_REG_BONUS":@"http://api.185sy.com/index.php?g=api&m=platformmoney&a=get_reigster_bonus",
      @"MESSAGE_INFO":@"http://api.185sy.com/index.php?g=api&m=message&a=get_message_info",
      @"MESSAGE_DELETE":@"http://api.185sy.com/index.php?g=api&m=message&a=delete_message",
      @"MESSAGE_UNREAD":@"http://api.185sy.com/index.php?g=api&m=message&a=unread_counts",
      @"GET_PATCH":@"http://api.185sy.com/index.php?g=api&m=userbox&a=get_patch",
      @"PUBLISH_DYNAMICS":@"http://api.185sy.com/index.php?g=api&m=dynamics&a=publishDynamics",
      @"USER_DESC":@"http://api.185sy.com/index.php?g=api&m=userbox&a=user_desc",
      @"DYNAMICS_LIKE":@"http://api.185sy.com/index.php?g=api&m=likeinfo&a=dynamics_like",
      @"FOLLOW_LIST":@"http://api.185sy.com/index.php?g=api&m=userbox&a=follow_list",
      @"USER_EDIT":@"http://api.185sy.com/index.php?g=api&m=userbox&a=edit_desc",
      @"COMMENT_LIKE":@"http://api.185sy.com/index.php?g=api&m=likeinfo&a=comment_like",
      @"GET_DYNAMICS":@"http://api.185sy.com/index.php?g=api&m=dynamics&a=getDynamics",
      @"COMMENT":@"http://api.185sy.com/index.php?g=api&m=comment&a=do_comment",
      @"COMMENT_LIST":@"http://api.185sy.com/index.php?g=api&m=comment&a=comment_list",
      @"COMMENT_DEL":@"http://api.185sy.com/index.php?g=api&m=comment&a=delete_comment",
      @"FOLLOW_OR_CANCEL":@"http://api.185sy.com/index.php?g=api&m=dynamics&a=followOrCancel",
      @"DYNAMICS_WAP_INFO":@"http://api.185sy.com/api/dynamics/webDisplay.html",
      @"SHARE_DYNAMICS":@"http://api.185sy.com/index.php?g=api&m=dynamics&a=shareDynamics",
      @"BOX_INIT":@"http://api.185sy.com/index.php?g=api&m=userbox&a=do_init",
      @"USER_COMMENT_ZAN":@"http://api.185sy.com/index.php?g=api&m=userbox&a=my_comment_zan",
      @"USER_NEW_UP":@"http://api.185sy.com/index.php?g=api&m=userbox&a=new_up_counts",
      @"CANCEL_DYNAMICS_LIKE":@"http://api.185sy.com/index.php?g=api&m=likeinfo&a=cancel_dynamics_like",
      @"CANCEL_COMMENT_LIKE":@"http://api.185sy.com/index.php?g=api&m=likeinfo&a=cancel_comment_like",
      @"COMMENT_COUNTS":@"http://api.185sy.com/index.php?g=api&m=comment&a=get_comment_counts",
      @"DEL_DYNAMIC":@"http://api.185sy.com/index.php?g=api&m=dynamics&a=delDynamic",
      @"PACKAGE_INFO":@"http://api.185sy.com/index.php?g=api&m=package&a=pack_info",
      @"RANKING_LIST":@"http://api.185sy.com/index.php?g=api&m=userbox&a=rankingList",
      @"USER_AGREEMENT":@"http://api.185sy.com/index.php?g=api&m=userbox&a=userAgreement",
      @"RECEIVE_REWARD":@"http://api.185sy.com/index.php?g=api&m=userbox&a=receiveReward",
      @"RANKNOTICE":@"http://api.185sy.com/index.php?g=api&m=userbox&a=rankNotice",
      @"USER_RANKING":@"http://api.185sy.com/index.php?g=api&m=userbox&a=userRanking",
      @"COMMENT_REPLY_LIST":@"http://api.185sy.com/index.php?g=api&m=comment&a=get_replay_comment",
      @"USER_APP_LOGIN":@"http://api.185sy.com/index.php?g=api&m=comment&a=user_login_app",
      @"GAME_NEWINDEX":@"http://www.185sy.com/api-game-newIndex"
      };
    return mapDict;
}

@end
