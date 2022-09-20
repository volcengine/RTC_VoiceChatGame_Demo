//
//  GameRoomView.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/21.
//  Copyright © 2021 . All rights reserved.
//

#import "GameRoomView.h"
#import "GameRoomMicCell.h"
#import "GCDTimer.h"

@interface GameRoomView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<GameControlUserModel *> *hostLists;
@property (nonatomic, strong) NSMutableArray<GameControlUserModel *> *audienceLists;
@property (nonatomic, strong) UITableView *roomTableView;
@property (nonatomic, strong) NSMutableArray *roomDataLists;
@property (nonatomic, strong) GameControlRoomModel *roomModel;
@property (nonatomic, strong) GCDTimer *timer;

@end


@implementation GameRoomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.roomTableView];
        [self.roomTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        __weak __typeof(self) wself = self;
        [self.timer startTimerWithSpace:0.5 block:^(BOOL result) {
            [wself timerMethod];
        }];
    }
    return self;
}


#pragma mark - Publish Action

- (void)updateAllUser:(NSArray<GameControlUserModel *> *)userLists roomModel:(GameControlRoomModel *)roomModel {
    self.roomModel = roomModel;
    
    [self.hostLists removeAllObjects];
    [self.audienceLists removeAllObjects];
    if (userLists && userLists.count > 0) {
        for (GameControlUserModel *userModel in userLists) {
            if (userModel.is_host || userModel.user_status == 2) {
                [self.hostLists addObject:userModel];
            } else {
                [self.audienceLists addObject:userModel];
            }
        }
    }
    [self updateRoomDataLists];
}

- (void)joinUser:(GameControlUserModel *)user {
    if (!self.roomModel) {
        return;
    }
    GameControlUserModel *deleteUserModel = nil;
    for (GameControlUserModel *model in self.hostLists) {
        if ([model.user_id isEqualToString:user.user_id]) {
            deleteUserModel = model;
        }
    }
    if (deleteUserModel) {
        [self.hostLists removeObject:deleteUserModel];
    }
    
    NSInteger replaceIndex = -1;
    GameControlUserModel *replaceUserModel = nil;
    for (int i = 0; i < self.audienceLists.count; i++) {
        GameControlUserModel *currentUser = self.audienceLists[i];
        if ([currentUser.user_id isEqualToString:user.user_id]) {
            replaceIndex = i;
            replaceUserModel = user;
            break;
        }
    }
    if (replaceIndex >= 0 && replaceUserModel) {
        [self.audienceLists replaceObjectAtIndex:replaceIndex withObject:replaceUserModel];
    } else {
        [self.audienceLists insertObject:user atIndex:0];
    }
    [self updateRoomDataLists];
}

- (void)leaveUser:(NSString *)user {
    GameControlUserModel *leaveUserModel = nil;
    for (GameControlUserModel *model in self.hostLists) {
        if ([model.user_id isEqualToString:user]) {
            leaveUserModel = model;
        }
    }
    if (leaveUserModel) {
        [self.hostLists removeObject:leaveUserModel];
        [self updateRoomDataLists];
        leaveUserModel = nil;
    }
    for (GameControlUserModel *model in self.audienceLists) {
        if ([model.user_id isEqualToString:user]) {
            leaveUserModel = model;
        }
    }
    if (leaveUserModel) {
        [self.audienceLists removeObject:leaveUserModel];
        [self updateRoomDataLists];
    }
}

- (void)audienceRaisedHandsSuccess:(GameControlUserModel *)userModel {
    GameControlUserModel *newHostUser = nil;
    GameControlUserModel *deleteHostUser = nil;
    for (GameControlUserModel *model in self.audienceLists) {
        if ([model.user_id isEqualToString:userModel.user_id]) {
            newHostUser = userModel;
            deleteHostUser = model;
            break;
        }
    }
    if (newHostUser) {
        [self.audienceLists removeObject:deleteHostUser];
        [self.hostLists addObject:newHostUser];
        [self updateRoomDataLists];
    }
}

