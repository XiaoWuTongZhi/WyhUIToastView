//
//  WyhUIToastStyle.m
//  Masonry
//
//  Created by wyh on 2019/12/5.
//

#import "WyhUIToastStyle.h"
#import "NSBundle+WyhUIToast.h"

@implementation WyhUIToastStyle

- (instancetype)init {
    if (self = [super init]) {
        
        _toastBackgroundColor = [UIColor blackColor];
        _toastBackgroundAlpha = 0.6f;
        
        _infoImage = [NSBundle wyhGetImageFromBundleWithImageName:@"img_flag_info"];
        _successImage = [NSBundle wyhGetImageFromBundleWithImageName:@"img_flag_success"];
        _warningImage = [NSBundle wyhGetImageFromBundleWithImageName:@"img_flag_warning"];
                
    }
    return self;
}

@end
