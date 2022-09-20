//
//  GameRTMManager.h
//  GameRoomDemo
//
//  Created by ByteDance on 2022/8/5.
//

#import <Foundation/Foundation.h>
#import "GameControlUserModel.h"
#import "GameControlRoomModel.h"

#import "RTMACKModel.h"
#import "BaseUserModel.h"
#import "GameInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameRTSManager : NSObject

#pragma mark - Get Gameroom data

/*
 * get Gameroom list
 * @param block Callback
 */
+ (void)getGameroomListWithBlock:(void (^ __nullable)(NSArray *lists,
                                                  RTMACKModel *model))block;
/*
 * create Gameroom
 * @param roomName the name of the Gameroom
 * @param userName the username when you are in the Gameroom
 * @param gid gameId
 * @param block Callback
 */
+ (void)createGameroom:(NSString *)roomName
              userName:(NSString *)userName
                gameId:(NSString *)gid
                 block:(void (^ __nullable)(NSString *token,
                                            GameControlRoomModel *roomModel,
                                            NSArray<GameControlUserModel *> *lists,
                                            BOOL isSensitiveWords,
                                            RTMACKModel *model))block;
/*
 * Join the Gameroom
 * @param userName the username when you are in the Gameroom
 * @param block Callback
 */
+ (void)joinGameroom:(NSString *)roomID
            userName:(NSString *)userName
               block:(void (^ __nullable)(NSString *token,
                                          GameControlRoomModel *roomModel,
                                          NSArray<GameControlUserModel *> *lists,
                                          RTMACKModel *model))block;

/*
 * Leave Gameroom
 * @param block Callback
 */
+ (void)leaveGameroom:(void (^ __nullable)(RTMACKModel *model))block;

/*
 * Get the participant list/participant status
 * @param block Callback
 */
+ (void)getRaiseHandsWithBlock:(void (^ __nullable)(NSArray<GameControlUserModel *> *userLists, RTMACKModel *model))block;

/*
 * Get the audiences in the Gameroom
 * @param block Callback
 */
+ (void)getAudiencesWithBlock:(void (^ __nullable)(NSArray<GameControlUserModel *> *userLists, RTMACKModel *model))block;

/*
 * reconnect the Gameroom
 * @param block Callback
 */
+ (void)reconnectWithBlock:(void (^)(GameControlRoomModel *, NSArray *users, RTMACKModel * _Nonnull))block;

#pragma mark - Control Gameroom status

/*
 * Invite Mic
 * @param userId Host ID to be handed over
 * @param block Callback
 */
+ (void)inviteMic:(NSString *)userId block:(void (^ __nullable)(RTMACKModel *model))block;

/*
 * Confirmation
 * @param userId Users who want to mute, do not pass means to mute all users
 * @param block Callback
 */
+ (void)confirmMicWithBlock:(void (^ __nullable)(RTMACKModel *model))block;

/*
 * Raise your hand in wheat
 * @param userId ID of the user who requested to turn on the microphone
 * @param block Callback
 */
+ (void)raiseHandsMicWithBlock:(void (^ __nullable)(RTMACKModel *model))block;

/*
 * Agree to serve
 * @param userId ID of the user who requested to turn on the microphone
 * @param block Callback
 */
+ (void)agreeMic:(NSString *)userId block:(void (^ __nullable)(RTMACKModel *model))block;

// Download (user)
+ (void)offSelfMicWithBlock:(void (^ __nullable)(RTMACKModel *model))block;

// Switch to normal user (host)
+ (void)offMic:(NSString *)userId block:(void (^ __nullable)(RTMACKModel *model))block;

/*
 * Turn On Mic
 */
+ (void)muteMic;

/*
 * Turn Off Mic
 */
+ (void)unmuteMic;

/*
 *  grGetGameList
 */
+ (void)getGameListWithBlock:(void (^ __nullable)(NSArray <GameInfoModel *>*))block;

#pragma mark - Notification message

/*
 * User join Notification
 * @param block Callback
 */
+ (void)onJoinGameroomWithBlock:(void (^)(GameControlUserModel *userModel))block;

/*
 * User leave Notification
 * @param block Callback
 */
+ (void)onLeaveGameroomWithBlock:(void (^)(GameControlUserModel *userModel))block;

/*
 * User raises hand Notification
 * @param block Callback
 */
+ (void)onRaiseHandsMicWithBlock:(void (^)(NSString *uid))block;

/*
 * Audience receives the invitation to the microphone Notification
 * @param block Callback
 */
+ (void)onInviteMicWithBlock:(void (^)(NSString *uid))block;

/*
 * Successful user registration Notification
 * @param block Callback
 */
+ (void)onMicOnWithBlock:(void (^)(GameControlUserModel *userModel))block;

/*
 * Successful user download Notification
 * @param block Callback
 */
+ (void)onMicOffWithBlock:(void (^)(NSString *uid))block;

/*
 * User silent notification Notification
 * @param block Callback
 */
+ (void)onMuteMicWithBlock:(void (^)(NSString *uid))block;

/*
 * User unmute notification Notification
 * @param block Callback
 */
+ (void)onUnmuteMic:(void (^)(NSString * _Nonnull uid))block;

/*
 * Is over Notification
 * @param block Callback
 */
+ (void)onGameroomEnd:(void (^)(BOOL result, NSInteger type))block;

/*
 * Handover host Notification
 * @param block Callback
 */
+ (void)onHostChange:(void (^)(NSString *formerHostID, GameControlUserModel *hostUser))block;


@end

NS_ASSUME_NONNULL_END
