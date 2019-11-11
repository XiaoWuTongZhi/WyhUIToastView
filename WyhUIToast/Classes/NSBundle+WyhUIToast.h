//
//  NSBundle+WyhUIToast.h
//  Masonry
//
//  Created by wyh on 2019/11/11.
//

#import <Foundation/Foundation.h>

@interface NSBundle (WyhUIToast)

+ (instancetype)wyhBundle;

+ (UIImage *)wyhGetImageFromBundleWithImageName:(NSString *)name;

@end
