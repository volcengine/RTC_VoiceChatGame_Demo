//
//  GameRoomViewController.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/18.
//  Copyright © 2021 . All rights reserved.
//

#import "GameRoomViewController.h"
#import "GameRoomView.h"
#import "GameRoomBottomView.h"
#import "GameRoomNavView.h"
#import "GameRoomUserListComponents.h"
#import "GameEndComponents.h"
#import "GameIMComponents.h"
#import "GameRoomParamComponents.h"
#import "GameRoomViewController+SocketControl.h"
#import "SystemAuthority.h"
#import "ToastComponent.h"
#import "GameRoomVolumeComponents.h"
#import "GameRTCManager.h"
#import "GameRoomViewController+SudMGP.h"
#import <AVFoundation/AVFoundation.h>

@interface GameRoomViewController () <GameRoomNavViewDelegate, GameRoomBottomViewDelegate, GameRTCManagerDelegate>

@property (nonatomic, strong) GameRoomView *roomView;
@property (nonatomic, strong) GameRoomBottomView *bottomView;
@property (nonatomic, strong) GameRoomNavView *navView;
@property (nonatomic, strong) GameRoomParamComponents *paramComponents;
@property (nonatomic, strong) GameRoomVolumeComponents *volumeComponents;
@property (nonatomic, strong) GameRoomUserListComponents *userListComponents;
@property (nonatomic, strong) GameEndComponents *endComponents;
@property (nonatomic, strong) GameIMComponents *imComponents;

@property (nonatomic, strong) UIView *gameRootView;
@property (nonatomic, strong) id<ISudFSTAPP> iSudAPP;

@end

@implementation GameRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self addSocketListener];
    [self addBgGradientLayer];
    [self addSubviewAndConstraints];
    
    [self loadDataWithRoomInfo];
        
    [self addLifeCycleObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.iSudAPP playMG];
}

- (void)addLifeCycleObserver {
     // app从后台进入前台都会调用这个方法
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
     // 添加检测app进入后台的观察者
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - Notification

- (void)applicationEnterForeground {
    [self.iSudAPP playMG];
}

- (void)applicationEnterBackground {
    [self.iSudAPP pauseMG];
}

- (void)gameControlChange:(NSDictionary *)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *type = dic[@"type"];
        if ([type isEqualToString:@"resume"]) {
            self.userLists = dic[@"users"];
            self.roomModel = (GameControlRoomModel *)(dic[@"roomModel"]);
            [self updateRoomViewWithData];
        } else if ([type isEqualToString:@"exit"]) {
            [self hangUp];
            GameControlUserModel *loginUserModel = [self currentLoginuserModel];
            if (!loginUserModel.is_host) {
                [[ToastComponent shareToastComponent] showWithMessage:@"房间已解散" delay:0.8];
            }
        } else {
            
        }
    }
}

#pragma mark - Publish Action

- (void)addUser:(GameControlUserModel *)userModel {
    [self.roomView joinUser:userModel];
    [self.userListComponents update];
    
    GameIMModel *imModel = [[GameIMModel alloc] init];
    imModel.isJoin = YES;
    imModel.userModel = userModel;
    [self.imComponents addIM:imModel];
    
    [self.navView updateUserCount:self.roomView.allUserLists.count];
}

- (void)removeUser:(GameControlUserModel *)userModel {
    [self.roomView leaveUser:userModel.user_id];
    [self.userListComponents update];
    
    GameIMModel *imModel = [[GameIMModel alloc] init];
    imModel.isJoin = NO;
    imModel.userModel = userModel;
    [self.imComponents addIM:imModel];
    
    [self.navView updateUserCount:self.roomView.allUserLists.count];
}

- (void)receivedRaiseHandWithUser:(NSString *)uid {
    if ([self currentLoginuserModel].is_host) {
        [self.bottomView replaceButtonStatus:GameRoomBottomStatusList newStatus:GameRoomBottomStatusListRed];
        [self.userListComponents update];
    }
    [self.roomView updateUserHand:uid isHand:YES];
    [self.roomView reloadData];
}

- (void)receivedRaiseHandInviteWithAudience {
    AlertActionModel *alertModel = [[AlertActionModel alloc] init];
    alertModel.title = @"确定";
    AlertActionModel *cancelModel = [[AlertActionModel alloc] init];
    cancelModel.title = @"取消";
    [[AlertActionManager shareAlertActionManager] showWithMessage:@"主播邀请您上麦" actions:@[cancelModel, alertModel]];
    alertModel.alertModelClickBlock = ^(UIAlertAction * _Nonnull action) {
        if ([action.title isEqualToString:@"确定"]) {
            [GameRTSManager confirmMicWithBlock:nil];
        }
    };
}

