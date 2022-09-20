//
//  GameRoomViewController.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/18.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRTSManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameRoomViewController : UIViewController

@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) GameControlRoomModel *roomModel;
@property (nonatomic, copy) NSArray<GameControlUserModel *> *userLists;

@property (nonatomic, strong) NSString *roomID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) int64_t   gameId;

/*
 * 加入用户
 */
- (void)addUser:(GameControlUserModel *)userModel;

/*
 * 退出用户
 */
- (void)removeUser:(GameControlUserModel *)userModel;

/*
 * 有观众举手
 */
- (void)receivedRaiseHandWithUser:(NSString *)uid;

/*
 * 观众收到上麦邀请
 */
- (void)receivedRaiseHandInviteWithAudience;

/*
 * 观众收到上麦邀请
 */
- (void)receivedRaiseHandSucceedWithUser:(GameControlUserModel *)userModel;

/*
 * 观众收到下麦通知
 */
- (void)receivedLowerHandSucceedWithUser:(NSString *)uid;

/*
 * 麦上嘉宾开闭麦状态变化
 */
- (void)receivedMicChangeWithMute:(BOOL)isMute uid:(NSString *)uid;


/*
 * 主持换人
 */
- (void)receivedHostChangeWithNewHostUid:(GameControlUserModel *)hostUser;

/*
 * 房间结束
 */
- (void)receivedGameroomEnd:(NSInteger)type ;

@end

NS_ASSUME_NONNULL_END
