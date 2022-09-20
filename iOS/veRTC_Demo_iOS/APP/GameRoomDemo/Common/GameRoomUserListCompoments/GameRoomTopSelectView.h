//
//  GameRoomTopSelectView.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/24.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameRoomTopSelectView;

NS_ASSUME_NONNULL_BEGIN

@protocol GameRoomTopSelectViewDelegate <NSObject>

- (void)gameRoomTopSelectView:(GameRoomTopSelectView *)gameRoomTopSelectView clickCancelAction:(id)model;

- (void)gameRoomTopSelectView:(GameRoomTopSelectView *)gameRoomTopSelectView clickSwitchItem:(BOOL)isAudience;

@end

@interface GameRoomTopSelectView : UIView

@property (nonatomic, weak) id<GameRoomTopSelectViewDelegate> delegate;

@property (nonatomic, copy) NSString *titleStr;

@end

NS_ASSUME_NONNULL_END
