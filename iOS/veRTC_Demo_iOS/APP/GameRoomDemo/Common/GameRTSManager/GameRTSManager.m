//
//  GameRTMManager.m
//  GameRoomDemo
//
//  Created by ByteDance on 2022/8/5.
//

#import "GameRTSManager.h"
#import "GameRTCManager.h"
#import "JoinRTSParams.h"

@implementation GameRTSManager

+ (void)getGameroomListWithBlock:(void (^ __nullable)(NSArray *lists,
                                                  RTMACKModel *model))block {
    NSDictionary *dic = [JoinRTSParams addTokenToParams:nil];
    [[GameRTCManager shareRtc] emitWithAck:@"grGetMeetings"
                                       with:dic
                                      block:^(RTMACKModel * _Nonnull ackModel) {
        NSMutableArray *modelLsts = [[NSMutableArray alloc] init];
        if ([ackModel.response isKindOfClass:[NSDictionary class]]) {
            NSArray *infos = ackModel.response[@"infos"];
            for (int i = 0; i < infos.count; i++) {
                GameControlRoomModel *roomMdoel = [GameControlRoomModel yy_modelWithJSON:infos[i]];
                [modelLsts addObject:roomMdoel];
            }
        }
        if (block) {
            block([modelLsts copy], ackModel);
        }
    }];
}

+ (void)createGameroom:(NSString *)roomName
             userName:(NSString *)userName
               gameId:(NSString *)gid
                block:(void (^ __nullable)(NSString *token,
                                           GameControlRoomModel *roomModel,
                                           NSArray<GameControlUserModel *> *lists,
                                           BOOL isSensitiveWords,
                                           RTMACKModel *model))block {
    NSString *encodedString = [roomName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];
    NSDictionary *dic = @{@"room_name" : encodedString,
                          @"user_name" : userName,
                          @"gid" : gid
    };
    dic = [JoinRTSParams addTokenToParams:dic];
    
    [[GameRTCManager shareRtc] emitWithAck:@"grCreateMeeting"
                                       with:dic
                                      block:^(RTMACKModel * _Nonnull ackModel) {
        NSString *token = @"";
        GameControlRoomModel *roomModel = nil;
        NSMutableArray *modelLsts = [[NSMutableArray alloc] init];
        if ([ackModel.response isKindOfClass:[NSDictionary class]]) {
            token = ackModel.response[@"token"];
            roomModel = [GameControlRoomModel yy_modelWithJSON:ackModel.response[@"info"]];
            NSArray *infos = ackModel.response[@"users"];
            for (int i = 0; i < infos.count; i++) {
                GameControlUserModel *model = [GameControlUserModel yy_modelWithJSON:infos[i]];
                [modelLsts addObject:model];
            }
        }
        if (block) {
            block(token, roomModel, [modelLsts copy], ackModel.code == 430, ackModel);
        }
    }];
}

+ (void)joinGameroom:(NSString *)roomID
         userName:(NSString *)userName
            block:(void (^ __nullable)(NSString *token,
                            GameControlRoomModel *roomModel,
                            NSArray<GameControlUserModel *> *lists,
                            RTMACKModel *model))block {
    NSDictionary *dic = @{};
    if (NOEmptyStr(roomID) && NOEmptyStr(userName)) {
        dic = @{@"room_id" : roomID,
                @"user_name" : userName};
    }
    dic = [JoinRTSParams addTokenToParams:dic];
    
    [[GameRTCManager shareRtc] emitWithAck:@"grJoinMeeting"
                                       with:dic
                                      block:^(RTMACKModel * _Nonnull ackModel) {
        NSString *token = @"";
        GameControlRoomModel *roomModel = nil;
        NSMutableArray *modelLsts = [[NSMutableArray alloc] init];
        if ([ackModel.response isKindOfClass:[NSDictionary class]]) {
            token = ackModel.response[@"token"];
            roomModel = [GameControlRoomModel yy_modelWithJSON:ackModel.response[@"info"]];
            NSArray *infos = ackModel.response[@"users"];
            for (int i = 0; i < infos.count; i++) {
                GameControlUserModel *model = [GameControlUserModel yy_modelWithJSON:infos[i]];
                if (model) {
                    [modelLsts addObject:model];
                }
            }
        }
        if (block) {
            block(token, roomModel, [modelLsts copy], ackModel);
        }
    }];

}

