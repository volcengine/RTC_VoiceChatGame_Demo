//
//  GameRoomViewController+SudMGP.m
//  veRTC_Demo
//
//  Created by ByteDance on 2022/7/7.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import "GameRoomViewController+SudMGP.h"

@implementation GameRoomViewController (SudMGP)

- (void)initSudMGP {
    __weak __typeof(self) wself = self;
    [[GameSudMGPManager shareManager] requestSudMGPCode:NO resultCallback:^(NSString * _Nullable code) {
        if (!code) {
            [[ToastComponent shareToastComponent] showWithMessage:@"登陆小游戏失败" view:self.view];
            return;
        }
        
        [wself.iSudAPP destroyMG];
        wself.iSudAPP = nil;
        wself.iSudAPP = [SudMGP loadMG:[LocalUserComponent userModel].uid roomId:self.roomModel.room_id code:[GameSudMGPManager shareManager].sudMGPCode mgId:self.gameId language:@"zh-CN" fsmMG:self rootView:self.gameRootView];
    }];
}

#pragma mark ISudFSMMG Delegate
/**
 * 游戏日志
 */
-(void)onGameLog:(NSString*)dataJson {
    NSLog(@"ISudFSMMG:onGameLog:%@", dataJson);
    NSDictionary * dic = [GameUtils turnStringToDictionary:dataJson];
    [self handleRetCode:[dic objectForKey:@"errorCode"] errorMsg:[dic objectForKey:@"msg"]];
}

/**
 * 游戏加载进度(loadMG)
 * @param stage start=1,loading=2,end=3
 * @param retCode 错误码，0成功
 * @param progress [0, 100]
 */
-(void)onGameLoadingProgress:(int)stage retCode:(int)retCode progress:(int)progress {
    
}

/**
 * 游戏开始
 */
-(void)onGameStarted {
    NSLog(@"ISudFSMMG:onGameStarted:游戏开始");
}

/**
 * 游戏销毁
 */
-(void)onGameDestroyed {
    NSLog(@"ISudFSMMG:onGameDestroyed:游戏开始");
}

/**
 * Code过期
 * @param dataJson {"code":"value"}
 */
-(void)onExpireCode:(id<ISudFSMStateHandle>)handle dataJson:(NSString*)dataJson {
    NSLog(@"ISudFSMMG:onExpireCode:Code过期");
    // 请求业务服务器刷新令牌
    [[GameSudMGPManager shareManager] requestSudMGPCode:YES resultCallback:^(NSString * _Nullable code) {
        if (!code) {
            NSLog(@"ISudFSMMG:onExpireCode:获取code失败");
            return;
        }
        // 调用小游戏接口更新令牌
        [self updateGameCode:code];
    }];
    
    // 回调结果
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", @"success", @"ret_msg", nil];
    [handle success:[GameUtils dictionaryToJson:dict]];
}

/**
 * 更新code
 * @param code 新的code
 */
- (void)updateGameCode:(NSString *)code {
    [self.iSudAPP updateCode:code listener:^(int retCode, const NSString *retMsg, const NSString *dataJson) {
        NSLog(@"ISudFSMMG:updateGameCode retCode=%@ retMsg=%@ dataJson=%@", @(retCode), retMsg, dataJson);
    }];
}


/**
 * 获取游戏View信息
 * @param handle 回调句柄
 * @param dataJson {}
 */
-(void)onGetGameViewInfo:(id<ISudFSMStateHandle>)handle dataJson:(NSString*)dataJson {
    CGRect rect = self.gameRootView.frame;
    CGFloat scale = [[UIScreen mainScreen] nativeScale];

    CGFloat height = rect.size.height;
    CGFloat width = 1.0 / 1.4 * height;         //游戏区域宽高比建议1:1.4
    width = MIN(width, rect.size.width);

    CGFloat left = 0.5 * (rect.size.width - width) * scale;
    NSDictionary *rectDict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"top", @(left), @"left", @(0), @"bottom", @(left), @"right", nil];
    NSDictionary *viewDict = [NSDictionary dictionaryWithObjectsAndKeys:@(rect.size.width * scale), @"width", @(rect.size.height * scale), @"height", nil];
    NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", @"return form APP onGetGameViewInfo", @"ret_msg", viewDict, @"view_size", rectDict, @"view_game_rect", nil];
    /// 回调
    [handle success:[GameUtils dictionaryToJson:dataDict]];
}

/**
 * 获取游戏配置
 * @param handle 回调句柄
 * @param dataJson {}
 */
-(void)onGetGameCfg:(id<ISudFSMStateHandle>)handle dataJson:(NSString*)dataJson {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"ret_code"] = @(0);
    dict[@"ret_msg"] = @"return form APP onGetGameCfg";
    [handle success:[GameUtils dictionaryToJson:dict]];
}

/**
 * 游戏状态变化
 * @param handle 回调句柄
 * @param state 游戏状态
 * @param dataJson 回调json
 */
