//
//  VoiceRoomBottomView.m
//  quickstart
//
//  Created by bytedance on 2021/3/23.
//  Copyright © 2021 . All rights reserved.
//

#import "GameRoomBottomView.h"
#import "UIView+Fillet.h"

@interface GameRoomBottomView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray *buttonLists;

@end

@implementation GameRoomBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubviewAndConstraints];
    }
    return self;
}

- (void)buttonAction:(GameRoomItemButton *)sender {
    if ([self.delegate respondsToSelector:@selector(gameRoomBottomView:itemButton:didSelectStatus:)]) {
        [self.delegate gameRoomBottomView:self itemButton:sender didSelectStatus:sender.tagNum];
    }
}

- (void)addSubviewAndConstraints {
    NSInteger groupNum = 4;
    for (int i = 0; i < groupNum; i++) {
        GameRoomItemButton *button = [[GameRoomItemButton alloc] init];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 30, 0)];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.buttonLists addObject:button];
        [self.contentView addSubview:button];
    }
}

#pragma mark - Publish Action

- (void)updateBottomLists:(NSArray<NSNumber *> *)status {
    NSMutableArray *lists = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.buttonLists.count; i++) {
        GameRoomItemButton *button = self.buttonLists[i];
        if (i < status.count) {
            NSNumber *number = status[i];
            GameRoomBottomStatus bottomStatus = number.integerValue;
            
            button.tagNum = bottomStatus;
            UIImage *image = [self getImageWithStatus:bottomStatus];
            [button bingImage:image status:ButtonStatusNone];
            [button bingImage:[self getSelectImageWithStatus:bottomStatus] status:ButtonStatusActive];
            button.desTitle = [self getdesTitleWithStatus:bottomStatus];
            button.hidden = NO;
            button.status = ButtonStatusNone;
            button.isAction = NO;
            [lists addObject:button];
        } else {
            button.hidden = YES;
        }
        
    }
    
    CGFloat itemWidth = SCREEN_WIDTH / lists.count;
    [lists mas_remakeConstraints:^(MASConstraintMaker *make) {
            
    }];
    [lists mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:itemWidth leadSpacing:0 tailSpacing:0];
    [lists mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.mas_equalTo(-[DeviceInforTool getVirtualHomeHeight]);
    }];
}

- (void)replaceButtonStatus:(GameRoomBottomStatus)status newStatus:(GameRoomBottomStatus)newStatus {
    NSString *title = [self getdesTitleWithStatus:status];
    GameRoomItemButton *selectButton = nil;
    for (GameRoomItemButton *button in self.buttonLists) {
        if ([button.desTitle isEqualToString:title]) {
            selectButton = button;
            break;
        }
    }
    if (selectButton) {
        selectButton.isAction = NO;
        selectButton.tagNum = newStatus;
        [selectButton bingImage:[self getImageWithStatus:newStatus] status:ButtonStatusNone];
        [selectButton bingImage:[self getSelectImageWithStatus:newStatus] status:ButtonStatusActive];
        selectButton.desTitle = [self getdesTitleWithStatus:newStatus];
    }
}

- (void)updateButtonStatus:(GameRoomBottomStatus)status close:(BOOL)isClose {
    [self updateButtonStatus:status close:isClose isTitle:YES];
}

- (void)updateButtonStatus:(GameRoomBottomStatus)status close:(BOOL)isClose isTitle:(BOOL)isTitle {
    NSString *title = [self getdesTitleWithStatus:status];
    GameRoomItemButton *selectButton = nil;
    for (GameRoomItemButton *button in self.buttonLists) {
        if ([button.desTitle isEqualToString:title]) {
            selectButton = button;
            break;
        }
    }
    if (selectButton) {
        selectButton.status = isClose ? ButtonStatusActive : ButtonStatusNone;
        if (isTitle) {
            selectButton.isAction = isClose;
        } else {
            selectButton.isAction = NO;
        }
    }
}

- (ButtonStatus)getButtonStatus:(GameRoomBottomStatus)status {
    NSString *title = [self getdesTitleWithStatus:status];
    GameRoomItemButton *selectButton = nil;
    for (GameRoomItemButton *button in self.buttonLists) {
        if ([button.desTitle isEqualToString:title]) {
            selectButton = button;
            break;
        }
    }
    if (selectButton) {
        return selectButton.status;
    } else {
        return ButtonStatusNone;
    }
}

#pragma mark - Private Action

- (NSString *)getdesTitleWithStatus:(GameRoomBottomStatus)status {
    NSString *name = @"";
    switch (status) {
        case GameRoomBottomStatusList:
            name = @"列表管理";
            break;
        case GameRoomBottomStatusMic:
            name = @"静音自己";
            break;
        case GameRoomBottomStatusVolume:
            name = @"调音";
            break;
        case GameRoomBottomStatusData:
            name = @"音频数据";
            break;
        case GameRoomBottomStatusRaiseHand:
            name = @"举手上麦";
            break;
        case GameRoomBottomStatusListRed:
            name = @"列表管理";
            break;
        case GameRoomBottomStatusDownHand:
            name = @"下麦";
            break;
        default:
            break;
    }
    return name;
}

- (UIImage *)getImageWithStatus:(GameRoomBottomStatus)status {
    NSString *name = @"";
    switch (status) {
        case GameRoomBottomStatusList:
            name = @"voice_menu";
            break;
        case GameRoomBottomStatusMic:
            name = @"voice_mic";
            break;
        case GameRoomBottomStatusVolume:
            name = @"voice_doc";
            break;
        case GameRoomBottomStatusData:
            name = @"voice_doc";
            break;
        case GameRoomBottomStatusRaiseHand:
            name = @"voice_upmic";
            break;
        case GameRoomBottomStatusListRed:
            name = @"voice_upmic_s";
            break;
        case GameRoomBottomStatusDownHand:
            name = @"voice_downmic";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:name bundleName:HomeBundleName];
}

- (UIImage *)getSelectImageWithStatus:(GameRoomBottomStatus)status {
    NSString *name = @"";
    switch (status) {
        case GameRoomBottomStatusList:
            name = @"voice_menu";
            break;
        case GameRoomBottomStatusMic:
            name = @"voice_mic_s";
            break;
        case GameRoomBottomStatusVolume:
            name = @"voice_doc";
            break;
        case GameRoomBottomStatusData:
            name = @"voice_doc";
            break;
        case GameRoomBottomStatusRaiseHand:
            name = @"voice_upmic_s";
            break;
        case GameRoomBottomStatusListRed:
            name = @"voice_upmic_s";
            break;
        case GameRoomBottomStatusDownHand:
            name = @"voice_downmic";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:name bundleName:HomeBundleName];
}

#pragma mark - getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorFromHexString:@"#1D2129"];
    }
    return _contentView;
}

- (NSMutableArray *)buttonLists {
    if (!_buttonLists) {
        _buttonLists = [[NSMutableArray alloc] init];
    }
    return _buttonLists;
}

@end
