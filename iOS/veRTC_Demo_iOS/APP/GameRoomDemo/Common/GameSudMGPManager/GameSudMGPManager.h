//
//  GameSudMGPManager.h
//  GameRoomDemo
//
//  Created by ByteDance on 2   q-022/6/24.
//

#import <Foundation/Foundation.h>
#import <SudMGP/SudMGP.h>
#import "GameSDKConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameSudMGPManager : NSObject

@property (nonatomic, strong, readonly, nullable) NSString * sudMGPCode;

/*
 * GameSudMGPManager Singletons
 */
+ (GameSudMGPManager *_Nullable)shareManager;

/*
 *  获取sudMGPCode
 *  @param isForceRefresh 是否强制刷新code
 *  @param resultCallback 回调
 */
- (void)requestSudMGPCode:(BOOL)isForceRefresh resultCallback:(void(^)(NSString * _Nullable code))resultCallback;

/*
 * 初始化游戏SDK
 */
- (void)initSudMGPSDKWithAppId:(NSString *)appId appKey:(NSString *)appKey callback:(void(^)(BOOL success))resultCallback;

/*
 * 获取游戏错误表
 */
+ (NSDictionary *)getErrorMap;

@end

NS_ASSUME_NONNULL_END