+ (void)leaveGameroom:(void (^)(RTMACKModel * _Nonnull))block {
    NSDictionary *dic = [JoinRTSParams addTokenToParams:nil];
    [[GameRTCManager shareRtc] emitWithAck:@"grLeaveMeeting" with:dic block:block];
}

+ (void)getRaiseHandsWithBlock:(void (^ __nullable)(NSArray<GameControlUserModel *> *userLists, RTMACKModel *model))block {
    NSDictionary *dic = [JoinRTSParams addTokenToParams:nil];
    [[GameRTCManager shareRtc] emitWithAck:@"grGetRaiseHands"
                                       with:dic
                                      block:^(RTMACKModel * _Nonnull ackModel) {
        NSMutableArray *modelLsts = [[NSMutableArray alloc] init];
        NSArray *data = (NSArray *)ackModel.response[@"users"];
        if (data && [data isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < data.count; i++) {
                GameControlUserModel *userModel = [GameControlUserModel yy_modelWithJSON:data[i]];
                [modelLsts addObject:userModel];
            }
        }
        if (block) {
            block([modelLsts copy], ackModel);
        }
    }];
}

+ (void)getAudiencesWithBlock:(void (^ __nullable)(NSArray<GameControlUserModel *> *userLists, RTMACKModel *model))block {
    NSDictionary *dic = [JoinRTSParams addTokenToParams:nil];
    [[GameRTCManager shareRtc] emitWithAck:@"grGetAudiences"
                                       with:dic
                                      block:^(RTMACKModel * _Nonnull ackModel) {
        NSMutableArray *modelLsts = [[NSMutableArray alloc] init];
        NSArray *data = (NSArray *)ackModel.response[@"users"];
        if (data && [data isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < data.count; i++) {
                GameControlUserModel *userModel = [GameControlUserModel yy_modelWithJSON:data[i]];
                [modelLsts addObject:userModel];
            }
        }
        if (block) {
            block([modelLsts copy], ackModel);
        }
    }];
}

+ (void)reconnectWithBlock:(void (^)(GameControlRoomModel *, NSArray *users, RTMACKModel * _Nonnull))block {
    NSDictionary *dic = [JoinRTSParams addTokenToParams:nil];
    
    [[GameRTCManager shareRtc] emitWithAck:@"grReconnect" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        GameControlRoomModel *roomModel = nil;
        NSMutableArray *userLists = [[NSMutableArray alloc] init];
        if ([ackModel.response isKindOfClass:[NSDictionary class]]) {
            roomModel = [GameControlRoomModel yy_modelWithJSON:ackModel.response[@"info"]];
            NSArray *infos = ackModel.response[@"users"];
            for (int i = 0; i < infos.count; i++) {
                GameControlUserModel *model = [GameControlUserModel yy_modelWithJSON:infos[i]];
                if (model) {
                    [userLists addObject:model];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(roomModel, [userLists copy], ackModel);
            }
        });
    }];
}

#pragma mark - Control Voice status

+ (void)inviteMic:(NSString *)userId block:(void (^ __nullable)(RTMACKModel *model))block {
    NSDictionary *dic = [JoinRTSParams addTokenToParams:nil];
    NSMutableDictionary *mutableDic = [dic mutableCopy];
    [mutableDic setValue:userId ?: @"" forKey:@"user_id"];
    dic = [mutableDic copy];
    [[GameRTCManager shareRtc] emitWithAck:@"grInviteMic"
                                       with:dic
                                      block:block];
}

