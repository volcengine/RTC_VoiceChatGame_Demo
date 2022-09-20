//
//  GameEndComponents.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/19.
//  Copyright © 2021 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameRoomEndView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameEndComponents : NSObject

@property (nonatomic, copy) void (^clickButtonBlock)(GameButtonStatus status);

- (void)showWithStatus:(GameEndStatus)status;

@end

NS_ASSUME_NONNULL_END
