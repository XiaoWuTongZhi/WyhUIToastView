//
//  WyhBottomToastView.h
//  Arm
//
//  Created by Michael Wu on 2019/4/9.
//  Copyright © 2019 iTalkBB. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSTimeInterval const kDefaultDismissDuration;

@class WyhBottomToastView, WyhUIToastStyle;

@protocol WyhBottomToastViewDelegate <NSObject>

- (void)bottomToastViewWillShow:(WyhBottomToastView *)toastView;
- (void)bottomToastViewDidShow:(WyhBottomToastView *)toastView;

- (void)bottomToastViewWillDismiss:(WyhBottomToastView *)toastView;
- (void)bottomToastViewDidDismiss:(WyhBottomToastView *)toastView;

- (void)bottomToastViewDidClickAccessory:(WyhBottomToastView *)toastView;

@end

typedef NS_ENUM(NSUInteger, WyhBottomToastViewType) {
    WyhBottomToastViewTypeUnknown,
    WyhBottomToastViewTypeInformation,
    WyhBottomToastViewTypeWarning,
    WyhBottomToastViewTypeSuccess,
    WyhBottomToastViewTypeLoading,
};

typedef NS_ENUM(NSUInteger, WyhBottomToastViewAccessoryType) {
    WyhBottomToastViewAccessoryTypeNone,
    WyhBottomToastViewAccessoryTypeActionable, // '>'

};

typedef NS_ENUM(NSUInteger, WyhBottomToastViewDismissMode) {
    WyhBottomToastViewDismissModeDuration,
    WyhBottomToastViewDismissModeNerver,
    
};

/**
 Bottom Toast design for AIjia global toast , don't use it straightly ,please use it by `HSUIToastService`, see more detail in "HSUIToastService.h"
 */
@interface WyhBottomToastView : UIView

@property (nonatomic, strong, readonly) UITapGestureRecognizer *actionTapGestrueRecognizer;

@property (nonatomic, assign, readonly) NSString *message;
@property (nonatomic, assign, readonly) WyhBottomToastViewType type;
@property (nonatomic, assign, readonly) WyhBottomToastViewAccessoryType accessoryType;
@property (nonatomic, assign, readonly) WyhBottomToastViewDismissMode dismissMode;
@property (nonatomic, assign, readonly) NSTimeInterval dismissDuration;

@property (nonatomic, assign, readonly) BOOL isAlreadyShow;
@property (nonatomic, assign, readonly) BOOL isAnimating;

- (instancetype)initWithMessage:(NSString *)msg
                          style:(WyhUIToastStyle *)style
                           type:(WyhBottomToastViewType)type
                  accessoryType:(WyhBottomToastViewAccessoryType)accessoryType
                    dismissMode:(WyhBottomToastViewDismissMode)dismissMode
                       duration:(NSTimeInterval)duration
                       delegate:(id<WyhBottomToastViewDelegate>)delegate;

+ (instancetype)showToastWithMessage:(NSString *)msg
                               style:(WyhUIToastStyle *)style
                                type:(WyhBottomToastViewType)type
                       accessoryType:(WyhBottomToastViewAccessoryType)accessoryType
                         dismissMode:(WyhBottomToastViewDismissMode)dismissMode
                            duration:(NSTimeInterval)duration
                            delegate:(id<WyhBottomToastViewDelegate>)delegate;
 
- (void)updateStatusWithMessage:(NSString *)msg
                           type:(WyhBottomToastViewType)type
                  accessoryType:(WyhBottomToastViewAccessoryType)accessoryType
                    dismissMode:(WyhBottomToastViewDismissMode)dismissMode
                       duration:(NSTimeInterval)duration;

- (void)show;
- (void)dismiss;



@end



