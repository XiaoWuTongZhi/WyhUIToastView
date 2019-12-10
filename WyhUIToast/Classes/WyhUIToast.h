//
//  WyhUIToast.h
//  Arm
//
//  Created by Michael Wu on 2019/4/9.
//  Copyright © 2019 iTalkBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WyhUIToastStyle.h"

@class WyhBottomToastView;

typedef NS_ENUM(NSUInteger, WyhUIToastType) {
    WyhUIToastTypeInfo = 1,
    WyhUIToastTypeWarn ,
    WyhUIToastTypeSuccess ,
    WyhUIToastTypeLoading ,
};


/**
 Bottom toast UI service design for AIjia global toast .
 */
@interface WyhUIToast : NSObject

#pragma mark - Please use these Api

+ (instancetype)service;

- (instancetype)initialize;

+ (void)setDefaultStyle:(WyhUIToastStyle *)style;

+ (WyhBottomToastView *)show:(WyhUIToastType)type message:(NSString *)message;

+ (WyhBottomToastView *)show:(WyhUIToastType)type
                     message:(NSString *)message
                    duration:(NSTimeInterval)duration;

+ (WyhBottomToastView *)show:(WyhUIToastType)type
                     message:(NSString *)message
                    duration:(NSTimeInterval)duration
              accessoryClick:(void(^)(void))clickClosure;


+ (void)dismiss;


@end

