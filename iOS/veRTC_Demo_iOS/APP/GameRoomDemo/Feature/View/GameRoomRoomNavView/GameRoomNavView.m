//
//  GameRoomNavView.m
//  quickstart
//
//  Created by bytedance on 2021/3/23.
//  Copyright © 2021 . All rights reserved.
//

#import "GameRoomNavView.h"
#import "GCDTimer.h"
#import "GameRoomAvatarComponents.h"

@interface GameRoomNavView ()

@property (nonatomic, strong) BaseButton *hangeupButton;
@property (nonatomic, strong) GameRoomAvatarComponents *avatarComponents;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *roomIdLabel;

@property (nonatomic, assign) NSInteger secondValue;

@end

@implementation GameRoomNavView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubviewAndConstraints];
    }
    return self;
}

- (void)hangeupButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(gameRoomNavView:didSelectStatus:)]) {
        [self.delegate gameRoomNavView:self didSelectStatus:RoomNavStatusHangeup];
    }
}

#pragma mark - Publish Action

- (void)setMeetingTime:(NSInteger)meetingTime {
    self.secondValue = meetingTime;
}

- (void)setRoomModel:(GameControlRoomModel *)roomModel {
    _roomModel = roomModel;
    NSString *roomIDStr = roomModel.room_id;
    if (roomIDStr.length > 9) {
        NSString *aboveStr = [roomIDStr substringToIndex:3];
        NSString *afterStr = [roomIDStr substringWithRange:NSMakeRange(roomIDStr.length - 3, 3)];
        roomIDStr = [NSString stringWithFormat:@"%@...%@", aboveStr, afterStr];
    }
    self.roomIdLabel.text = [roomModel.room_name stringByRemovingPercentEncoding];
    
    NSInteger time = (roomModel.now - roomModel.created_at) / 1000000000;
    if (time < 0) {
        time = 0;
    }
    self.meetingTime = time;
    
    self.avatarComponents.text = @(roomModel.user_counts).stringValue;
}

- (void)updateUserCount:(NSInteger)count {
    self.avatarComponents.text = @(count).stringValue;
}

#pragma mark - Private Action

- (void)addSubviewAndConstraints {
    [self addSubview:self.hangeupButton];
    [self.hangeupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(16.f);
        make.centerY.equalTo(self).mas_offset([DeviceInforTool getStatusBarHight]/2);
        make.height.width.mas_equalTo(24.f);
    }];
    
    [self addSubview:self.avatarComponents];
    [self.avatarComponents mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-16.f);
        make.centerY.equalTo(self).mas_offset([DeviceInforTool getStatusBarHight]/2);
        make.height.width.mas_equalTo(30);
    }];
    
    [self.contentView addSubview:self.roomIdLabel];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.hangeupButton);
    }];
    
    [self.roomIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.hangeupButton);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UILabel *)roomIdLabel {
    if (!_roomIdLabel) {
        _roomIdLabel = [[UILabel alloc] init];
        _roomIdLabel.textColor = [UIColor whiteColor];
        _roomIdLabel.font = [UIFont systemFontOfSize:16.f];
    }
    return _roomIdLabel;
}

- (GameRoomAvatarComponents *)avatarComponents {
    if (!_avatarComponents) {
        _avatarComponents = [[GameRoomAvatarComponents alloc] init];
        _avatarComponents.layer.cornerRadius = 15;
        _avatarComponents.layer.masksToBounds = YES;
        _avatarComponents.fontSize = 16;
    }
    return _avatarComponents;
}

- (BaseButton *)hangeupButton {
    if (!_hangeupButton) {
        _hangeupButton = [BaseButton buttonWithType:UIButtonTypeCustom];
        [_hangeupButton setImage:[UIImage imageNamed:@"voice_leave" bundleName:HomeBundleName] forState:UIControlStateNormal];
        [_hangeupButton addTarget:self action:@selector(hangeupButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hangeupButton;
}

@end