- (void)receivedRaiseHandSucceedWithUser:(GameControlUserModel *)userModel {
    [self.roomView audienceRaisedHandsSuccess:userModel];
    [self.userListComponents update];
    if ([userModel.user_id isEqualToString:[LocalUserComponent userModel].uid]) {
        GameControlUserModel *localUser = [self currentLoginuserModel];
        localUser.user_status = 2;
        localUser.is_mic_on = YES;
        [self.bottomView updateBottomLists:[self getBottomListsWithModel:localUser]];
        [[ToastComponent shareToastComponent] showWithMessage:@"您已成功上麦"];
        [[GameRTCManager shareRtc] makeCoHost:YES];
        [[GameRTCManager shareRtc] muteLocalAudioStream:NO];
        [self checkMicrophoneSystemAuthority];
    }
}

- (void)receivedLowerHandSucceedWithUser:(NSString *)uid {
    [self.roomView hostLowerHandSuccess:uid];
    [self.userListComponents update];
    if ([uid isEqualToString:[LocalUserComponent userModel].uid]) {
        GameControlUserModel *localUser = [self currentLoginuserModel];
        localUser.user_status = 0;
        localUser.is_mic_on = NO;
        [self.bottomView updateBottomLists:[self getBottomListsWithModel:localUser]];
        [[ToastComponent shareToastComponent] showWithMessage:@"您已回到听众席"];
        [[GameRTCManager shareRtc] makeCoHost:NO];
    }
}

- (void)receivedMicChangeWithMute:(BOOL)isMute uid:(NSString *)uid {
    [self.roomView updateUserMic:uid isMute:isMute];
}

- (void)receivedHostChangeWithNewHostUid:(GameControlUserModel *)hostUser {
    [self.roomView updateHostUser:hostUser.user_id];
    if ([[LocalUserComponent userModel].uid isEqualToString:hostUser.user_id]) {
        // 如果当前登录用户为新主持人
        // If the currently logged-in user is the new host
        [self.bottomView updateBottomLists:[self getBottomListsWithModel:[self currentLoginuserModel]]];
        [self.bottomView updateButtonStatus:GameRoomBottomStatusMic close:!hostUser.is_mic_on isTitle:NO];
        [[GameRTCManager shareRtc] muteLocalAudioStream:!hostUser.is_mic_on];
        [[ToastComponent shareToastComponent] showWithMessage:@"您已成为主播"];
    }
}

- (void)receivedGameroomEnd:(NSInteger)type {
    [self hangUp];
    if (type == 2) {
        [[ToastComponent shareToastComponent] showWithMessage:@"体验时间已到，房间解散" delay:0.8];
        return;
    }
    
    GameControlUserModel *loginUserModel = [self currentLoginuserModel];
    if (!loginUserModel.is_host) {
        [[ToastComponent shareToastComponent] showWithMessage:@"房间已解散" delay:0.8];
    }
}

- (void)hangUp {
    // rtm api
    __weak __typeof(self) wself = self;
    [GameRTSManager leaveGameroom:^(RTMACKModel * _Nonnull model) {
        // ui
        [wself navigationControllerPop];
    }];
    [[GameRTCManager shareRtc] leaveRTCRoom];
}


#pragma mark - Load Data

- (void)loadDataWithRoomInfo {
    if (IsEmptyStr(self.roomModel.room_id)) {
        [self joinVocie];
    } else {
        [self joinChannel];
        
        [self initSudMGP];
    }
}

- (void)joinVocie {
    __weak __typeof(self)wself = self;
    [GameRTSManager joinGameroom:self.roomID userName:self.userName block:^(NSString * _Nonnull token, GameControlRoomModel * _Nonnull roomModel, NSArray<GameControlUserModel *> * _Nonnull lists, RTMACKModel * _Nonnull model) {
        if (token) {
            wself.userLists = lists;
            wself.token = token;
            wself.roomModel = roomModel;
            [wself joinChannel];
            
            [wself initSudMGP];
        } else {
            [wself showJoinFailedAlert];
        }
    }];
}

#pragma mark - GameRoomBottomViewDelegate

