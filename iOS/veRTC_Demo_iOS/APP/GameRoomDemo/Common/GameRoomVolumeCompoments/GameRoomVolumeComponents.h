//
//  GameRoomVolumeComponents.h
//  GameRoomDemo
//
//  Created by ByteDance on 2022/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameRoomVolumeComponents : NSObject

@property (nonatomic, copy) void (^onRoomVolumeChange)(NSInteger value);

@property (nonatomic, copy) void (^onGameVolumeChange)(NSInteger value);

- (void)show;

@end

NS_ASSUME_NONNULL_END
