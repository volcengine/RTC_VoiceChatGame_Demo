//
//  GameRoomUserListComponents.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/19.
//  Copyright © 2021 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameRoomAudienceListsView.h"
#import "GameRoomRaiseHandListsView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameRoomUserListComponents : NSObject

- (void)show:(void (^)(void))dismissBlock;

- (void)update;

@end

NS_ASSUME_NONNULL_END
