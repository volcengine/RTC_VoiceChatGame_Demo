//
//  GameRoomEndView.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/18.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//UI
typedef NS_ENUM(NSInteger, GameButtonColorType) {
    GameButtonColorTypeNone,
    GameButtonColorTypeRemind,
};

//form
typedef NS_ENUM(NSInteger, GameEndStatus) {
    GameEndStatusAudience,
    GameEndStatusHost,
    GameEndStatusHostOnly,
};

//button status
typedef NS_ENUM(NSInteger, GameButtonStatus) {
    GameButtonStatusEnd,
    GameButtonStatusLeave,
    GameButtonStatusCancel,
};

@interface GameRoomEndView : UIView

@property (nonatomic, copy) void (^clickButtonBlock)(GameButtonStatus status);

@property (nonatomic, assign) GameEndStatus gameEndStatus;

@end

NS_ASSUME_NONNULL_END
