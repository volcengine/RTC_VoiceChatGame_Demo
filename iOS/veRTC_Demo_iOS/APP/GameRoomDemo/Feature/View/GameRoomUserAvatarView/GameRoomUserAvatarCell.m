//
//  GameRoomUserAvatarCell.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/19.
//  Copyright © 2021 . All rights reserved.
//

#import "GameRoomUserAvatarCell.h"
#import "GameRoomAvatarComponents.h"

@interface GameRoomUserAvatarCell ()

@property (nonatomic, strong) GameRoomAvatarComponents *avatarView;
@property (nonatomic, strong) UILabel *titleLabel;

// Audience
@property (nonatomic, strong) UIImageView *audienceRaiseHandImageView;

// Mic
@property (nonatomic, strong) UIView *micAvatarSpeakView;

@end

@implementation GameRoomUserAvatarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.avatarView];
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.equalTo(self.contentView).offset(10.f);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarView.mas_bottom).offset(12.f);
            make.centerX.equalTo(self.contentView);
            make.left.mas_lessThanOrEqualTo(self.contentView).offset(0);
            make.right.mas_lessThanOrEqualTo(self.contentView).offset(0);
        }];

        [self addSubview:self.audienceRaiseHandImageView];
        [self.audienceRaiseHandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.avatarView);
        }];
        
        [self addSubview:self.micAvatarSpeakView];
        [self.micAvatarSpeakView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.avatarView);
        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.size.mas_equalTo(frame.size);
        }];
    }
    return self;
}

- (void)setStatus:(AvatarCellStatus)status {
    _status = status;
    
    NSInteger itemWidth = 30;
    NSInteger fontSize = 12;
    NSInteger nameFontSize = 12;
    if (status == AvatarCellStatusAudience) {
        itemWidth = 40;
        fontSize = 20;
        nameFontSize = 12;
        
        
    } else if (status == AvatarCellStatusMic) {
        
    } else {
        
    }
    
    
    [self.avatarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(itemWidth, itemWidth));
    }];
    self.avatarView.fontSize = fontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:nameFontSize];
    self.avatarView.layer.cornerRadius = itemWidth / 2;
    self.micAvatarSpeakView.layer.cornerRadius = itemWidth / 2;
}

- (void)setModel:(GameControlUserModel *)model {
    _model = model;
    self.titleLabel.text = model.user_name;
    self.avatarView.text = model.user_name;
    
    if (self.status == AvatarCellStatusAudience) {
        self.audienceRaiseHandImageView.hidden = model.user_status == 1 ? NO : YES;
        self.micAvatarSpeakView.hidden = YES;
    } else if (self.status == AvatarCellStatusMic) {
        if (model.is_mic_on) {
            self.micAvatarSpeakView.hidden = model.volume >= 10 ? NO : YES;
        } else {
            self.micAvatarSpeakView.hidden = YES;
        }
        self.audienceRaiseHandImageView.hidden = YES;
    } else {
        self.micAvatarSpeakView.hidden = YES;
        self.audienceRaiseHandImageView.hidden = YES;
    }
    
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (GameRoomAvatarComponents *)avatarView {
    if (_avatarView == nil) {
        _avatarView = [[GameRoomAvatarComponents alloc] init];
        _avatarView.layer.masksToBounds = YES;
    }
    return _avatarView;
}

- (UIImageView *)audienceRaiseHandImageView {
    if (!_audienceRaiseHandImageView) {
        _audienceRaiseHandImageView = [[UIImageView alloc] init];
        _audienceRaiseHandImageView.image = [UIImage imageNamed:@"voice_raise_hande" bundleName:HomeBundleName];
        _audienceRaiseHandImageView.hidden = YES;
    }
    return _audienceRaiseHandImageView;
}

- (UIView *)micAvatarSpeakView {
    if (!_micAvatarSpeakView) {
        _micAvatarSpeakView = [[UIView alloc] init];
        _micAvatarSpeakView.layer.masksToBounds = YES;
        _micAvatarSpeakView.layer.borderWidth = 2;
        _micAvatarSpeakView.layer.borderColor = [UIColor colorFromHexString:@"#4080FF"].CGColor;
        _micAvatarSpeakView.hidden = YES;
    }
    return _micAvatarSpeakView;
}

@end
