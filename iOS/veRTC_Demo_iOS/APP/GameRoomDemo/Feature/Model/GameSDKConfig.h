//
//  GameSDKConfig.h
//  GameRoomDemo
//
//  Created by ByteDance on 2022/6/27.
//

#ifndef GameSDKConfig_h
#define GameSDKConfig_h


#pragma mark - 通用状态-玩家
/// 加入状态
static NSString* MG_COMMON_PLAYER_IN        = @"mg_common_player_in";
/// 准备状态
static NSString* MG_COMMON_PLAYER_READY     = @"mg_common_player_ready";
/// 队长状态
static NSString* MG_COMMON_PLAYER_CAPTAIN   = @"mg_common_player_captain";
/// 游戏状态
static NSString* MG_COMMON_PLAYER_PLAYING   = @"mg_common_player_playing";

/// 你画我猜
/// 选词中
static NSString* MG_DG_SELECTING            = @"mg_dg_selecting";
/// 作画中
static NSString* MG_DG_PAINTING             = @"mg_dg_painting";
/// 错误答案
static NSString* MG_DG_ERRORANSWER          = @"mg_dg_erroranswer";
/// 总积分
static NSString* MG_DG_TOTALSCORE           = @"mg_dg_totalscore";
/// 本次积分
static NSString* MG_DG_SCORE                = @"mg_dg_score";


#pragma mark - APP-->MG 状态
/// 加入状态
static NSString* APP_COMMON_SELF_IN         = @"app_common_self_in";
/// 准备状态
static NSString* APP_COMMON_SELF_READY      = @"app_common_self_ready";
/// 游戏状态
static NSString* APP_COMMON_SELF_PLAYING    = @"app_common_self_playing";
/// 队长状态
static NSString* APP_COMMON_SELF_CAPTAIN    = @"app_common_self_captain";
/// 踢人
static NSString* APP_COMMON_SELF_KICK       = @"app_common_self_kick";
/// 结束游戏
static NSString* APP_COMMON_SELF_END        = @"app_common_self_end";
/// 房间状态
static NSString* APP_COMMON_SELF_ROOM       = @"app_common_self_room";
/// 麦位状态
static NSString* APP_COMMON_SELF_SEAT       = @"app_common_self_seat";
/// 麦克风状态
static NSString* APP_COMMON_SELF_MICROPHONE = @"app_common_self_microphone";
/// 文字命中状态
static NSString* APP_COMMON_SELF_TEXT_HIT   = @"app_common_self_text_hit";
/// 打开或关闭背景音乐
static NSString* APP_COMMON_OPEN_BG_MUSIC   = @"app_common_open_bg_music";
/// 打开或关闭音效
static NSString* APP_COMMON_OPEN_SOUND      = @"app_common_open_sound";
/// 打开或关闭游戏中的振动效果
static NSString* APP_COMMON_OPEN_VIBRATE    = @"app_common_open_vibrate";

#pragma mark - 通用状态-游戏
/// 公屏消息
static NSString* MG_COMMON_PUBLIC_MESSAGE   = @"mg_common_public_message";
/// 关键词状态
static NSString* MG_COMMON_KEY_WORD_TO_HIT  = @"mg_common_key_word_to_hit";
/// ASR状态
static NSString* MG_COMMON_GAME_ASR = @"mg_common_game_asr";
///  游戏结算状态
static NSString* MG_COMMON_GAME_SETTLE  = @"mg_common_game_settle";
/// 加入游戏按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_JOIN_BTN  = @"mg_common_self_click_join_btn";
/// 取消加入游戏按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_CANCEL_JOIN_BTN  = @"mg_common_self_click_cancel_join_btn";
/// 准备按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_READY_BTN  = @"mg_common_self_click_ready_btn";
/// 取消准备按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_CANCEL_READY_BTN  = @"mg_common_self_click_cancel_ready_btn";
/// 开始游戏按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_START_BTN  = @"mg_common_self_click_start_btn";
/// 结算界面关闭按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_GAME_SETTLE_CLOSE_BTN  = @"mg_common_self_click_game_settle_close_btn";
/// 结算界面再来一局按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_GAME_SETTLE_AGAIN_BTN  = @"mg_common_self_click_game_settle_again_btn";
/// 麦克风状态
static NSString* MG_COMMON_SELF_MICROPHONE = @"mg_common_self_microphone";
/// 耳机（听筒，扬声器）状态
static NSString* MG_COMMON_SELF_HEADPHONE = @"mg_common_self_headphone";

#endif /* GameSDKConfig_h */