- (void)gameRoomBottomView:(GameRoomBottomView *_Nonnull)gameRoomBottomView
                itemButton:(GameRoomItemButton *_Nullable)itemButton
           didSelectStatus:(GameRoomBottomStatus)status {
    if (status == GameRoomBottomStatusList ||
        status == GameRoomBottomStatusListRed) {
        __weak __typeof(self) wself = self;
        [self.userListComponents show:^{
            [wself restoreBottomViewMenuStatus];
        }];
    } else if (status == GameRoomBottomStatusRaiseHand) {
        __weak __typeof(self) wself = self;
        [GameRTSManager raiseHandsMicWithBlock:^(RTMACKModel * _Nonnull model) {
            if (model.result) {
                [[ToastComponent shareToastComponent] showWithMessage:@"上麦请求已发出，请耐心等待"];

                [wself.bottomView updateButtonStatus:GameRoomBottomStatusRaiseHand close:YES];
                [wself checkMicrophoneSystemAuthority];
            }else {
                [[ToastComponent shareToastComponent] showWithMessage:@"操作失败，请重试"];
            }
        }];
    } else if (status == GameRoomBottomStatusMic) {
        [SystemAuthority authorizationStatusWithType:AuthorizationTypeAudio block:^(BOOL isAuthorize) {
            if (itemButton.status == ButtonStatusNone) {
                //mute
                [GameRTSManager muteMic];
                [[GameRTCManager shareRtc] muteLocalAudioStream:YES];
            } else {
                //unmute
                [GameRTSManager unmuteMic];
                [[GameRTCManager shareRtc] muteLocalAudioStream:NO];
            }
            itemButton.status = itemButton.status == ButtonStatusNone ? ButtonStatusActive : ButtonStatusNone;
        }];
    } else if (status == GameRoomBottomStatusVolume) {
        [self.volumeComponents show];
    } else if (status == GameRoomBottomStatusData) {
        [self.paramComponents show];
    } else if (status == GameRoomBottomStatusDownHand) {
        AlertActionModel *alertModel = [[AlertActionModel alloc] init];
        alertModel.title = @"确定";
        AlertActionModel *cancelModel = [[AlertActionModel alloc] init];
        cancelModel.title = @"取消";
        __weak __typeof(self) wself = self;
        [[AlertActionManager shareAlertActionManager] showWithMessage:@"是否确认下麦？" actions:@[cancelModel, alertModel]];
        alertModel.alertModelClickBlock = ^(UIAlertAction * _Nonnull action) {
            if ([action.title isEqualToString:@"确定"]) {
                [GameRTSManager offSelfMicWithBlock:^(RTMACKModel * _Nonnull model) {
                    if (model.result) {
                        [wself sendDownloadHand];
                    }else {
                        [[ToastComponent shareToastComponent] showWithMessage:@"操作失败，请重试"];
                    }
                }];
            }
        };
    } else {
        
    }
}

#pragma mark - GameRoomNavViewDelegate

- (void)gameRoomNavView:(GameRoomNavView *)gameRoomNavView didSelectStatus:(RoomNavStatus)status {
    if (status == RoomNavStatusHangeup) {
        [self showEndView];
    }
}

#pragma mark - GameRTCManagerDelegate

- (void)gameRoomRTCManager:(GameRTCManager *)gameRTCManager changeParamInfo:(GameRoomParamInfoModel *)model {
    [self.paramComponents updateModel:model];
}

- (void)gameRoomRTCManager:(GameRTCManager *_Nonnull)gameRTCManager reportAllAudioVolume:(NSDictionary<NSString *, NSNumber *> *_Nonnull)volumeInfo {
    [self.roomView updateHostVolume:volumeInfo];
}


#pragma mark - Private Action

- (void)joinChannel {
    if (NOEmptyStr(self.roomModel.room_id)) {
        //Activate SDK
        [GameRTCManager shareRtc].delegate = self;
        [[GameRTCManager shareRtc] joinChannelWithToken:self.token
                                                  roomID:self.roomModel.room_id
                                                     uid:[LocalUserComponent userModel].uid];
        __weak __typeof(self)wself = self;
        [GameRTCManager shareRtc].rtcJoinRoomBlock = ^(NSString *roomId, NSInteger errorCode, NSInteger joinType) {
            if (joinType == 0) {
                // 首次加入房间
                if (errorCode == 0) {
                    //Refresh the UI
                    [wself updateRoomViewWithData];
                } else {
                    [wself showJoinFailedAlert];
                }
            } else {
                // 断线重新加入房间
                [wself gameReconnect];
            }
        };
    } else {
        [self showJoinFailedAlert];
    }
}

