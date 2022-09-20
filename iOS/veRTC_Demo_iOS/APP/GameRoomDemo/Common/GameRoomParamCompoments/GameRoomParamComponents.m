//
//  GameRoomParamComponents.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/24.
//  Copyright © 2021 . All rights reserved.
//

#import "GameRoomParamComponents.h"
#import "GameRoomTopSelectView.h"
#import "GameRoomParamInfoView.h"

@interface GameRoomParamComponents () <GameRoomTopSelectViewDelegate>

@property (nonatomic, strong) GameRoomTopSelectView *topSelectView;
@property (nonatomic, strong) GameRoomParamInfoView *paramInfoView;
@property (nonatomic, strong) UIButton *maskButton;

@end

@implementation GameRoomParamComponents

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Publish Action

- (void)show {
    UIViewController *rootVC = [DeviceInforTool topViewController];;
    
    [rootVC.view addSubview:self.maskButton];
    [self.maskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootVC.view);
    }];
    
    [self.maskButton addSubview:self.paramInfoView];
    [self.paramInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_offset(612 / 2 + [DeviceInforTool getVirtualHomeHeight]);
        make.bottom.mas_offset(0);
    }];

    [self.maskButton addSubview:self.topSelectView];
    [self.topSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(rootVC.view);
        make.bottom.equalTo(self.paramInfoView.mas_top);
        make.height.mas_equalTo(44);
    }];
}

- (void)updateModel:(GameRoomParamInfoModel *)model {
    if (self.paramInfoView.superview) {
        self.paramInfoView.paramInfoModel = model;
    }
}

#pragma mark - GameRoomTopSelectViewDelegate

- (void)gameRoomTopSelectView:(GameRoomTopSelectView *)voiceRoomTopSelectView clickCancelAction:(id)model {
    [self dismissUserListView];
}

- (void)gameRoomTopSelectView:(GameRoomTopSelectView *)voiceRoomTopSelectView clickSwitchItem:(BOOL)isAudience {

}

#pragma mark - Private Action

- (void)maskButtonAction {
    [self dismissUserListView];
}

- (void)dismissUserListView {
    [self.maskButton removeFromSuperview];
    self.maskButton = nil;
}

#pragma mark - Getter

- (UIButton *)maskButton {
    if (!_maskButton) {
        _maskButton = [[UIButton alloc] init];
        [_maskButton addTarget:self action:@selector(maskButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_maskButton setBackgroundColor:[UIColor colorFromRGBHexString:@"#101319" andAlpha:0.5 * 255]];
    }
    return _maskButton;
}

- (GameRoomTopSelectView *)topSelectView {
    if (!_topSelectView) {
        _topSelectView = [[GameRoomTopSelectView alloc] init];
        _topSelectView.delegate = self;
        _topSelectView.titleStr = @"实时音频数据";
    }
    return _topSelectView;
}

- (GameRoomParamInfoView *)paramInfoView {
    if (!_paramInfoView) {
        _paramInfoView = [[GameRoomParamInfoView alloc] init];
    }
    return _paramInfoView;
}

- (void)dealloc {
    NSLog(@"dealloc %@",NSStringFromClass([self class]));
}
@end
