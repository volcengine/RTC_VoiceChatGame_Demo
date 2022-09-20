//
//  GameRoomMicCell.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/21.
//  Copyright © 2021 . All rights reserved.
//

#import "GameRoomMicCell.h"
#import "GameRoomMicUserView.h"

@interface GameRoomMicCell ()

@property (nonatomic, strong) GameRoomMicUserView *micUserView;

@end

@implementation GameRoomMicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.micUserView];
        [self.micUserView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.height.mas_equalTo(88);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setDataLists:(NSArray *)dataLists {
    _dataLists = dataLists;
    
    self.micUserView.dataLists = dataLists;
}

#pragma mark - getter

- (GameRoomMicUserView *)micUserView {
    if (!_micUserView) {
        _micUserView = [[GameRoomMicUserView alloc] init];
        _micUserView.backgroundColor = [UIColor clearColor];
    }
    return _micUserView;
}

@end