- (void)gameReconnect {
    __weak __typeof(self) wself = self;
    [GameRTSManager reconnectWithBlock:^(GameControlRoomModel * _Nonnull roomModel, NSArray * _Nonnull users, RTMACKModel * _Nonnull ackModel) {
        NSString *type = @"";
        if (ackModel.result) {
            type = @"resume";
        } else if (ackModel.code == RTMStatusCodeUserIsInactive ||
                   ackModel.code == RTMStatusCodeRoomDisbanded ||
                   ackModel.code == RTMStatusCodeUserNotFound) {
            type = @"exit";
        } else {
            
        }
        if (NOEmptyStr(type)) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:type forKey:@"type"];
            [dic setValue:roomModel forKey:@"roomModel"];
            [dic setValue:users forKey:@"users"];
            [wself gameControlChange:dic];
        }
    }];
}


- (void)updateRoomViewWithData {
    [self.roomView updateAllUser:self.userLists roomModel:self.roomModel];
    self.navView.roomModel = self.roomModel;
    [self.bottomView updateBottomLists:[self getBottomListsWithModel:[self currentLoginuserModel]]];
    GameControlUserModel *loginUserModel = [self currentLoginuserModel];
    if (loginUserModel.is_host || loginUserModel.user_status == 2) {
        [[GameRTCManager shareRtc] makeCoHost:YES];
    } else {
        [[GameRTCManager shareRtc] makeCoHost:NO];
    }
    [[GameRTCManager shareRtc] muteLocalAudioStream:!loginUserModel.is_mic_on];
    [self.bottomView updateButtonStatus:GameRoomBottomStatusMic close:!loginUserModel.is_mic_on isTitle:NO];
    [self checkMicrophoneSystemAuthority];
}

- (void)checkMicrophoneSystemAuthority {
    [SystemAuthority authorizationStatusWithType:AuthorizationTypeAudio block:^(BOOL isAuthorize) {
        if (!isAuthorize) {
            AlertActionModel *alertModel = [[AlertActionModel alloc] init];
            alertModel.title = @"确定";
            [[AlertActionManager shareAlertActionManager] showWithMessage:@"麦克风权限已关闭，请至设备设置页开启。" actions:@[alertModel]];
        }
    }];
}

- (void)sendDownloadHand {
    NSString *uid = [LocalUserComponent userModel].uid;
    [self.roomView updateUserHand:uid isHand:NO];
    [self.roomView reloadData];
    [self.bottomView replaceButtonStatus:GameRoomBottomStatusDownHand newStatus:GameRoomBottomStatusRaiseHand];
}

- (void)restoreBottomViewMenuStatus {
    [self.bottomView replaceButtonStatus:GameRoomBottomStatusListRed newStatus:GameRoomBottomStatusList];
}

- (void)addSubviewAndConstraints {
    [self.view addSubview:self.roomView];
    [self.view addSubview:self.gameRootView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.navView];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([DeviceInforTool getStatusBarHight] + 44);
        make.width.equalTo(self.view);
        make.top.left.equalTo(self.view);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([DeviceInforTool getVirtualHomeHeight] + 64);
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.roomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.gameRootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom).offset(88.f);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (void)showEndView {
    GameEndStatus status = GameEndStatusAudience;
    if ([self currentLoginuserModel].is_host) {
        if ([self.roomView hostNumber] <= 1) {
            status = GameEndStatusHostOnly;
        } else {
            status = GameEndStatusHost;
        }
    }
    [self.endComponents showWithStatus:status];
    __weak __typeof(self) wself = self;
    self.endComponents.clickButtonBlock = ^(GameButtonStatus status) {
        if (status == GameButtonStatusEnd ||
            status == GameButtonStatusLeave) {
            [wself hangUp];
        } else if (status == GameButtonStatusCancel) {
            //cancel
        }
        wself.endComponents = nil;
    };
}

- (void)navigationControllerPop {
    UIViewController *jumpVC = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([NSStringFromClass([vc class]) isEqualToString:@"GameRoomListsViewController"]) {
            jumpVC = vc;
            break;
        }
    }
    if (jumpVC) {
        [self.navigationController popToViewController:jumpVC animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self notifyIsPlayingState:NO];
    
    //小游戏SDK的坑，需要destroyMG之前手动调用[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient,防止后续小游戏音频渲染模块crash.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [self.iSudAPP destroyMG];
}