+ (void)confirmMicWithBlock:(void (^ __nullable)(RTMACKModel *model))block {
    NSDictionary *dic = [JoinRTSParams addTokenToParams:nil];
    [[GameRTCManager shareRtc] emitWithAck:@"grConfirmMic"
                                       with:dic
                                      block:block];
}

+ (void)raiseHandsMicWithBlock:(void (^ __nullable)(RTMACKModel *model))block {
    NSDictionary *dic = [JoinRTSParams addTokenToParams:nil];
    [[GameRTCManager shareRtc] emitWithAck:@"grRaiseHandsMic"
                                       with:dic
                                      block:block];
}

+ (void)agreeMic:(NSString *)userId block:(void (^ __nullable)(RTMACKModel *model))block {
    NSDictionary *dic = [JoinRTSParams addTokenToParams:nil];
    NSMutableDictionary *mutableDic = [dic mutableCopy];
    [mutableDic setValue:userId ?: @"" forKey:@"user_id"];
    dic = [mutableDic copy];
    [[GameRTCManager shareRtc] emitWithAck:@"grAgreeMic"
                                       with:dic
                                      block:block];
}

+ (void)offSelfMicWithBlock:(void (^ __nullable)(RTMACKModel *model))block {
    NSDictionary *dic = [JoinRTSParams addTokenToParams:nil];
    [[GameRTCManager shareRtc] emitWithAck:@"grOffSelfMic"
                                       with:dic
                                      block:block];
}

+ (void)offMic:(NSString *)userId block:(void (^ __nullable)(RTMACKModel *model))block {
    NSDictionary *dic = [JoinRTSParams addTokenToParams:nil];
    NSMutableDictionary *mutableDic = [dic mutableCopy];
    [mutableDic setValue:userId ?: @"" forKey:@"user_id"];
    dic = [mutableDic copy];
    [[GameRTCManager shareRtc] emitWithAck:@"grOffMic"
                                       with:dic
                                      block:block];
}
                                                                      
+ (void)muteMic {
    NSDictionary *dic = [JoinRTSParams addTokenToParams:nil];
    [[GameRTCManager shareRtc] emitWithAck:@"grMuteMic" with:dic block:nil];
}

+ (void)unmuteMic {
    NSDictionary *dic = [JoinRTSParams addTokenToParams:nil];
    [[GameRTCManager shareRtc] emitWithAck:@"grUnmuteMic" with:dic block:nil];
}

+ (void)getGameListWithBlock:(void (^ __nullable)(NSArray <GameInfoModel *>*))block {
    NSDictionary *dic = [JoinRTSParams addTokenToParams:nil];
    [[GameRTCManager shareRtc] emitWithAck:@"grGetGameList" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        NSMutableArray *gameLists = [[NSMutableArray alloc] init];

        if ([ackModel.response isKindOfClass:[NSDictionary class]]) {
            NSArray *mgInfoLists = (NSArray *)ackModel.response[@"mg_info_list"];
            if (mgInfoLists && [mgInfoLists isKindOfClass:[NSArray class]]) {
                for (int i = 0; i < mgInfoLists.count; i++) {
                    GameInfoModel *infoModel = [GameInfoModel yy_modelWithJSON:mgInfoLists[i]];
                    [gameLists addObject:infoModel];
                }
            }
        }
        
        if (block) {
            block(gameLists);
        }
    }];
}

#pragma mark - Notification message

+ (void)onJoinGameroomWithBlock:(void (^)(GameControlUserModel *userModel))block {
    [[GameRTCManager shareRtc] onSceneListener:@"onGrJoinMeeting"
                                          block:^(RTMNoticeModel * _Nonnull noticeModel) {
        GameControlUserModel *model = nil;
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            model = [GameControlUserModel yy_modelWithJSON:noticeModel.data];
        }
        if (block) {
            block(model);
        }
    }];
}

