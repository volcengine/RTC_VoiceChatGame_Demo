#import "BaseRTCManager.h"
#import "GameRTCManager.h"
#import <VolcEngineRTC/objc/rtc/ByteRTCEngineKit.h>
#import "GameRoomParamInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GameRTCManager;
@protocol GameRTCManagerDelegate <NSObject>

/*
 * 房间质量参数的回调
 */
- (void)gameRoomRTCManager:(GameRTCManager *)gameRTCManager changeParamInfo:(GameRoomParamInfoModel *)model;

/*
 * 音量信息变化的回调
 */
- (void)gameRoomRTCManager:(GameRTCManager *_Nonnull)gameRTCManager reportAllAudioVolume:(NSDictionary<NSString *, NSNumber *> *_Nonnull)volumeInfo;

@end

@interface GameRTCManager : BaseRTCManager

@property (nonatomic, weak) id<GameRTCManagerDelegate> delegate;

/*
 * RTC Manager Singletons
 */
+ (GameRTCManager *_Nullable)shareRtc;

#pragma mark - Base Method

/**
 * Join room
 * @param token token
 * @param roomID roomID
 * @param uid uid
 */
- (void)joinChannelWithToken:(NSString *)token roomID:(NSString *)roomID uid:(NSString *)uid;

/*
 * Switch local audio capture
 * @param enable ture:Turn on audio capture false：Turn off audio capture
 */
- (void)makeCoHost:(BOOL)isCoHost;

/*
 * Switch local audio capture
 * @param mute ture:Turn on audio capture false：Turn off audio capture
 */
- (void)muteLocalAudioStream:(BOOL)isMute;

/*
 * Leave the room
 */
- (void)leaveRTCRoom;

@end

NS_ASSUME_NONNULL_END
