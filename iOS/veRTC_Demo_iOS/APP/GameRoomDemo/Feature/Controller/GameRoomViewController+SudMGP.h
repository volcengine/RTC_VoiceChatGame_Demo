//
//  GameRoomViewController+SudMGP.h
//  veRTC_Demo
//
//  Created by ByteDance on 2022/7/7.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import "GameRoomViewController.h"
#import "GameRTSManager.h"
#import "GameSudMGPManager.h"
#import "GameSDKConfig.h"
#import "GameUtils.h"
#import <SudMGP/ISudFSMMG.h>
#import <SudMGP/ISudFSTAPP.h>
#import <SudMGP/ISudFSMStateHandle.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameRoomViewController (SudMGP) <ISudFSMMG>

@property (nonatomic, strong) UIView *gameRootView;
@property (nonatomic, strong, nullable) id<ISudFSTAPP> iSudAPP;

- (void)initSudMGP;

/*
 * 状态通知（app to mg）
 * @param state 状态名称
 * @param dataJson 需传递的json
 */
- (void)notifyStateChange:(NSString *)state dataJson:(NSString*)dataJson;

/*
 * 游戏中状态设置
 */
- (void)notifyIsPlayingState:(BOOL)isPlaying;
@end

NS_ASSUME_NONNULL_END