-(void)onGameStateChange:(id<ISudFSMStateHandle>) handle state:(NSString*) state dataJson:(NSString*) dataJson {
    if ([state isEqualToString:MG_COMMON_PUBLIC_MESSAGE]) {
        NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:公屏消息");

    } else if ([state isEqualToString:MG_COMMON_KEY_WORD_TO_HIT]) {
        NSDictionary *dic = [GameUtils turnStringToDictionary:dataJson];
        NSString *word = [dic objectForKey:@"word"];
        NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:你画我猜关键词获取:%@",word);
    } else if ([state isEqualToString:MG_COMMON_GAME_ASR]) {
        NSDictionary *dic = [GameUtils turnStringToDictionary:dataJson];
        if ([dic objectForKey:@"isOpen"]) {
            
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_MICROPHONE]) {   /// 游戏通知app麦克风状态, 在RTC场景下，app依此决定开启推流或者关闭推流
        /// 麦克风状态
        NSDictionary *dic = [GameUtils turnStringToDictionary:dataJson];
        if ([dic objectForKey:@"isOn"]) {
            BOOL isOn = [[dic objectForKey:@"isOn"] boolValue];
            if (isOn) {
                // APP开启RTC推流
                // 在开启推流前，应检查App是否具备麦克风权限或者麦克风是否被占用，如果App不能获得麦克风，可提示用户
            } else {
                // APP关闭RTC推流
            }
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_HEADPHONE]) {    /// 游戏通知app耳机（听筒，喇叭）状态， 在RTC场景下，app依此决定开启拉流或者关闭拉流
        /// 耳机（听筒，扬声器）状态
        NSDictionary *dic = [GameUtils turnStringToDictionary:dataJson];
        if ([dic objectForKey:@"isOn"]) {
            BOOL isOn = [[dic objectForKey:@"isOn"] boolValue];
            if (isOn) {
                // APP开启RTC拉流
            } else {
                // APP关闭RTC拉流
            }
        }
    } else {
        /// 其他状态
        NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:state:%@",state);
    }
}

/**
 * 游戏玩家状态变化
 * @param handle 回调句柄
 * @param userId 用户id
 * @param state  玩家状态
 * @param dataJson 回调JSON
 */
-(void)onPlayerStateChange:(nullable id<ISudFSMStateHandle>) handle userId:(NSString*) userId state:(NSString*) state dataJson:(NSString*) dataJson {
    NSLog(@"ISudFSMMG:onPlayerStateChange:游戏->APP:游戏玩家状态变化:userId: %@ --state: %@ --dataJson: %@", userId, state, dataJson);
    /// 状态解析
    NSString *dataStr = @"";
    if ([state isEqualToString:MG_COMMON_PLAYER_IN]) {
        dataStr = @"玩家: 加入状态";
        [self handleState_MG_COMMON_PLAYER_IN_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_COMMON_PLAYER_READY]) {
        dataStr = @"玩家: 准备状态";
        [self handleState_MG_COMMON_PLAYER_READY_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_COMMON_PLAYER_CAPTAIN]) {
        dataStr = @"玩家: 队长状态";
        [self handleState_MG_COMMON_PLAYER_CAPTAIN_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_COMMON_PLAYER_PLAYING]) {
        dataStr = @"玩家: 游戏状态";
        [self handleState_MG_COMMON_PLAYER_PLAYING_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_DG_SELECTING]) {
        dataStr = @"你画我猜 玩家: 选词中";
        [self handleState_MG_DG_SELECTING_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_DG_PAINTING]) {
        dataStr = @"你画我猜 玩家: 作画中";
        [self handleState_MG_DG_PAINTING_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_DG_ERRORANSWER]) {
        dataStr = @"你画我猜 玩家: 错误答";
        [self handleState_MG_DG_ERRORANSWER_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_DG_TOTALSCORE]) {
        dataStr = @"你画我猜 玩家: 总积分";
        [self handleState_MG_DG_TOTALSCORE_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_DG_SCORE]) {
        dataStr = @"你画我猜 玩家: 本次积分";
        [self handleState_MG_DG_SCORE_WithUserId:userId dataJson:dataJson];
    }else {
        NSLog(@"ISudFSMMG:onPlayerStateChange:未做解析状态:%@", MG_DG_SCORE);
    }
    NSLog(@"ISudFSMMG:onPlayerStateChange:dataStr:%@", dataStr);
    /// 回调
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", @"return form APP onPlayerStateChange", @"ret_msg", nil];
    [handle success:[GameUtils dictionaryToJson:dict]];
}

#pragma mark - 游戏->APP状态处理
- (void)handleState_MG_COMMON_PLAYER_IN_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    
    NSDictionary * dic = [GameUtils turnStringToDictionary:dataJson];
    /// 加入状态：YES加入，NO退出
    BOOL isIn = NO;
    if (dic) {
        NSInteger retCode = [[dic objectForKey:@"retCode"] integerValue];
        if (retCode != 0) {
            [self handleRetCode:[NSString stringWithFormat:@"%ld",(long)retCode] errorMsg:MG_COMMON_PLAYER_IN];
            return;
        }
        isIn = [[dic objectForKey:@"isIn"] boolValue];
    }
    if (isIn) {
    }else {
    }
}

