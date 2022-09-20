//
//  GameRoomListsViewController.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/18.
//  Copyright © 2021 . All rights reserved.
//

#import "GameRoomListsViewController.h"
#import "GameCreateRoomViewController.h"
#import "GameRoomViewController.h"
#import "GameRoomTableView.h"
#import "GameSudMGPManager.h"
#import "GameRTCManager.h"
#import "GameRoomSDKParams.h"

@interface GameRoomListsViewController () <GameRoomTableViewDelegate>

@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) GameRoomTableView *roomTableView;
@property (nonatomic, copy) NSString *currentAppid;
@property (nonatomic, assign) BOOL isLoadingSud;

@end

@implementation GameRoomListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden = NO;
    self.navView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.roomTableView];
    [self.roomTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
    }];
    
    [self.view addSubview:self.createButton];
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(132, 44));
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(- 20 - [DeviceInforTool getVirtualHomeHeight]);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navTitle = @"游戏房";
    self.rightTitle = @"刷新";
    
    [self loadDataWithGetLists];
}

- (void)rightButtonAction:(BaseButton *)sender {
    [super rightButtonAction:sender];
    
    [self loadDataWithGetLists];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - load data

- (void)loadDataWithGetLists {
    [GameRTSManager getGameroomListWithBlock:^(NSArray * _Nonnull lists, RTMACKModel * _Nonnull model) {
        self.roomTableView.dataLists = lists;
    }];
}

#pragma mark - GameRoomTableViewDelegate

- (void)gameRoomTableView:(GameRoomTableView *)gameRoomTableView didSelectRowAtIndexPath:(GameControlRoomModel *)model {
    if (self.isLoadingSud) {
        return;
    }
    
    __weak __typeof(self) wself = self;
    self.isLoadingSud = YES;
    [GameRoomSDKParams getSudAppIDWithRTCManager:[GameRTCManager shareRtc] callback:^(NSString * _Nonnull appId, NSString * _Nonnull appKey) {
        [[GameSudMGPManager shareManager] initSudMGPSDKWithAppId:appId appKey:appKey callback:^(BOOL success) {
            wself.isLoadingSud = NO;
            if (!success) {
                [[ToastComponent shareToastComponent] showWithMessage:@"游戏SDK初始化失败"];
                return;
            }
                
            [PublicParameterComponent share].roomId = model.room_id;

            GameRoomViewController *next = [[GameRoomViewController alloc] init];
            next.roomID = model.room_id;
            next.userName = [LocalUserComponent userModel].name;
            next.gameId = model.gid.longLongValue;
            [wself.navigationController pushViewController:next animated:YES];
        }];
    }];
}

#pragma mark - Touch Action

- (void)createButtonAction {
    GameCreateRoomViewController *next = [[GameCreateRoomViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - getter

- (UIButton *)createButton {
    if (!_createButton) {
        _createButton = [[UIButton alloc] init];
        _createButton.backgroundColor = [UIColor colorFromHexString:@"#4080FF"];
        [_createButton addTarget:self action:@selector(createButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _createButton.layer.cornerRadius = 22;
        _createButton.layer.masksToBounds = YES;
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.image = [UIImage imageNamed:@"voice_add" bundleName:HomeBundleName];
        [_createButton addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.equalTo(_createButton);
            make.left.mas_equalTo(20);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"创建房间";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [_createButton addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_createButton);
            make.left.equalTo(iconImageView.mas_right).offset(8);
        }];
    }
    return _createButton;
}

- (GameRoomTableView *)roomTableView {
    if (!_roomTableView) {
        _roomTableView = [[GameRoomTableView alloc] init];
        _roomTableView.delegate = self;
    }
    return _roomTableView;
}

- (void)dealloc {
    [[GameRTCManager shareRtc] disconnect];
    [PublicParameterComponent clear];
}


@end
