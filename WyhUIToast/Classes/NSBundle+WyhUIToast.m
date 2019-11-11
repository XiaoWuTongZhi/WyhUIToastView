//
//  NSBundle+WyhUIToast.m
//  Masonry
//
//  Created by wyh on 2019/11/11.
//

#import "NSBundle+WyhUIToast.h"
#import "WyhUIToast.h"


@implementation NSBundle (WyhUIToast)

+ (instancetype)wyhBundle {
    
    static NSBundle *bundle = nil;
    if (!bundle) {
        
        NSString *path = [[NSBundle bundleForClass:WyhUIToast.class] pathForResource:@"WyhToastBox" ofType:@"bundle"]; // fix can't find bundle in pod 1.x / 0.x
        NSLog(@"find bundle path is %@",path);
        bundle = [NSBundle bundleWithPath:path];
    }
    return bundle;
}

+ (UIImage *)wyhGetImageFromBundleWithImageName:(NSString *)name  {
    NSString *path = [[NSBundle wyhBundle] pathForResource:name ofType:@"png"];
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:path];
    return image;
}

@end
