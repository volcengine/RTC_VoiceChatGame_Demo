//
//  GameCreateRoomViewController.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/18.
//  Copyright © 2021 . All rights reserved.
//

#import "GameCreateRoomViewController.h"
#import "GameRoomTextFieldView.h"
#import "GameRoomViewController.h"
#import "GameSudMGPManager.h"
#import "NetworkingManager.h"
#import "GameRoomSDKParams.h"
#import "GameRTCManager.h"

@interface GameItemView : UIView

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *itemTitleLabel;
@property (nonatomic, strong) UIButton *itemButton;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) void (^selectedCallback)(GameItemView *itemView);

@end

@implementation GameItemView

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.backGroundView = [UIView new];
        self.backGroundView.backgroundColor = [UIColor colorFromHexString:@"#394254"];
        self.backGroundView.layer.cornerRadius = 8.f;
        [self addSubview:self.backGroundView];
        
        [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.itemImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName bundleName:HomeBundleName]];
        [self addSubview:self.itemImageView];
        [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(17.7f);
            make.width.equalTo(@(37.5f));
            make.height.equalTo(@(31.3f));
            make.centerY.equalTo(self);
        }];
        
        self.itemTitleLabel = [UILabel new];
        self.itemTitleLabel.text = title;
        self.itemTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
        self.itemTitleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.itemTitleLabel];
        [self.itemTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemImageView.mas_right).offset(13.3f);
            make.height.equalTo(@20.f);
            make.centerY.equalTo(self.itemImageView);
        }];
        
        self.itemButton = [UIButton new];
        [self addSubview:self.itemButton];
        [self.itemButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.isSelected = NO;
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    CGColorRef borderColor = isSelected ? [UIColor colorFromHexString:@"#4080FF"].CGColor : [UIColor clearColor].CGColor;
    
    self.backGroundView.layer.borderColor = borderColor;
    self.backGroundView.layer.borderWidth = 1.5f;
}

- (void)onClick:(UIButton *)sender {
    if (self.selectedCallback) {
        self.selectedCallback(self);
    }
}

@end


@interface GameCreateRoomViewController ()

@property (nonatomic, strong) GameRoomTextFieldView *roomNameTextFieldView;
@property (nonatomic, strong) GameRoomTextFieldView *userNameTextFieldView;
@property (nonatomic, strong) UIButton *joinButton;

@property (nonatomic, assign) NSInteger selGameId;
@property (nonatomic, strong) NSArray <GameItemView *>*gameItemList;
@end

@implementation GameCreateRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:@"#272E3B"];
    
    [self.view addSubview:self.roomNameTextFieldView];
    [self.roomNameTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(32);
        make.top.equalTo(self.navView.mas_bottom).offset(53);
    }];
    
    [self.view addSubview:self.userNameTextFieldView];
    [self.userNameTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(32);
        make.top.equalTo(self.roomNameTextFieldView.mas_bottom).offset(32);
    }];
    
    [self.view addSubview:self.joinButton];
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-40.0);
    }];
    
    self.userNameTextFieldView.text = [LocalUserComponent userModel].name;
    
    [self.roomNameTextFieldView becomeFirstResponder];
        
    [GameRTSManager getGameListWithBlock:^(NSArray <GameInfoModel *>* _Nonnull list) {
        [self addGameList:list];
    }];
}

- (void)addGameList:(NSArray <GameInfoModel *>*)list {
    NSMutableArray *itemList = [NSMutableArray array];
    for (GameInfoModel *model in list) {
        NSString *name = model.name[@"default"];
        if (![name isKindOfClass:[NSString class]]) {
            name = nil;
        }
        GameItemView *itemView = [[GameItemView alloc] initWithImageName:@"game_black_white_cheese" title:name];
        
        NSInteger gameId = model.mg_id_str.integerValue;
        NSInteger index = [list indexOfObject:model];
        if (index == 0) {
            self.selGameId = gameId;
            itemView.isSelected = YES;
        }else {
            itemView.isSelected = NO;
        }
        itemView.tag = gameId;

        __weak __typeof(self) wself = self;
        itemView.selectedCallback = ^(GameItemView *itemView) {
            [wself onSelectGameId:itemView.tag];
        };
        
        [itemList addObject:itemView];
        
        [self.view addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (index % 2 == 0) {
                make.left.equalTo(self.userNameTextFieldView);
            }else {
                make.right.equalTo(self.userNameTextFieldView);
            }
            
            make.top.equalTo(self.userNameTextFieldView.mas_bottom).offset(30.f + (index / 2) * 82.f);
            make.width.equalTo(@(157.5f));
            make.height.equalTo(@(72.f));
        }];

    }
    self.gameItemList = itemList;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navTitle = @"游戏房";
}

