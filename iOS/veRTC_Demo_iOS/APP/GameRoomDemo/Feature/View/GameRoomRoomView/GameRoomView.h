//
//  GameRoomView.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/21.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRTSManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameRoomView : UIView

- (void)joinUser:(GameControlUserModel *)user;

- (void)leaveUser:(NSString *)user;

- (void)audienceRaisedHandsSuccess:(GameControlUserModel *)uid;

- (void)hostLowerHandSuccess:(NSString *)uid;

- (void)updateAllUser:(NSArray<GameControlUserModel *> *)userLists roomModel:(GameControlRoomModel *)roomModel;

- (void)updateUserMic:(NSString *)uid isMute:(BOOL)isMute;

- (void)updateUserHand:(NSString *)uid isHand:(BOOL)isHand;

- (void)updateHostUser:(NSString *)uid;

- (void)updateHostVolume:(NSDictionary<NSString *, NSNumber *> *_Nonnull)volumeInfo;

- (void)reloadData;

- (NSInteger)hostNumber;

- (NSArray<GameControlUserModel *> *)allUserLists;

@end

NS_ASSUME_NONNULL_END
