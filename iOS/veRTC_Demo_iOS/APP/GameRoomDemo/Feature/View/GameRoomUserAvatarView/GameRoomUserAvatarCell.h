//
//  GameRoomUserAvatarCell.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/19.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameControlUserModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AvatarCellStatus) {
    AvatarCellStatusMic,
    AvatarCellStatusAudience,
};

@interface GameRoomUserAvatarCell : UICollectionViewCell

@property (nonatomic, strong) GameControlUserModel *model;

@property (nonatomic, assign) AvatarCellStatus status;

@end

NS_ASSUME_NONNULL_END
