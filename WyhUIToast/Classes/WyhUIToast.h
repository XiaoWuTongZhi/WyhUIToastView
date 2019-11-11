//
//  WyhUIToast.h
//  Arm
//
//  Created by Michael Wu on 2019/4/9.
//  Copyright © 2019 iTalkBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WyhBottomToastView;

/**
 Bottom toast UI service design for AIjia global toast .
 */
@interface WyhUIToast : NSObject

#pragma mark - Please use these Api

+ (instancetype)service;

- (instancetype)initialize;


+ (WyhBottomToastView *)showNerverDismissInfoMessage:(NSString *)msg;
+ (WyhBottomToastView *)showNerverDismissInfoMessage:(NSString *)msg
                                     accessoryClick:(void(^)(void))clickClosure;

+ (WyhBottomToastView *)showNerverDismissWarningMessage:(NSString *)msg;
+ (WyhBottomToastView *)showNerverDismissWarningMessage:(NSString *)msg
                                        accessoryClick:(void(^)(void))clickClosure;


+ (WyhBottomToastView *)showInfoMessage:(NSString *)msg;
+ (WyhBottomToastView *)showInfoMessage:(NSString *)msg duration:(NSTimeInterval)duration;
+ (WyhBottomToastView *)showInfoMessage:(NSString *)msg
                              duration:(NSTimeInterval)duration
                        accessoryClick:(void(^)(void))clickClosure;

+ (WyhBottomToastView *)showWarningMessage:(NSString *)msg;
+ (WyhBottomToastView *)showWarningMessage:(NSString *)msg
                                 duration:(NSTimeInterval)duration
                           accessoryClick:(void(^)(void))clickClosure;

+ (void)dismiss;

#pragma mark - Deprecated function
/**
 Please use 'showInfoMessage:' or 'showWarningMessage:' replace.

 @deprecated it will be deprecated in the soon future.
 */
+ (void)showToastMessage:(NSString *)msg __deprecated;

/**
 Please use 'showInfoMessage:duration:' or 'showWarningMessage:duration:' replace.

 @deprecated it will be deprecated in the soon future.
 */
+ (void)showToastMessage:(NSString *)msg duration:(NSTimeInterval)duration __deprecated;



@end

