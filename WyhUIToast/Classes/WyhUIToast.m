//
//  WyhUIToast.m
//  Arm
//
//  Created by Michael Wu on 2019/4/9.
//  Copyright © 2019 iTalkBB. All rights reserved.
//

#import "WyhUIToast.h"
#import "WyhBottomToastView.h"

@interface WyhUIToast () <WyhBottomToastViewDelegate>

@property (nonatomic, strong) NSMapTable *mapBlockTable;

@property (nonatomic, strong) NSMutableArray<WyhBottomToastView *> *toastStacks;

@property (nonatomic, strong) UIView *textFieldOrView;


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
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldViewDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
    return self;
}

- (void)clean {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [WyhUIToast dismiss];
    [_toastStacks removeAllObjects];
}

#pragma mark - Api

+ (void)showToastMessage:(NSString *)msg {
    [self showInfoMessage:msg];
}

+ (void)showToastMessage:(NSString *)msg duration:(NSTimeInterval)duration {
    [self showInfoMessage:msg duration:duration];
}

#pragma mark -

+ (WyhBottomToastView *)showNerverDismissInfoMessage:(NSString *)msg {
    return [[WyhUIToast service] showToastMessage:msg
                                                   type:(WyhBottomToastViewTypeInformation)
                                          accessoryType:(WyhBottomToastViewAccessoryTypeNone)
                                            dismissMode:(WyhBottomToastViewDismissModeNerver)
                                               duration:0
                                         accessoryClick:nil];
}

+ (WyhBottomToastView *)showNerverDismissInfoMessage:(NSString *)msg accessoryClick:(void (^)(void))clickClosure {
    
    return [[WyhUIToast service] showToastMessage:msg
                                                   type:(WyhBottomToastViewTypeInformation)
                                          accessoryType:(WyhBottomToastViewAccessoryTypeActionable)
                                            dismissMode:(WyhBottomToastViewDismissModeNerver)
                                               duration:0
                                         accessoryClick:clickClosure];
}

+ (WyhBottomToastView *)showNerverDismissWarningMessage:(NSString *)msg {
    
    return [[WyhUIToast service] showToastMessage:msg
                                                   type:(WyhBottomToastViewTypeWarning)
                                          accessoryType:(WyhBottomToastViewAccessoryTypeNone)
                                            dismissMode:(WyhBottomToastViewDismissModeNerver)
                                               duration:0
                                         accessoryClick:nil];
}

+ (WyhBottomToastView *)showNerverDismissWarningMessage:(NSString *)msg accessoryClick:(void (^)(void))clickClosure {
    
    return [[WyhUIToast service] showToastMessage:msg
                                                   type:(WyhBottomToastViewTypeWarning)
                                          accessoryType:(WyhBottomToastViewAccessoryTypeActionable)
                                            dismissMode:(WyhBottomToastViewDismissModeNerver)
                                               duration:0
                                         accessoryClick:clickClosure];
}

#pragma mark -

+ (WyhBottomToastView *)showInfoMessage:(NSString *)msg {
    
    return [self showInfoMessage:msg duration:kDefaultDismissDuration];
    
}

+ (WyhBottomToastView *)showWarningMessage:(NSString *)msg {

   return [self showWarningMessage:msg duration:kDefaultDismissDuration];

}

+ (WyhBottomToastView *)showWarningMessage:(NSString *)msg duration:(NSTimeInterval)duration {
    
    return [[WyhUIToast service] showToastMessage:msg
                                                   type:(WyhBottomToastViewTypeWarning)
                                          accessoryType:(WyhBottomToastViewAccessoryTypeNone)
                                            dismissMode:(WyhBottomToastViewDismissModeDuration)
                                               duration:duration
                                         accessoryClick:nil];
}

+ (WyhBottomToastView *)showInfoMessage:(NSString *)msg duration:(NSTimeInterval)duration {
    
    return [[WyhUIToast service] showToastMessage:msg
                                                   type:(WyhBottomToastViewTypeInformation)
                                          accessoryType:(WyhBottomToastViewAccessoryTypeNone)
                                            dismissMode:(WyhBottomToastViewDismissModeDuration)
                                               duration:duration
                                         accessoryClick:nil];
}

+ (WyhBottomToastView *)showWarningMessage:(NSString *)msg
                                 duration:(NSTimeInterval)duration
                           accessoryClick:(void (^)(void))clickClosure {
    
    
    
    return [[WyhUIToast service] showToastMessage:msg
                                                   type:(WyhBottomToastViewTypeWarning)
                                          accessoryType:(WyhBottomToastViewAccessoryTypeActionable)
                                            dismissMode:(WyhBottomToastViewDismissModeDuration)
                                               duration:duration
                                         accessoryClick:clickClosure];
}

+ (WyhBottomToastView *)showInfoMessage:(NSString *)msg
                              duration:(NSTimeInterval)duration
                        accessoryClick:(void (^)(void))clickClosure {
    
    return [[WyhUIToast service] showToastMessage:msg
                                                   type:(WyhBottomToastViewTypeInformation)
                                          accessoryType:(WyhBottomToastViewAccessoryTypeActionable)
                                            dismissMode:(WyhBottomToastViewDismissModeDuration)
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

#pragma mark - Notification

-(void)textFieldViewDidBeginEditing:(NSNotification*)notification {
    
    _textFieldOrView = notification.object;
    
}

-(void)textFieldViewDidEndEditing:(NSNotification*)notification {
    
    _textFieldOrView = nil;
}

#pragma mark - Private

- (WyhBottomToastView *)showToastMessage:(NSString *)msg
                                   type:(WyhBottomToastViewType)type
                          accessoryType:(WyhBottomToastViewAccessoryType)accessoryType
                             dismissMode:(WyhBottomToastViewDismissMode)dismissMode
                               duration:(NSTimeInterval)duration
                         accessoryClick:(void (^)(void))clickClosure {
    
    // first dismiss appeared toast .
    __block BOOL isNeedShowDelay = NO;
    [self checkToastStacksAppeared:^(NSArray<WyhBottomToastView *> *appearedToast, NSArray<WyhBottomToastView *>*unappearedToast) {
        
        if (appearedToast.count > 0) {
            [appearedToast makeObjectsPerformSelector:@selector(dismiss)];
            isNeedShowDelay = YES;
        }
    }];
    
    WyhBottomToastView *toast = [[WyhBottomToastView alloc]initWithMessage:msg
                                                                    type:type
                                                           accessoryType:accessoryType
                                                             dismissMode:dismissMode
                                                                duration:duration
                                                                delegate:self];
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
    if (_textFieldOrView) {
        [_textFieldOrView resignFirstResponder];
    }
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
