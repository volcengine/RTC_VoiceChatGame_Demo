//
//  GameRoomTextFieldView.h
//  quickstart
//
//  Created by bytedance on 2021/3/23.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRTSManager.h"

@class GameRoomNavView;

typedef NS_ENUM(NSInteger, RoomNavStatus) {
    RoomNavStatusHangeup
};

NS_ASSUME_NONNULL_BEGIN

@protocol GameRoomNavViewDelegate <NSObject>

- (void)gameRoomNavView:(GameRoomNavView *)gameRoomNavView didSelectStatus:(RoomNavStatus)status;

@end

@interface GameRoomNavView : UIView

@property (nonatomic, strong) GameControlRoomModel *roomModel;

@property (nonatomic, weak) id<GameRoomNavViewDelegate> delegate;

@property (nonatomic, assign) NSInteger meetingTime;

- (void)updateUserCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
