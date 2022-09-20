//
//  GameRoomDemo.m
//  AFNetworking
//
//  Created by bytedance on 2022/4/21.
//

#import "GameRoomDemo.h"
#import "JoinRTSParams.h"
#import "GameRTCManager.h"
#import "GameRoomListsViewController.h"
#import <Core/NetworkReachabilityManager.h>

@implementation GameRoomDemo

- (void)pushDemoViewControllerBlock:(void (^)(BOOL result))block {
    [GameRTCManager shareRtc].networkDelegate = [NetworkReachabilityManager sharedManager];
    JoinRTSInputModel *inputModel = [[JoinRTSInputModel alloc] init];
    inputModel.scenesName = @"gr";
    inputModel.loginToken = [LocalUserComponent userModel].loginToken;
    __weak __typeof(self) wself = self;
    [JoinRTSParams getJoinRTSParams:inputModel
                             block:^(JoinRTSParamsModel * _Nonnull model) {
        [wself joinRTS:model block:block];
    }];
}

- (void)joinRTS:(JoinRTSParamsModel * _Nonnull)model
          block:(void (^)(BOOL result))block{
    if (!model) {
        [[ToastComponent shareToastComponent] showWithMessage:@"连接失败"];
        if (block) {
            block(NO);
        }
        return;
    }
    // Connect RTS
    [[GameRTCManager shareRtc] connect:model.appId
                              RTSToken:model.RTSToken
                             serverUrl:model.serverUrl
                             serverSig:model.serverSignature
                                   bid:model.bid
                                 block:^(BOOL result) {
        if (result) {
            GameRoomListsViewController *next = [[GameRoomListsViewController alloc] init];
            UIViewController *topVC = [DeviceInforTool topViewController];
            [topVC.navigationController pushViewController:next animated:YES];
        } else {
            [[ToastComponent shareToastComponent] showWithMessage:@"连接失败"];
        }
        if (block) {
            block(result);
        }
    }];
}

@end
