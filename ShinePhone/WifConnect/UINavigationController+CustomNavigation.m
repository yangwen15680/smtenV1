//
//  UINavigationController+CustomNavigation.m
//  hcx3
//
//  Created by angelshine on 14-1-17.
//  Copyright (c) 2014年 nationzec. All rights reserved.
//

#import "UINavigationController+CustomNavigation.h"
#import "AppMacro.h"

@implementation UINavigationController (CustomNavigation)

//设置Navigation Bar背景图片
-(void)customNavigation{
    self.navigationBar.translucent = NO;
    //设置Navigation Bar背景图片
    UIImage *title_bg = [UIImage imageNamed:@"top"];  //获取图片
    CGSize titleSize = self.navigationBar.bounds.size;  //获取Navigation Bar的位置和大小
    if (IS_OS_7_OR_LATER) {
        titleSize.height+=20;
    }
    title_bg = [self scaleToSize:title_bg size:titleSize];//设置图片的大小与Navigation Bar相同
    [self.navigationBar setBackgroundImage:title_bg forBarMetrics:UIBarMetricsDefault];  //设置背景
}

//调整图片大小
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
