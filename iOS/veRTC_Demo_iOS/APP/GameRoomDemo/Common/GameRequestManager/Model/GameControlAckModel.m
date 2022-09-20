//
//  GameControlAckModel.m
//  SceneRTCDemo
//
//  Created by bytedance on 2021/3/17.
//

#import "GameControlAckModel.h"

@implementation GameControlAckModel

- (BOOL)result {
    if (self.code == 200) {
        return YES;
    } else {
        return NO;
    }
}

@end
