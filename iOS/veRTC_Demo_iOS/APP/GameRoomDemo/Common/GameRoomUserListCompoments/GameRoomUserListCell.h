//
//  GameRoomUserListtCell.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/19.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameControlUserModel.h"
@class GameRoomUserListCell;

NS_ASSUME_NONNULL_BEGIN

@protocol GameRoomUserListtCellDelegate <NSObject>

- (void)gameRoomUserListCell:(GameRoomUserListCell *)gameRoomUserListtCell clickButton:(id)model;

@end

@interface GameRoomUserListCell : UITableViewCell

@property (nonatomic, strong) GameControlUserModel *model;

@property (nonatomic, weak) id<GameRoomUserListtCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
