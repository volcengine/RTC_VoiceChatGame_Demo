//
//  GameNavViewController.h
//  quickstart
//
//  Created by bytedance on 2021/3/22.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameNavViewController : UIViewController

@property (nonatomic, copy) NSString *navTitle;

@property (nonatomic, strong) UIView *navView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, copy) NSString *rightTitle;

- (void)rightButtonAction:(BaseButton *)sender;

@end

NS_ASSUME_NONNULL_END
