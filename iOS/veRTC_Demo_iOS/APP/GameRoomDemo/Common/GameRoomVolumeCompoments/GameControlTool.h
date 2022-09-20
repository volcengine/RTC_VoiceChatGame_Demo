//
//  GameControlTool.h
//  veRTC_Demo
//
//  Created by ByteDance on 2022/7/11.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameControlAckModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameControlTool : NSObject

+ (GameControlAckModel *)dataToAckModel:(NSArray *)dataList;

@end

NS_ASSUME_NONNULL_END
