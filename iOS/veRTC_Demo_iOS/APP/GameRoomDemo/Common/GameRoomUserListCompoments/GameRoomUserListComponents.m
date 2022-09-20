//
//  GameRoomUserListComponents.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/19.
//  Copyright © 2021 . All rights reserved.
//

#import "GameRoomUserListComponents.h"
#import "GameRoomTopSelectView.h"
#import "GameRTSManager.h"

@interface GameRoomUserListComponents () <GameRoomTopSelectViewDelegate, GameRoomRaiseHandListsViewDelegate, GameRoomAudienceListsViewDelegate>

@property (nonatomic, strong) GameRoomTopSelectView *topSelectView;
@property (nonatomic, strong) GameRoomRaiseHandListsView *raiseHandListsView;
@property (nonatomic, strong) GameRoomAudienceListsView *audienceListsView;
@property (nonatomic, strong) UIButton *maskButton;

@property (nonatomic, copy) void (^dismissBlock)(void);

@end


@implementation GameRoomUserListComponents

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Publish Action

- (void)show:(void (^)(void))dismissBlock {
    self.dismissBlock = dismissBlock;
    UIViewController *rootVC = [DeviceInforTool topViewController];;
    
    [rootVC.view addSubview:self.maskButton];
    [self.maskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootVC.view);
    }];
    
    [self.maskButton addSubview:self.audienceListsView];
    [self.audienceListsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_offset(726 / 2 + [DeviceInforTool getVirtualHomeHeight]);
        make.bottom.mas_offset(0);
    }];
    
    [self.maskButton addSubview:self.raiseHandListsView];
    [self.raiseHandListsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.audienceListsView);
    }];
    
    [self.maskButton addSubview:self.topSelectView];
    [self.topSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(rootVC.view);
        make.bottom.equalTo(self.audienceListsView.mas_top);
        make.height.mas_equalTo(44);
    }];
    
    
    [self loadDataWithRaiseHandLists];
}

- (void)update {
    if (self.raiseHandListsView.superview && !self.raiseHandListsView.hidden) {
        [self loadDataWithRaiseHandLists];
    } else if (self.audienceListsView.superview && !self.audienceListsView.hidden) {
        [self loadDataWithAudienceLists];
    } else {
        
    }
}

#pragma mark - Load Data

- (void)loadDataWithRaiseHandLists {
    __weak __typeof(self) wself = self;
    [GameRTSManager getRaiseHandsWithBlock:^(NSArray<GameControlUserModel *> * _Nonnull userLists, RTMACKModel * _Nonnull model) {
        if (userLists) {
            wself.raiseHandListsView.dataLists = userLists;
        } else {
            
        }
    }];
}

- (void)loadDataWithAudienceLists {
    __weak __typeof(self) wself = self;
   [GameRTSManager getAudiencesWithBlock:^(NSArray<GameControlUserModel *> * _Nonnull userLists, RTMACKModel * _Nonnull model) {
       if (userLists) {
           wself.audienceListsView.dataLists = userLists;
       } else {
           
       }
   }];
}

#pragma mark - GameRoomTopSelectViewDelegate

- (void)gameRoomTopSelectView:(GameRoomTopSelectView *)gameRoomTopSelectView clickCancelAction:(id)model {
    [self dismissUserListView];
}

- (void)gameRoomTopSelectView:(GameRoomTopSelectView *)gameRoomTopSelectView clickSwitchItem:(BOOL)isAudience {
    if (isAudience) {
        self.raiseHandListsView.hidden = YES;
        self.audienceListsView.hidden = NO;
        [self loadDataWithAudienceLists];
    } else {
        self.raiseHandListsView.hidden = NO;
        self.audienceListsView.hidden = YES;
        [self loadDataWithRaiseHandLists];
    }
}

#pragma mark - GameRoomRaiseHandListsViewDelegate

- (void)gameRoomRaiseHandListsView:(GameRoomRaiseHandListsView *)gameRoomRaiseHandListsView clickButton:(GameControlUserModel *)model {
    [self updateTableViewWithModel:model dataLists:gameRoomRaiseHandListsView.dataLists];
    [gameRoomRaiseHandListsView setDataLists:gameRoomRaiseHandListsView.dataLists];
}

#pragma mark - GameRoomAudienceListsViewDelegate

- (void)gameRoomAudienceListsView:(GameRoomAudienceListsView *)gameRoomAudienceListsView clickButton:(GameControlUserModel *)model {
    [self updateTableViewWithModel:model dataLists:gameRoomAudienceListsView.dataLists];
    [gameRoomAudienceListsView setDataLists:gameRoomAudienceListsView.dataLists];
}

#pragma mark - Private Action

