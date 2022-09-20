//
//  GameRoomSDKParams.h
//  veGameRoomParams
//
//  Created by ByteDance on 2022/8/18.
//

#import <Foundation/Foundation.h>
#import "BaseRTCManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameRoomSDKParams : NSObject

/*
 * get SudAppID、SudAppKey
 */
+ (void)getSudAppIDWithRTCManager:(BaseRTCManager *)rtcManager callback:(void (^ __nullable)(NSString *appId, NSString *appKey))block;

/*
 *  get GameCode
 */
+ (void)getGameCodeWithRTCManager:(BaseRTCManager *)rtcManager callback:(void (^ __nullable)(NSString *code))block;

@end

NS_ASSUME_NONNULL_END
