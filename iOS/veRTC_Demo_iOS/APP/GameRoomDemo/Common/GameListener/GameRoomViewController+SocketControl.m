//
//  GameRoomViewController+SocketControl.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/28.
//  Copyright © 2021 . All rights reserved.
//

#import "GameRoomViewController+SocketControl.h"
#import "GameRTSManager.h"

@implementation GameRoomViewController (SocketControl)

- (void)addSocketListener {
    __weak __typeof(self) wself = self;
    [GameRTSManager onJoinGameroomWithBlock:^(GameControlUserModel * _Nonnull userModel) {
        if (wself) {
            [wself addUser:userModel];
        }
    }];
    
    [GameRTSManager onLeaveGameroomWithBlock:^(GameControlUserModel * _Nonnull userModel) {
        if (wself) {
            [wself removeUser:userModel];
        }
    }];

    [GameRTSManager onRaiseHandsMicWithBlock:^(NSString * _Nonnull uid) {
        if (wself) {
            //Received notification of raising hands
            [wself receivedRaiseHandWithUser:uid];
        }
    }];
    
    [GameRTSManager onInviteMicWithBlock:^(NSString * _Nonnull uid) {
        if (wself) {
            //The audience receives the invitation to the microphone notification
            [wself receivedRaiseHandInviteWithAudience];
        }
    }];
    
    [GameRTSManager onMicOnWithBlock:^(GameControlUserModel * _Nonnull userModel) {
        if (wself) {
            //Notification of successful user registration
            [wself receivedRaiseHandSucceedWithUser:userModel];
        }
    }];
    
    [GameRTSManager onMicOffWithBlock:^(NSString * _Nonnull uid) {
        if (wself) {
            //Notification of successful user downloading
            [wself receivedLowerHandSucceedWithUser:uid];
        }
    }];
    
    [GameRTSManager onMuteMicWithBlock:^(NSString * _Nonnull uid) {
        if (wself) {
            [wself receivedMicChangeWithMute:YES uid:uid];
        }
    }];
    
    [GameRTSManager onUnmuteMic:^(NSString * _Nonnull uid) {
        if (wself) {
            [wself receivedMicChangeWithMute:NO uid:uid];
        }
    }];
    
    [GameRTSManager onHostChange:^(NSString * _Nonnull formerHostID, GameControlUserModel *hostUser) {
        if (wself) {
            [wself receivedHostChangeWithNewHostUid:hostUser];
        }
    }];

    [GameRTSManager onGameroomEnd:^(BOOL result, NSInteger type) {
        if (wself && result) {
            [wself receivedGameroomEnd:type];
        }
    }];
}
@end