- (void)updateTableViewWithModel:(GameControlUserModel *)userModel dataLists:(NSArray<GameControlUserModel *> *)dataLists {
    if (userModel.user_status == 0) {
        // 邀请上麦
        [GameRTSManager inviteMic:userModel.user_id block:^(RTMACKModel * _Nonnull model) {
            if (!model.result) {
                [[ToastComponent shareToastComponent] showWithMessage:@"操作失败，请重试"];
            }
        }];
    } else if (userModel.user_status == 1) {
        // 举手 - 同意
        __weak __typeof(self)wself = self;
        [GameRTSManager agreeMic:userModel.user_id block:^(RTMACKModel * _Nonnull model) {
            if (model.result) {
                userModel.user_status = 2;
                [wself updateDataLists:dataLists model:userModel];
            } else {
                [[ToastComponent shareToastComponent] showWithMessage:@"操作失败，请重试"];
            }
        }];
    } else if (userModel.user_status == 2) {
        // 上麦 - 下麦
        AlertActionModel *alertModel = [[AlertActionModel alloc] init];
        alertModel.title = @"确定";
        AlertActionModel *cancelModel = [[AlertActionModel alloc] init];
        cancelModel.title = @"取消";
        [[AlertActionManager shareAlertActionManager] showWithMessage:@"是否将该用户下麦？" actions:@[cancelModel, alertModel]];
        __weak __typeof(self) wself = self;
        alertModel.alertModelClickBlock = ^(UIAlertAction * _Nonnull action) {
            if ([action.title isEqualToString:@"确定"]) {
                [GameRTSManager offMic:userModel.user_id block:^(RTMACKModel * _Nonnull model) {
                    if (model.result) {
                        [wself removeDataLists:dataLists model:userModel];
                    } else {
                        [[ToastComponent shareToastComponent] showWithMessage:@"操作失败，请重试"];
                    }
                }];
            }
        };
    }
}

- (void)updateDataLists:(NSArray<GameControlUserModel *> *)dataLists model:(GameControlUserModel *)model {
    for (int i = 0; i < dataLists.count; i++) {
        GameControlUserModel *currentModel = dataLists[i];
        if ([currentModel.user_id isEqualToString:model.user_id]) {
            NSMutableArray *mutableLists = [[NSMutableArray alloc] initWithArray:dataLists];
            [mutableLists replaceObjectAtIndex:i withObject:model];
            break;
        }
    }
}

- (void)removeDataLists:(NSArray<GameControlUserModel *> *)dataLists model:(GameControlUserModel *)model {
    GameControlUserModel *deleteModel = nil;
    for (int i = 0; i < dataLists.count; i++) {
        GameControlUserModel *currentModel = dataLists[i];
        if ([currentModel.user_id isEqualToString:model.user_id]) {
            deleteModel = currentModel;
            break;
        }
    }
    
    if (deleteModel) {
        NSMutableArray *mutableLists = [[NSMutableArray alloc] initWithArray:dataLists];
        [mutableLists removeObject:deleteModel];
        dataLists = [mutableLists copy];
    }
}

- (void)maskButtonAction {
    [self dismissUserListView];
}

- (void)dismissUserListView {
    [self.maskButton removeFromSuperview];
    self.maskButton = nil;
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

#pragma mark - Getter

- (GameRoomAudienceListsView *)audienceListsView {
    if (!_audienceListsView) {
        _audienceListsView = [[GameRoomAudienceListsView alloc] init];
        _audienceListsView.delegate = self;
        _audienceListsView.backgroundColor = [UIColor colorFromHexString:@"#272E3B"];
    }
    return _audienceListsView;
}

- (GameRoomRaiseHandListsView *)raiseHandListsView {
    if (!_raiseHandListsView) {
        _raiseHandListsView = [[GameRoomRaiseHandListsView alloc] init];
        _raiseHandListsView.delegate = self;
        _raiseHandListsView.backgroundColor = [UIColor colorFromHexString:@"#272E2B"];
    }
    return _raiseHandListsView;
}

- (UIButton *)maskButton {
    if (!_maskButton) {
        _maskButton = [[UIButton alloc] init];
        [_maskButton addTarget:self action:@selector(maskButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_maskButton setBackgroundColor:[UIColor colorFromRGBHexString:@"#101319" andAlpha:0.8 * 255]];
    }
    return _maskButton;
}

- (GameRoomTopSelectView *)topSelectView {
    if (!_topSelectView) {
        _topSelectView = [[GameRoomTopSelectView alloc] init];
        _topSelectView.delegate = self;
    }
    return _topSelectView;
}

- (void)dealloc {
    NSLog(@"dealloc %@",NSStringFromClass([self class]));
}

@end