+ (void)onLeaveGameroomWithBlock:(void (^)(GameControlUserModel *userModel))block {
    [[GameRTCManager shareRtc] onSceneListener:@"onGrLeaveMeeting"
                                          block:^(RTMNoticeModel * _Nonnull noticeModel) {
        GameControlUserModel *model = nil;
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            model = [GameControlUserModel yy_modelWithJSON:noticeModel.data];
        }
        if (block) {
            block(model);
        }
    }];
}

+ (void)onRaiseHandsMicWithBlock:(void (^)(NSString *uid))block {
    [[GameRTCManager shareRtc] onSceneListener:@"onGrRaiseHandsMic"
                                              block:^(RTMNoticeModel * _Nonnull noticeModel) {
        NSString *uid = @"";
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            uid = noticeModel.data[@"user_id"];
        }
        if (block) {
            block(uid);
        }
    }];
}

+ (void)onInviteMicWithBlock:(void (^)(NSString *uid))block {
    [[GameRTCManager shareRtc] onSceneListener:@"onGrInviteMic"
                                          block:^(RTMNoticeModel * _Nonnull noticeModel) {
        NSString *uid = @"";
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            uid = noticeModel.data[@"user_id"];
        }
        if (block) {
            block(uid);
        }
    }];
}

+ (void)onMicOnWithBlock:(void (^)(GameControlUserModel *userModel))block {
    [[GameRTCManager shareRtc] onSceneListener:@"onGrMicOn"
                                          block:^(RTMNoticeModel * _Nonnull noticeModel) {
        GameControlUserModel *model = nil;
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            model = [GameControlUserModel yy_modelWithJSON:noticeModel.data];
        }
        if (block) {
            block(model);
        }
    }];
}

+ (void)onMicOffWithBlock:(void (^)(NSString *uid))block {
    [[GameRTCManager shareRtc] onSceneListener:@"onGrMicOff"
                                          block:^(RTMNoticeModel * _Nonnull noticeModel) {
        NSString *uid = @"";
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            uid = noticeModel.data[@"user_id"];
        }
        if (block) {
            block(uid);
        }
    }];
}

+ (void)onMuteMicWithBlock:(void (^)(NSString *uid))block {
    [[GameRTCManager shareRtc] onSceneListener:@"onGrMuteMic"
                                          block:^(RTMNoticeModel * _Nonnull noticeModel) {
        NSString *uid = @"";
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            uid = noticeModel.data[@"user_id"];
        }
        if (block) {
            block(uid);
        }
    }];
}

+ (void)onUnmuteMic:(void (^)(NSString * _Nonnull uid))block {
    [[GameRTCManager shareRtc] onSceneListener:@"onGrUnmuteMic"
                                          block:^(RTMNoticeModel * _Nonnull noticeModel) {
        NSString *uid = @"";
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            uid = noticeModel.data[@"user_id"];
        }
        if (block) {
            block(uid);
        }
    }];
}

+ (void)onGameroomEnd:(void (^)(BOOL result, NSInteger type))block {
    [[GameRTCManager shareRtc] onSceneListener:@"onGrMeetingEnd"
                                          block:^(RTMNoticeModel * _Nonnull noticeModel) {
        NSString *roomID = @"";
        NSInteger type = 0;
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            roomID = noticeModel.data[@"room_id"];
            type = ((NSNumber *)noticeModel.data[@"type"]).integerValue;
        }
        if (block) {
            block([roomID isEqualToString:[PublicParameterComponent share].roomId], type);
        }
    }];
}

+ (void)onHostChange:(void (^)(NSString *formerHostID, GameControlUserModel *hostUser))block {
    [[GameRTCManager shareRtc] onSceneListener:@"onGrHostChange"
                                          block:^(RTMNoticeModel * _Nonnull noticeModel) {
        NSString *forUid = @"";
        GameControlUserModel *model = nil;
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            forUid = noticeModel.data[@"former_host_id"];
            model = [GameControlUserModel yy_modelWithJSON:noticeModel.data[@"host_info"]];
        }
        if (block) {
            block(forUid, model);
        }
    }];
}


@end
