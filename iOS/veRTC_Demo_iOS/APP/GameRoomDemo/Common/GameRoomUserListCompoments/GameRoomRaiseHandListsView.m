//
//  GameRoomRaiseHandListsView.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/19.
//  Copyright © 2021 . All rights reserved.
//

#import "GameRoomRaiseHandListsView.h"

@interface GameRoomRaiseHandListsView ()<UITableViewDelegate, UITableViewDataSource, GameRoomUserListtCellDelegate>

@property (nonatomic, strong) UITableView *roomTableView;

@end

@implementation GameRoomRaiseHandListsView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.roomTableView];
        [self.roomTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - Publish Action

- (void)setDataLists:(NSArray *)dataLists {
    _dataLists = dataLists;
    
    [self.roomTableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GameRoomUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameRoomUserListtCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataLists[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataLists.count;
}

#pragma mark - GameRoomUserListtCellDelegate

- (void)gameRoomUserListCell:(GameRoomUserListCell *)gameRoomUserListtCell clickButton:(id)model {
    if ([self.delegate respondsToSelector:@selector(gameRoomRaiseHandListsView:clickButton:)]) {
        [self.delegate gameRoomRaiseHandListsView:self clickButton:model];
    }
}

#pragma mark - getter

- (UITableView *)roomTableView {
    if (!_roomTableView) {
        _roomTableView = [[UITableView alloc] init];
        _roomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _roomTableView.delegate = self;
        _roomTableView.dataSource = self;
        [_roomTableView registerClass:GameRoomUserListCell.class forCellReuseIdentifier:@"GameRoomUserListtCellID"];
        _roomTableView.backgroundColor = [UIColor colorFromHexString:@"#272E3B"];
    }
    return _roomTableView;
}

- (void)dealloc {
    NSLog(@"dealloc %@",NSStringFromClass([self class]));
}

@end
