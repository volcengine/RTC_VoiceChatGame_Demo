//
//  GameRoomAudienceCell.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/21.
//  Copyright © 2021 . All rights reserved.
//

#import "GameRoomAudienceCell.h"
#import "GameRoomAudienceView.h"

@interface GameRoomAudienceCell ()

@property (nonatomic, strong) GameRoomAudienceView *audienceView;

@end

@implementation GameRoomAudienceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:self.audienceView];
        [self.audienceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(18);
            make.right.equalTo(self.contentView).offset(-18);
            make.height.mas_equalTo(64 + 10);
            make.bottom.equalTo(self.contentView).priority(MASLayoutPriorityDefaultLow);
        }];
    }
    return self;
}

- (void)setDataLists:(NSArray *)dataLists {
    _dataLists = dataLists;
    
    self.audienceView.dataLists = dataLists;
    NSInteger row = (dataLists.count / 4);
    NSInteger rowNumber = ((dataLists.count % 4) == 0) ? row : row + 1;
    [self.audienceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo((64 + 10) * rowNumber);
    }];
}

- (GameRoomAudienceView *)audienceView {
    if (!_audienceView) {
        _audienceView = [[GameRoomAudienceView alloc] init];
        _audienceView.backgroundColor = [UIColor clearColor];
    }
    return _audienceView;
}

@end
