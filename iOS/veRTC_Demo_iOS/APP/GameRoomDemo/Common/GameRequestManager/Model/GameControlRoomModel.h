//
//  GameControlRoomModel.h
//  SceneRTCDemo
//
//  Created by bytedance on 2021/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameControlRoomModel : NSObject

@property (nonatomic, copy) NSString *room_id;

@property (nonatomic, copy) NSString *room_name;

@property (nonatomic, copy) NSString *host_id;

@property (nonatomic, copy) NSString *host_name;

@property (nonatomic, assign) NSInteger user_counts;

@property (nonatomic, assign) NSInteger micon_counts;

@property (nonatomic, assign) NSInteger created_at;

@property (nonatomic, assign) NSInteger now;

@property (nonatomic, copy) NSString *gid;

@end

NS_ASSUME_NONNULL_END
