//
//  GameRoomCell.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/18.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameControlRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameRoomCell : UITableViewCell

@property (nonatomic, strong) GameControlRoomModel *model;

@end

NS_ASSUME_NONNULL_END