- (void)onSelectGameId:(NSInteger)gameId {
    self.selGameId = gameId;
    
    for (GameItemView *itemView in self.gameItemList) {
        itemView.isSelected = itemView.tag == gameId;
    }
}

- (void)joinButtonAction:(UIButton *)sender {
    if (IsEmptyStr(self.roomNameTextFieldView.text)) {
        [[ToastComponent shareToastComponent] showWithMessage:@"输入不得为空"];
        return;
    }
    if (IsEmptyStr(self.userNameTextFieldView.text) ||
        ![LocalUserComponent isMatchUserName:self.userNameTextFieldView.text]) {
        [[ToastComponent shareToastComponent] showWithMessage:@"输入不得为空"];
        return;
    }
    sender.enabled = NO;
    __weak __typeof(self) wself = self;
    
    BaseUserModel *userModel = [LocalUserComponent userModel];
    userModel.name = self.userNameTextFieldView.text;
    [NetworkingManager changeUserName:userModel.name loginToken:[LocalUserComponent userModel].loginToken block:^(NetworkingResponse * _Nonnull response) {
        if (response.result) {
            [LocalUserComponent updateLocalUserModel:userModel];

            [GameRTSManager createGameroom:wself.roomNameTextFieldView.text userName:wself.userNameTextFieldView.text gameId:@(wself.selGameId).stringValue block:^(NSString * _Nonnull token, GameControlRoomModel * _Nonnull roomModel, NSArray<GameControlUserModel *> * _Nonnull lists, BOOL isSensitiveWords, RTMACKModel * _Nonnull model) {
                if (token.length > 0) {
                    [GameRoomSDKParams getSudAppIDWithRTCManager:[GameRTCManager shareRtc] callback:^(NSString * _Nonnull appId, NSString * _Nonnull appKey) {
                        [[GameSudMGPManager shareManager] initSudMGPSDKWithAppId:appId appKey:appKey callback:^(BOOL success) {
                            sender.enabled = YES;
                            if (!success) {
                                [[ToastComponent shareToastComponent] showWithMessage:@"游戏SDK初始化失败"];
                                return;
                            }
                            [PublicParameterComponent share].roomId = roomModel.room_id;

                            GameRoomViewController *next = [[GameRoomViewController alloc] init];
                            next.token = token;
                            next.roomModel = roomModel;
                            next.userLists = lists;
                            next.gameId = wself.selGameId;
                            [wself.navigationController pushViewController:next animated:YES];
                        }];
                    }];
                } else {
                    NSString *message = isSensitiveWords ? @"输入内容包含敏感词，请重新输入" : @"创建房间失败";
                    [[ToastComponent shareToastComponent] showWithMessage:message];
                    sender.enabled = YES;
                }
            }];
        } else {
            sender.enabled = YES;
            [[ToastComponent shareToastComponent] showWithMessage:response.message];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.roomNameTextFieldView resignFirstResponder];
    [self.userNameTextFieldView resignFirstResponder];
}

#pragma mark - getter

- (GameRoomTextFieldView *)roomNameTextFieldView {
    if (!_roomNameTextFieldView) {
        _roomNameTextFieldView = [[GameRoomTextFieldView alloc] initWithModify:NO];
        _roomNameTextFieldView.placeholderStr = @"请输入房间主题";
        _roomNameTextFieldView.maxLimit = 20;
        _roomNameTextFieldView.isCheckIllega = NO;
        _roomNameTextFieldView.errorMessage = @"房间主题长度限制 1-20位";
    }
    return _roomNameTextFieldView;
}

- (GameRoomTextFieldView *)userNameTextFieldView {
    if (!_userNameTextFieldView) {
        _userNameTextFieldView = [[GameRoomTextFieldView alloc] initWithModify:NO];
        _userNameTextFieldView.placeholderStr = @"请输入用户昵称";
        _userNameTextFieldView.maxLimit = 18;
    }
    return _userNameTextFieldView;
}

- (UIButton *)joinButton {
    if (!_joinButton) {
        _joinButton = [[UIButton alloc] init];
        _joinButton.backgroundColor = [UIColor colorFromHexString:@"#4080FF"];
        [_joinButton setTitle:@"进入房间" forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _joinButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [_joinButton addTarget:self action:@selector(joinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _joinButton.layer.cornerRadius = 25;
        _joinButton.layer.masksToBounds = YES;
    }
    return _joinButton;
}

@end
