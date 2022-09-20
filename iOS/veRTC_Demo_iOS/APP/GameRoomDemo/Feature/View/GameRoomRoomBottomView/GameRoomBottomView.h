//
//  GameRoomBottomView.h
//  quickstart
//
//  Created by bytedance on 2021/3/23.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRoomItemButton.h"
@class GameRoomBottomView;

typedef NS_ENUM(NSInteger, GameRoomBottomStatus) {
    GameRoomBottomStatusList = 0,
    GameRoomBottomStatusMic,
    GameRoomBottomStatusVolume,
    GameRoomBottomStatusData,
    GameRoomBottomStatusRaiseHand,
    GameRoomBottomStatusListRed,
    GameRoomBottomStatusDownHand,
};

@protocol GameRoomBottomViewDelegate <NSObject>

- (void)gameRoomBottomView:(GameRoomBottomView *_Nonnull)gameRoomBottomView itemButton:(GameRoomItemButton *_Nullable)itemButton didSelectStatus:(GameRoomBottomStatus)status;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GameRoomBottomView : UIView

@property (nonatomic, weak) id<GameRoomBottomViewDelegate> delegate;

- (void)updateButtonStatus:(GameRoomBottomStatus)status close:(BOOL)isClose;

- (void)updateButtonStatus:(GameRoomBottomStatus)status close:(BOOL)isClose isTitle:(BOOL)isTitle;

- (void)replaceButtonStatus:(GameRoomBottomStatus)status newStatus:(GameRoomBottomStatus)newStatus;

- (ButtonStatus)getButtonStatus:(GameRoomBottomStatus)status;

- (void)updateBottomLists:(NSArray<NSNumber *> *)status;

@end

NS_ASSUME_NONNULL_END