- (GameControlUserModel *)currentLoginuserModel {
    GameControlUserModel *currentModel = nil;
    for (GameControlUserModel *userModel in [self.roomView allUserLists]) {
        if ([userModel.user_id isEqualToString:[LocalUserComponent userModel].uid]) {
            currentModel = userModel;
            break;
        }
    }
    return currentModel;
}

- (NSArray *)getBottomListsWithModel:(GameControlUserModel *)userModel {
    NSArray *bottomLists = nil;
    if (userModel.is_host) {
        bottomLists = @[@(GameRoomBottomStatusList),
                        @(GameRoomBottomStatusMic),
                        @(GameRoomBottomStatusVolume),
                        @(GameRoomBottomStatusData)];
    } else {
        if (userModel.user_status == 2) {
            bottomLists = @[@(GameRoomBottomStatusDownHand),
                            @(GameRoomBottomStatusMic),
                            @(GameRoomBottomStatusVolume),
                            @(GameRoomBottomStatusData)];
        } else {
            bottomLists = @[@(GameRoomBottomStatusRaiseHand),
                            @(GameRoomBottomStatusData)];
        }
    }
    return bottomLists;
}

- (void)addBgGradientLayer {
    UIColor *startColor = [UIColor colorFromHexString:@"#30394A"];
    UIColor *endColor = [UIColor colorFromHexString:@"#1D2129"];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(__bridge id)[startColor colorWithAlphaComponent:1.0].CGColor,
                             (__bridge id)[endColor colorWithAlphaComponent:1.0].CGColor];
    gradientLayer.startPoint = CGPointMake(.0, .0);
    gradientLayer.endPoint = CGPointMake(.0, 1.0);
    [self.view.layer addSublayer:gradientLayer];
}

- (void)showJoinFailedAlert {
    AlertActionModel *alertModel = [[AlertActionModel alloc] init];
    alertModel.title = @"确定";
    __weak __typeof(self)wself = self;
    alertModel.alertModelClickBlock = ^(UIAlertAction * _Nonnull action) {
        if ([action.title isEqualToString:@"确定"]) {
            [wself hangUp];
        }
    };
    [[AlertActionManager shareAlertActionManager] showWithMessage:@"加入房间失败，回到房间列表页" actions:@[alertModel]];
}


#pragma mark - Getter

- (GameRoomView *)roomView {
    if (!_roomView) {
        _roomView = [[GameRoomView alloc] init];
    }
    return _roomView;
}

- (UIView *)gameRootView {
    if (!_gameRootView) {
        _gameRootView = [UIView new];
    }
    return _gameRootView;
}

- (GameRoomBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[GameRoomBottomView alloc] init];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (GameRoomNavView *)navView {
    if (!_navView) {
        _navView = [[GameRoomNavView alloc] init];
        _navView.delegate = self;
    }
    return _navView;
}

- (GameRoomUserListComponents *)userListComponents {
    if (!_userListComponents) {
        _userListComponents = [[GameRoomUserListComponents alloc] init];
    }
    return _userListComponents;
}

- (GameEndComponents *)endComponents {
    if (!_endComponents) {
        _endComponents = [[GameEndComponents alloc] init];
    }
    return _endComponents;
}

- (GameIMComponents *)imComponents {
    if (!_imComponents) {
        _imComponents = [[GameIMComponents alloc] initWithSuperView:self.view];
    }
    return _imComponents;
}

- (GameRoomParamComponents *)paramComponents {
    if (!_paramComponents) {
        _paramComponents = [[GameRoomParamComponents alloc] init];
    }
    return _paramComponents;
}

- (GameRoomVolumeComponents *)volumeComponents {
    if (!_volumeComponents) {
        _volumeComponents = [[GameRoomVolumeComponents alloc] init];
        _volumeComponents.onRoomVolumeChange = ^(NSInteger value) {
            [[GameRTCManager shareRtc].rtcEngineKit setPlaybackVolume:value];
        };
        
        __weak __typeof(self) wself = self;
        _volumeComponents.onGameVolumeChange = ^(NSInteger value) {
            [wself notifyStateChange:@"app_common_game_sound_volume" dataJson:[GameUtils dictionaryToJson:@{@"volume" : @(value)}]];
        };
    }
    return _volumeComponents;
}

@end
