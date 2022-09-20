//
//  GameUtils.h
//  GameRoomDemo
//
//  Created by ByteDance on 2022/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameUtils : NSObject

/*
 * 字典转JSON
 * @param dic 字典
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/*
 * JSON转字典
 * @param turnString JSON
 */
+ (NSDictionary *)turnStringToDictionary:(NSString *)turnString;

@end

NS_ASSUME_NONNULL_END
