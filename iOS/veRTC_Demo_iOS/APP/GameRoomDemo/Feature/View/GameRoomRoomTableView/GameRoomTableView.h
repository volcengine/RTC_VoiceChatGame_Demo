//
//  GameRoomTableView.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/18.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRoomCell.h"
@class GameRoomTableView;

NS_ASSUME_NONNULL_BEGIN

@protocol GameRoomTableViewDelegate <NSObject>

- (void)gameRoomTableView:(GameRoomTableView *)gameRoomTableView didSelectRowAtIndexPath:(GameControlRoomModel *)model;

@end

@interface GameRoomTableView : UIView

@property (nonatomic, copy) NSArray *dataLists;

@property (nonatomic, weak) id<GameRoomTableViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
