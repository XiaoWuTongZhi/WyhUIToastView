//
//  WyhUIToastStyle.h
//  Masonry
//
//  Created by wyh on 2019/12/5.
//

#import <UIKit/UIkit.h>

@interface WyhUIToastStyle : NSObject

@property (nonatomic, strong) UIColor *toastBackgroundColor;

@property (nonatomic, assign) CGFloat toastBackgroundAlpha;

@property (nonatomic, strong) UIImage *infoImage;
@property (nonatomic, strong) UIImage *warningImage;
@property (nonatomic, strong) UIImage *successImage;



@end

