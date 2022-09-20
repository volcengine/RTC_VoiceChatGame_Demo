//
//  GameRoomVolumeComponents.m
//  GameRoomDemo
//
//  Created by ByteDance on 2022/7/1.
//

#import "GameRoomVolumeComponents.h"
#import "GameRoomTopSelectView.h"

#define kLeftMargin 16.f

@interface GameRoomVolumeView : UIView

@property (nonatomic, strong) UILabel *roomVolumeLabel;
@property (nonatomic, strong) UILabel *roomVolumeValueLabel;
@property (nonatomic, strong) UISlider *roomVolumeSlider;

@property (nonatomic, strong) UILabel *gameVolumeLabel;
@property (nonatomic, strong) UILabel *gameVolumeValueLabel;
@property (nonatomic, strong) UISlider *gameVolumeSlider;

@property (nonatomic, copy) void (^onRoomVolumeChange)(NSInteger value);

@property (nonatomic, copy) void (^onGameVolumeChange)(NSInteger value);

@end

@implementation GameRoomVolumeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorFromHexString:@"#272E3B"];

        self.roomVolumeLabel = [UILabel new];
        self.roomVolumeLabel.text = @"房间语音音量 你听到的语音音量";
        self.roomVolumeLabel.font = [UIFont systemFontOfSize:14.f];
        self.roomVolumeLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.roomVolumeLabel];
        
        self.roomVolumeValueLabel = [UILabel new];
        self.roomVolumeValueLabel.text = @"100";
        self.roomVolumeValueLabel.font = [UIFont systemFontOfSize:14.f];
        self.roomVolumeValueLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.roomVolumeValueLabel];
        
        self.roomVolumeSlider = [UISlider new];
        [self.roomVolumeSlider setValue:1.0 animated:NO];
        [self.roomVolumeSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.roomVolumeSlider];

        self.gameVolumeLabel = [UILabel new];
        self.gameVolumeLabel.text = @"房间游戏音量 你的游戏输出音量";
        self.gameVolumeLabel.font = [UIFont systemFontOfSize:14.f];
        self.gameVolumeLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.gameVolumeLabel];

        self.gameVolumeValueLabel = [UILabel new];
        self.gameVolumeValueLabel.text = @"100";
        self.gameVolumeValueLabel.font = [UIFont systemFontOfSize:14.f];
        self.gameVolumeValueLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.gameVolumeValueLabel];
        
        self.gameVolumeSlider = [UISlider new];
        [self.gameVolumeSlider setValue:1.0 animated:NO];
        [self.gameVolumeSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.gameVolumeSlider];

        [self.roomVolumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftMargin);
            make.top.equalTo(self).offset(50.f);
        }];
        
        [self.roomVolumeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-kLeftMargin);
            make.centerY.equalTo(self.roomVolumeLabel);
        }];
        
        [self.roomVolumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftMargin);
            make.right.equalTo(self).offset(-kLeftMargin);
            make.top.equalTo(self.roomVolumeValueLabel.mas_bottom).offset(5.f);
        }];
        
        [self.gameVolumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftMargin);
            make.top.equalTo(self.roomVolumeSlider.mas_bottom).offset(50.f);
        }];
        
        [self.gameVolumeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-kLeftMargin);
            make.centerY.equalTo(self.gameVolumeLabel);
        }];

        [self.gameVolumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftMargin);
            make.right.equalTo(self).offset(-kLeftMargin);
            make.top.equalTo(self.gameVolumeValueLabel.mas_bottom).offset(5.f);
        }];
    }
    return self;
}

- (IBAction)sliderValueChange:(id)sender {
    if (sender == self.roomVolumeSlider) {
        NSInteger value = self.roomVolumeSlider.value * 100;
        self.roomVolumeValueLabel.text = @(value).stringValue;
        
        if (self.onRoomVolumeChange) {
            self.onRoomVolumeChange(value);
        }
    }else if (sender == self.gameVolumeSlider) {
        NSInteger value = self.gameVolumeSlider.value * 100;
        self.gameVolumeValueLabel.text = @(value).stringValue;
        
        if (self.onGameVolumeChange) {
            self.onGameVolumeChange(value);
        }
    }
}

@end


@interface GameRoomVolumeComponents () <GameRoomTopSelectViewDelegate>

@property (nonatomic, strong) GameRoomTopSelectView *topSelectView;
@property (nonatomic, strong) GameRoomVolumeView *volumeView;
@property (nonatomic, strong) UIButton *maskButton;

@end


@implementation GameRoomVolumeComponents

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark - public Action

- (void)setOnRoomVolumeChange:(void (^)(NSInteger))onRoomVolumeChange {
    self.volumeView.onRoomVolumeChange = onRoomVolumeChange;
}

- (void)setOnGameVolumeChange:(void (^)(NSInteger))onGameVolumeChange {
    self.volumeView.onGameVolumeChange = onGameVolumeChange;
}

- (void)show {
    UIViewController *rootVC = [DeviceInforTool topViewController];;

    [rootVC.view addSubview:self.maskButton];
    [self.maskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootVC.view);
    }];

    [self.maskButton addSubview:self.volumeView];
    [self.volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_offset(612 / 2 + [DeviceInforTool getVirtualHomeHeight]);
        make.bottom.mas_offset(0);
    }];

    [self.maskButton addSubview:self.topSelectView];
    [self.topSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(rootVC.view);
        make.bottom.equalTo(self.volumeView.mas_top);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - GameRoomTopSelectViewDelegate

- (void)gameRoomTopSelectView:(GameRoomTopSelectView *)gameRoomTopSelectView clickCancelAction:(id)model {
    [self dismiss];
}

- (void)gameRoomTopSelectView:(GameRoomTopSelectView *)gameRoomTopSelectView clickSwitchItem:(BOOL)isAudience {

}

#pragma mark - Private Action

- (void)maskButtonAction {
    [self dismiss];
}

- (void)dismiss {
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
        _topSelectView.titleStr = @"调音";
    }
    return _topSelectView;
}

- (GameRoomVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [GameRoomVolumeView new];
    }
    
    return _volumeView;
}

@end
