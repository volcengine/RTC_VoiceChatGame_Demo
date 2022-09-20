//
//  ToastComponent.m
//  quickstart
//
//  Created by on 2021/4/1.
//  
//

#import "ToastComponent.h"
#import "ToastView.h"
#import "Masonry.h"
#import "DeviceInforTool.h"

@interface ToastComponent ()

@property (nonatomic, weak) ToastView *keepToastView;

@end

@implementation ToastComponent

+ (ToastComponent *)shareToastComponent {
    static dispatch_once_t onceToken ;
    static ToastComponent *toastComponent = nil;
    dispatch_once(&onceToken, ^{
        toastComponent = [[self alloc] init];
    });
    return toastComponent ;
}


#pragma mark - Publish Action

- (void)showWithMessage:(NSString *)message view:(UIView *)windowView keep:(BOOL)isKeep block:(void (^)(BOOL result))block {
    if (message.length <= 0) {
        return;
    }
    if (isKeep && _keepToastView) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ToastView *toastView = [[ToastView alloc] initWithMeeage:message];
        [windowView addSubview:toastView];
        [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(windowView);
        }];
        
        if (isKeep) {
            self.keepToastView = toastView;
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [toastView removeFromSuperview];
                toastView = nil;
            });
        }
    });
}

- (void)showWithMessage:(NSString *)message view:(UIView *)windowView block:(void (^)(BOOL result))block {
    [self showWithMessage:message view:windowView keep:NO block:block];
}

- (void)showWithMessage:(NSString *)message view:(UIView *)windowView {
    [self showWithMessage:message view:windowView block:^(BOOL result) {
        
    }];
}

- (void)showWithMessage:(NSString *)message {
    dispatch_queue_async_safe(dispatch_get_main_queue(), ^{
        UIViewController *windowVC = [DeviceInforTool topViewController];
        [self showWithMessage:message view:windowVC.view];
    });
}

- (void)showWithMessage:(NSString *)message delay:(CGFloat)delay {
    if (delay > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showWithMessage:message];
        });
    } else {
        [self showWithMessage:message];
    }
}

- (void)dismiss {
    [_keepToastView removeFromSuperview];
    _keepToastView = nil;
}

@end
