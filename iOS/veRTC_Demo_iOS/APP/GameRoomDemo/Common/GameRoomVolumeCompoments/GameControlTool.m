//
//  GameControlTool.m
//  veRTC_Demo
//
//  Created by ByteDance on 2022/7/11.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import "GameControlTool.h"

@implementation GameControlTool

+ (GameControlAckModel *)dataToAckModel:(NSArray *)dataList {
    GameControlAckModel *model = nil;
    if (dataList && [dataList isKindOfClass:[NSArray class]] && dataList.count > 0) {
        model = [[GameControlAckModel alloc] init];
        NSDictionary *dic = dataList.firstObject;
        if (dic && [dic isKindOfClass:[NSDictionary class]] && dic.count > 0) {
            model = [[GameControlAckModel alloc] init];
            model.code = [dic[@"code"] integerValue];
            model.response = dic[@"response"];
            NSString *message = [GameControlTool messageToRequestCode:model.code];
            if (!message || ![message isKindOfClass:[NSString class]] || message.length <= 0) {
                message = dic[@"message"];
            }
            model.message = message;
            if (model.code == 450) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginExpired object:nil];
            }
        }
    }
    return model;
}

+ (NSString *)messageToRequestCode:(NSInteger)code {
    NSString *message = @"";
    switch (code) {
            break;
        case 422:
            message = @"房间已经解散";
            break;
        case 430:
            message = @"输入内容包含敏感词，请重新输入";
            break;
        case 440:
            message = @"验证码过期，请重新发送验证码";
            break;
        case 441:
            message = @"验证码不正确，请重新发送验证码";
            break;
        case 450:
            message = @"登录已经过期，请重新登录";
            break;
        case 702:
            message = @"服务端Token生成失败，请重试";
            break;
        default:
            break;
    }
    return message;
}

@end
