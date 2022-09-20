//
//  GameIMComponents.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/23.
//  Copyright © 2021 . All rights reserved.
//

#import "GameIMComponents.h"
#import "GameIMView.h"

@interface GameIMComponents ()

@property (nonatomic, strong) GameIMView *gameIMView;

@end

@implementation GameIMComponents

- (instancetype)initWithSuperView:(UIView *)superView {
    self = [super init];
    if (self) {
        [superView addSubview:self.gameIMView];
        self.gameIMView.userInteractionEnabled = NO;
        [self.gameIMView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(-10 - ([DeviceInforTool getVirtualHomeHeight] + 64));
            make.height.mas_equalTo(115);
            make.width.mas_equalTo(275);
        }];
    }
    return self;
}

#pragma mark - Publish Action

- (void)addIM:(GameIMModel *)model {
    NSMutableArray *datas = [[NSMutableArray alloc] initWithArray:self.gameIMView.dataLists];
    [datas addObject:model];
    self.gameIMView.dataLists = [datas copy];
}

#pragma mark - getter

- (GameIMView *)gameIMView {
    if (!_gameIMView) {
        _gameIMView = [[GameIMView alloc] init];
    }
    return _gameIMView;
}

@end
