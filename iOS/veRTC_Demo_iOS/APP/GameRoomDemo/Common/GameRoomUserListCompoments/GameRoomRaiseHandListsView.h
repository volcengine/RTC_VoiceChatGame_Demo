//
//  GameRoomRaiseHandListsView.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/19.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRoomUserListCell.h"
@class GameRoomRaiseHandListsView;

NS_ASSUME_NONNULL_BEGIN

@protocol GameRoomRaiseHandListsViewDelegate <NSObject>

- (void)gameRoomRaiseHandListsView:(GameRoomRaiseHandListsView *)gameRoomRaiseHandListsView clickButton:(GameControlUserModel *)model;

@end

@interface GameRoomRaiseHandListsView : UIView

@property (nonatomic, copy) NSArray<GameControlUserModel *> *dataLists;

@property (nonatomic, weak) id<GameRoomRaiseHandListsViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
