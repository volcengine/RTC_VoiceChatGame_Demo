//
//  GameRoomParamComponents.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/24.
//  Copyright © 2021 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameRoomParamInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameRoomParamComponents : NSObject

- (void)show;

- (void)updateModel:(GameRoomParamInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