- (void)handleState_MG_COMMON_PLAYER_READY_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 玩家是否准备,YES:已准备，NO:未准备
    BOOL isReady = NO;
    NSDictionary * dic = [GameUtils turnStringToDictionary:dataJson];
    if (dic) {
        NSInteger retCode = [[dic objectForKey:@"retCode"] integerValue];
        if (retCode != 0) {
            [self handleRetCode:[NSString stringWithFormat:@"%ld",(long)retCode] errorMsg:MG_COMMON_PLAYER_READY];
            return;
        }
        isReady = [[dic objectForKey:@"isReady"] boolValue];
    }
    if (isReady) {
    }else {
    }
}

- (void)handleState_MG_COMMON_PLAYER_CAPTAIN_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 是否是队长：YES：是队长 NO：不是队长
    BOOL isCaptain = NO;
    NSDictionary * dic = [GameUtils turnStringToDictionary:dataJson];
    if (dic) {
        /// 错误处理
        NSInteger retCode = [[dic objectForKey:@"retCode"] integerValue];
        if (retCode != 0) {
            [self handleRetCode:[NSString stringWithFormat:@"%ld",(long)retCode] errorMsg:MG_COMMON_PLAYER_CAPTAIN];
            return;
        }
        
        isCaptain = [[dic objectForKey:@"isCaptain"] boolValue];
    }
    
}

- (void)handleState_MG_COMMON_PLAYER_PLAYING_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 是否正在游戏中
    BOOL isPlaying = NO;
    NSDictionary * dic = [GameUtils turnStringToDictionary:dataJson];
    if (dic) {
        /// 错误处理
        NSInteger retCode = [[dic objectForKey:@"retCode"] integerValue];
        if (retCode != 0) {
            [self handleRetCode:[NSString stringWithFormat:@"%ld",(long)retCode] errorMsg:MG_COMMON_PLAYER_PLAYING];
            return;
        }
        
        isPlaying = [[dic objectForKey:@"isPlaying"] boolValue];
    }
    if (isPlaying) {
    }else {
    }
}

- (void)handleState_MG_DG_SELECTING_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 设置麦位状态为选词中
}

- (void)handleState_MG_DG_PAINTING_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 设置麦位状态为作画中
    NSDictionary * dic = [GameUtils turnStringToDictionary:dataJson];
    bool isPainting = NO;
    if (dic) {
        isPainting = [dic[@"isPainting"] boolValue];
    }
    if (isPainting) {
    }else {
    }
}

- (void)handleState_MG_DG_ERRORANSWER_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 错误答案
}

- (void)handleState_MG_DG_TOTALSCORE_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 总积分
}

- (void)handleState_MG_DG_SCORE_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 本次积分
}

- (void)handleRetCode:(NSString *)retCode errorMsg:(NSString *)msg {
    
}


#pragma mark - APP->游戏状态处理
/// 状态通知（app to mg）
/// @param state 状态名称
/// @param dataJson 需传递的json
- (void)notifyStateChange:(NSString *) state dataJson:(NSString*) dataJson {
    [self.iSudAPP notifyStateChange:state dataJson:dataJson listener:^(int retCode, const NSString *retMsg, const NSString *dataJson) {
        NSLog(@"ISudFSMMG:notifyStateChange:retCode=%@ retMsg=%@ dataJson=%@", @(retCode), retMsg, dataJson);
    }];
}

/// 加入,退出游戏
/// @param isIn YES:加入 NO:退出 seatIndex:座位号
- (void)notifySelfInState:(BOOL)isIn seatIndex:(int)seatIndex {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(seatIndex), @"seatIndex", @(isIn), @"isIn",@(YES), @"isSeatRandom", @(1), @"teamId", nil];
    [self notifyStateChange:APP_COMMON_SELF_IN dataJson:[GameUtils dictionaryToJson:dic]];
}

/// 踢出用户
/// @param userId 踢出用户id
- (void)notifyKickStateWithUserId:(NSString *)userId {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"kickedUID", nil];
    [self notifyStateChange:APP_COMMON_SELF_KICK dataJson:[GameUtils dictionaryToJson:dic]];
}

/// 设置用户为队长
/// @param userId 被设置用户id
- (void)notifySetCaptainStateWithUserId:(NSString *)userId {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"curCaptainUID", nil];
    [self notifyStateChange:APP_COMMON_SELF_CAPTAIN dataJson:[GameUtils dictionaryToJson:dic]];
}

/// 是否设置为准备状态
- (void)notifySetReady:(BOOL)isReady {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isReady), @"isReady", nil];
    [self notifyStateChange:APP_COMMON_SELF_READY dataJson:[GameUtils dictionaryToJson:dic]];
}

/// 停止游戏状态设置
- (void)notifySetEnd {
    [self notifyStateChange:APP_COMMON_SELF_END dataJson:[GameUtils dictionaryToJson:@{}]];
}

/// 游戏中状态设置
- (void)notifyIsPlayingState:(BOOL)isPlaying {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isPlaying), @"isPlaying", nil];
    [self notifyStateChange:APP_COMMON_SELF_PLAYING dataJson:[GameUtils dictionaryToJson:dic]];
}

@end
