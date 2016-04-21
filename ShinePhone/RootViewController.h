//
//  RootViewController.h
//  ShinePhone
//
//  Created by LinKai on 15/5/18.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

- (void)showToastViewWithTitle:(NSString *)title;

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle;

- (void)showProgressView;

- (void)hideProgressView;

- (NSString *)MD5:(NSString *)str;

- (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect;

- (UITabBarItem *)createTabBarItem:(NSString *)strTitle normalImage:(NSString *)strNormalImg selectedImage:(NSString *)strSelectedImg itemTag:(NSInteger)intTag;

@end
