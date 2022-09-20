//
//  GameRoomSDKParams.m
//  veGameRoomParams
//
//  Created by ByteDance on 2022/8/18.
//

#import "GameRoomSDKParams.h"
#import "JoinRTSParams.h"
#import "GameRoomBuildConfig.h"
#import <AFNetworking/AFNetworking.h>

@implementation GameRoomSDKParams

+ (void)getSudAppIDWithRTCManager:(BaseRTCManager *)rtcManager callback:(void (^ __nullable)(NSString *appId, NSString *appKey))block {

    if (block) {
        block(SudAPPID, SudAPPKey);
    }
}

+ (void)getGameCodeWithRTCManager:(BaseRTCManager *)rtcManager callback:(void (^ __nullable)(NSString *code))block {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    NSDictionary * param = @{@"user_id" : [LocalUserComponent userModel].uid};
    [manager POST:LOGIN_URL parameters:param headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [responseObject objectForKey:@"data"];
        /// 这里的code用于登录游戏sdk服务器
        NSString * code = [dic objectForKey:@"code"];
        int retCode = (int)[[dic objectForKey:@"ret_code"] longValue];
        
        if (block) {
            block(code);
        }
        [self invalidateHttpSession:manager];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (block) {
            block(nil);
        }
        [self invalidateHttpSession:manager];
    }];
}


+ (void)invalidateHttpSession:(AFHTTPSessionManager *)manager{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [manager invalidateSessionCancelingTasks:YES resetSession:NO];
    });
}

@end
