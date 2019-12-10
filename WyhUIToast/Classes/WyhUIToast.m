//
//  WyhUIToast.m
//  Arm
//
//  Created by Michael Wu on 2019/4/9.
//  Copyright © 2019 iTalkBB. All rights reserved.
//

#import "WyhUIToast.h"
#import "WyhBottomToastView.h"
#import <IQKeyboardManager.h>

@interface WyhUIToast () <WyhBottomToastViewDelegate>

@property (nonatomic, strong) NSMapTable *mapBlockTable;

@property (nonatomic, strong) NSMutableArray<WyhBottomToastView *> *toastStacks;

@property (nonatomic, strong) WyhUIToastStyle *defaultStyle;

@property (nonatomic, strong) WyhBottomToastView *currentAppearedToastView;

@end

@implementation WyhUIToast

- (void)dealloc {
    
    [self clean];
}

+ (instancetype)service {
    static WyhUIToast *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[WyhUIToast alloc]init];
    });
    return service;
}

- (instancetype)initialize {
    
    _toastStacks = [[NSMutableArray alloc]initWithCapacity:5];
    _mapBlockTable = [NSMapTable weakToStrongObjectsMapTable];
    
    _defaultStyle = [[WyhUIToastStyle alloc]init];
    
    return self;
}

- (void)clean {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [WyhUIToast dismiss];
    [_toastStacks removeAllObjects];
}

#pragma mark - Api

+ (void)setDefaultStyle:(WyhUIToastStyle *)style {
    WyhUIToast.service.defaultStyle = style;
}

+ (WyhBottomToastView *)show:(WyhUIToastType)type message:(NSString *)message {
    
    return [WyhUIToast.service showToastMessage:message
                                           type:(WyhBottomToastViewType)type
                                  accessoryType:(WyhBottomToastViewAccessoryTypeNone)
                                    dismissMode:(WyhBottomToastViewDismissModeDuration)
                                       duration:kDefaultDismissDuration
                                 accessoryClick:nil];
}

+ (WyhBottomToastView *)show:(WyhUIToastType)type
                     message:(NSString *)message
                    duration:(NSTimeInterval)duration {
    
    return [WyhUIToast.service showToastMessage:message
                                           type:(WyhBottomToastViewType)type
                                  accessoryType:(WyhBottomToastViewAccessoryTypeNone)
                                    dismissMode:(duration <= 0) ? WyhBottomToastViewDismissModeNerver : (WyhBottomToastViewDismissModeDuration)
                                       duration:duration
                                 accessoryClick:nil];
    
}

+ (WyhBottomToastView *)show:(WyhUIToastType)type
                     message:(NSString *)message
                    duration:(NSTimeInterval)duration
              accessoryClick:(void (^)(void))clickClosure {
    
    return [WyhUIToast.service showToastMessage:message
                                           type:(WyhBottomToastViewType)type
                                  accessoryType:(WyhBottomToastViewAccessoryTypeActionable)
                                    dismissMode:(duration <= 0) ? WyhBottomToastViewDismissModeNerver : (WyhBottomToastViewDismissModeDuration)
                                       duration:duration
                                 accessoryClick:clickClosure];
}


#pragma mark -

+ (void)dismiss {
    
    [[WyhUIToast service] checkToastStacksAppeared:^(NSArray<WyhBottomToastView *> *appearedToast, NSArray<WyhBottomToastView *>*unappearedToast) {
        if (appearedToast.count > 0) {
            [appearedToast makeObjectsPerformSelector:@selector(dismiss)];
        }
    }];
}

#pragma mark - Private

- (WyhBottomToastView *)showToastMessage:(NSString *)msg
                                    type:(WyhBottomToastViewType)type
                           accessoryType:(WyhBottomToastViewAccessoryType)accessoryType
                             dismissMode:(WyhBottomToastViewDismissMode)dismissMode
                                duration:(NSTimeInterval)duration
                          accessoryClick:(void (^)(void))clickClosure {
        
    __block BOOL isNeedShowDelay = NO;
    [self checkToastStacksAppeared:^(NSArray<WyhBottomToastView *> *appearedToast, NSArray<WyhBottomToastView *>*unappearedToast) {
        
        if (appearedToast.count > 0) {
            [appearedToast makeObjectsPerformSelector:@selector(dismiss)];
            isNeedShowDelay = YES;
        }
    }];
    
    WyhBottomToastView *toast = [[WyhBottomToastView alloc]initWithMessage:msg
                                                 style:_defaultStyle
                                                  type:type
                                         accessoryType:accessoryType
                                           dismissMode:dismissMode duration:duration delegate:self];
    if (!isNeedShowDelay) {
        [toast show];
    }
    [_toastStacks addObject:toast];
   
    
    
    if (accessoryType != WyhBottomToastViewAccessoryTypeNone && clickClosure) {
        [_mapBlockTable setObject:clickClosure forKey:toast];
    }
    
    return toast;
}

- (void)checkToastStacksAppeared:(void(^)(NSArray<WyhBottomToastView *>*appearedToast, NSArray<WyhBottomToastView *>*unappearedToast))completion {
    
    if (!_toastStacks.count) {
        completion(nil,_toastStacks);
        return;
    }
    
    __block NSMutableArray *appearedToasts = [NSMutableArray new];
    __block NSMutableArray *unappearedToasts = [NSMutableArray new];
    [_toastStacks enumerateObjectsUsingBlock:^(WyhBottomToastView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isAlreadyShow) {
            [appearedToasts addObject:obj];
        }else {
            [unappearedToasts addObject:obj];
        }
    }];
    
    completion(appearedToasts,unappearedToasts);
}

#pragma mark - HSBottomToastViewDelegate

- (void)bottomToastViewWillShow:(WyhBottomToastView *)alertView {
    if ([IQKeyboardManager.sharedManager isKeyboardShowing]) {
        [IQKeyboardManager.sharedManager resignFirstResponder];
    }
    _currentAppearedToastView = alertView;
}

- (void)bottomToastViewDidDismiss:(WyhBottomToastView *)alertView {
    
    if (![_toastStacks containsObject:alertView]) {
        NSAssert(NO, @"Toast stack must contain this alert ! You seem like not perform '[WyhUIToast.service initialize]', please perform in AppDelegate.m.");
        return;
    }
    [_toastStacks removeObject:alertView]; // remove item from stack
    
    [self checkToastStacksAppeared:^(NSArray<WyhBottomToastView *> *appearedToast, NSArray<WyhBottomToastView *>*unappearedToast) {
        if (appearedToast.count == 0 && unappearedToast.count > 0) {
            [unappearedToast.firstObject show];
        }
    }];
}

- (void)bottomToastViewWillDismiss:(WyhBottomToastView *)alertView {
    if ([_currentAppearedToastView isEqual:alertView]) {
        _currentAppearedToastView = nil;
    }
}

- (void)bottomToastViewDidShow:(WyhBottomToastView *)alertView {
    
}

- (void)bottomToastViewDidClickAccessory:(WyhBottomToastView *)toastView {
    
    void(^block)(void) = [_mapBlockTable objectForKey:toastView];
    
    if (block) {
        block();
        [_mapBlockTable removeObjectForKey:toastView];
    }
}

@end