- (void)hostLowerHandSuccess:(NSString *)uid {
    GameControlUserModel *newAudienceUser = nil;
    for (GameControlUserModel *model in self.hostLists) {
        if ([model.user_id isEqualToString:uid]) {
            newAudienceUser = model;
            newAudienceUser.user_status = 0;
        }
    }
    if (newAudienceUser) {
        [self.hostLists removeObject:newAudienceUser];
        [self.audienceLists insertObject:newAudienceUser atIndex:0];
        [self updateRoomDataLists];
    }
}

- (void)updateHostVolume:(NSDictionary<NSString *, NSNumber *> *_Nonnull)volumeInfo {
    for (GameControlUserModel *model in self.hostLists) {
        NSNumber *volume = [volumeInfo objectForKey:model.user_id];
        model.volume = [volume integerValue];
    }
}

- (void)updateHostUser:(NSString *)uid {
    for (GameControlUserModel *model in self.hostLists) {
        if ([model.user_id isEqualToString:uid]) {
            model.is_host = YES;
        } else {
            model.is_host = NO;
        }
    }
}

- (void)updateUserHand:(NSString *)uid isHand:(BOOL)isHand {
    for (GameControlUserModel *model in self.audienceLists) {
        if ([model.user_id isEqualToString:uid]) {
            model.user_status = isHand ? 1 : 0;
            break;
        }
    }
}

- (void)updateUserMic:(NSString *)uid isMute:(BOOL)isMute {
    for (GameControlUserModel *model in self.hostLists) {
        if ([model.user_id isEqualToString:uid]) {
            model.is_mic_on = !isMute;
            break;
        }
    }
}

- (NSArray<GameControlUserModel *> *)allUserLists {
    NSMutableArray *lists = [[NSMutableArray alloc] init];
    [lists addObjectsFromArray:self.hostLists];
    [lists addObjectsFromArray:self.audienceLists];
    return [lists copy];
}

#pragma mark - Private Action

- (void)timerMethod {
    [self reloadData];
}

- (void)updateRoomDataLists {
    [self.roomDataLists removeAllObjects];
    //host
    [self.roomDataLists addObject:[self.hostLists copy]];

    [self reloadData];
}

- (void)reloadData {
    [self.roomTableView reloadData];
}

- (NSInteger)hostNumber {
    return self.hostLists.count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"VoiceRoomMicCellID" forIndexPath:indexPath];
            ((GameRoomMicCell *)cell).dataLists = self.roomDataLists[indexPath.row];
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.roomDataLists.count;
}


#pragma mark - getter


- (UITableView *)roomTableView {
    if (!_roomTableView) {
        _roomTableView = [[UITableView alloc] init];
        _roomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _roomTableView.delegate = self;
        _roomTableView.dataSource = self;
        [_roomTableView registerClass:GameRoomMicCell.class forCellReuseIdentifier:@"VoiceRoomMicCellID"];
        _roomTableView.backgroundColor = [UIColor clearColor];
        _roomTableView.rowHeight = UITableViewAutomaticDimension;
        _roomTableView.estimatedRowHeight = 36;
        _roomTableView.estimatedSectionFooterHeight = 0;
        _roomTableView.estimatedSectionHeaderHeight = 0;
    }
    return _roomTableView;
}

- (NSMutableArray *)roomDataLists {
    if (!_roomDataLists) {
        _roomDataLists = [[NSMutableArray alloc] init];
    }
    return _roomDataLists;
}

- (NSMutableArray<GameControlUserModel *> *)hostLists {
    if (!_hostLists) {
        _hostLists = [[NSMutableArray alloc] init];
    }
    return _hostLists;
}

- (NSMutableArray<GameControlUserModel *> *)audienceLists {
    if (!_audienceLists) {
        _audienceLists = [[NSMutableArray alloc] init];
    }
    return _audienceLists;
}

- (GCDTimer *)timer {
    if (!_timer) {
        _timer = [[GCDTimer alloc] init];
    }
    return _timer;
}

@end
