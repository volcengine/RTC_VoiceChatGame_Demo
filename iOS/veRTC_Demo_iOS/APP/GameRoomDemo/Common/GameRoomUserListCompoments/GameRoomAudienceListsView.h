//
//  GameRoomAudienceListsView.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/18.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRoomUserListCell.h"
@class GameRoomAudienceListsView;

NS_ASSUME_NONNULL_BEGIN

@protocol GameRoomAudienceListsViewDelegate <NSObject>

- (void)gameRoomAudienceListsView:(GameRoomAudienceListsView *)gameRoomAudienceListsView clickButton:(GameControlUserModel *)model;

@end


@interface GameRoomAudienceListsView : UIView

@property (nonatomic, copy) NSArray<GameControlUserModel *> *dataLists;

@property (nonatomic, weak) id<GameRoomAudienceListsViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
