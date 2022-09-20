//
//  GameSudMGPManager.m
//  GameRoomDemo
//
//  Created by ByteDance on 2022/6/24.
//

#import "GameSudMGPManager.h"
#import <AFNetworking/AFNetworking.h>
#import "GameRTSManager.h"
#import "GameRoomSDKParams.h"
#import "GameRTCManager.h"

@interface GameSudMGPManager ()

@property (nonatomic, assign) BOOL isInitSDK;
@property (nonatomic, strong, nullable) NSString * sudMGPCode;

@end


@implementation GameSudMGPManager

+ (GameSudMGPManager *_Nullable)shareManager {
    static GameSudMGPManager *sudMGPManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sudMGPManager = [[GameSudMGPManager alloc] init];
    });
    return sudMGPManager;
}

- (void)requestSudMGPCode:(BOOL)isForceRefresh resultCallback:(void(^)(NSString * _Nullable code))resultCallback {
    if (self.sudMGPCode && !isForceRefresh) {
        if (resultCallback) {
            resultCallback(self.sudMGPCode);
        }
        return;
    }

    __weak __typeof(self) wself = self;
    [GameRoomSDKParams getGameCodeWithRTCManager:[GameRTCManager shareRtc] callback:^(NSString * _Nonnull code) {
        wself.sudMGPCode = nil;
        if (code && [code isKindOfClass:[NSString class]]) {
            wself.sudMGPCode = code;
        }

        if (resultCallback) {
            resultCallback(wself.sudMGPCode);
        }
    }];
}


- (void)initSudMGPSDKWithAppId:(NSString *)appId appKey:(NSString *)appKey callback:(void(^)(BOOL success))resultCallback {
    if (self.isInitSDK) {
        if (resultCallback) {
            resultCallback(YES);
        }
        return;
    }
    
    __weak __typeof(self) wself = self;
    [SudMGP initSDK:appId appKey:appKey isTestEnv:YES listener:^(int retCode, const NSString * _Nonnull retMsg) {
        wself.isInitSDK = retCode == 0;
        if (resultCallback) {
            resultCallback(wself.isInitSDK);
        }
    }];
}

+ (NSDictionary *)getErrorMap {
    return  @{
        // 通用错误
        @"100000" : @"通用错误",
        @"100001" : @"http 缺失code 参数",
        @"100002" : @"http 缺失roomID 参数",
        @"100003" : @"http 缺失appID 参数",
        @"100004" : @"http 缺失openID 参数",
        @"100005" : @"code 效验失败或者过期",
        @"100006" : @"sdk 请求错误",
        @"100007" : @"sdk 参数错误",
        @"100008" : @"数据库查询错误",
        @"100009" : @"数据库插入错误",
        @"100010" : @"数据库修改错误",
        // 业务错误
        @"100100" : @"登陆错误",
        @"100200" : @"加入房间错误",
        @"100201" : @"战斗时房间不能加入",
        @"100202" : @"房间人数已满",
        @"100203" : @"重复加入",
        @"100204" : @"位置上有人",
        @"100300" : @"退出错误",
        @"100301" : @"不在游戏位",
        @"100302" : @"准备或游戏状态不能退出",
        @"100400" : @"准备错误",
        @"100401" : @"取消准备错误",
        @"100500" : @"开始游戏错误",
        @"100501" : @"游戏已开始",
        @"100502" : @"队长才能开始游戏",
        @"100503" : @"有人未准备",
        @"100504" : @"开始游戏的人数不足",
        @"100600" : @"踢人错误",
        @"100601" : @"队长才能踢人",
        @"100602" : @"战斗房间不能踢人",
        @"100700" : @"换队长错误",
        @"100800" : @"逃跑错误",
        @"100801" : @"逃跑时游戏已结束",
        @"100802" : @"逃跑时玩家已不在游戏中",
        @"100900" : @"解散错误",
        @"100901" : @"解散时游戏已结束",
        @"100902" : @"队长才能解散",
    };
}

@end
