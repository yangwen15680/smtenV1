//
//  RootViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/18.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "RootViewController.h"
#import <MBProgressHUD.h>
#import <CommonCrypto/CommonDigest.h>


@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //背景图
    UIImage *bgImage = IMAGE(@"bg_login.png");
    self.view.layer.contents = (id)bgImage.CGImage;
    
    //导航栏
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBarTintColor:COLOR(82, 201, 194, 1)];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName :[UIColor whiteColor]
                                                                      }];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)urlFormat:(NSString *)urlStr {
    NSString *url = urlStr;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *characters = @"!$&'()*+,-./:;=?@_~%#[]";
    url = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  (__bridge CFStringRef)url, (__bridge CFStringRef)characters, nil, kCFStringEncodingUTF8));
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return url;
}

- (void)showToastViewWithTitle:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.labelText = title;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    [alertView show];
}

- (void)showProgressView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideProgressView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (NSString *)MD5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        NSString *tStr = [NSString stringWithFormat:@"%x", digest[i]];
        if (tStr.length == 1) {
            [result appendString:@"c"];
        }
        [result appendFormat:@"%@", tStr];
    }
    return result;
}


- (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


//自定义UITabBarItem
- (UITabBarItem *)createTabBarItem:(NSString *)strTitle normalImage:(NSString *)strNormalImg selectedImage:(NSString *)strSelectedImg itemTag:(NSInteger)intTag {
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:strTitle image:nil tag:intTag];
    
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSBackgroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [item setTitlePositionAdjustment:UIOffsetMake(item.titlePositionAdjustment.horizontal, item.titlePositionAdjustment.vertical - 5.0)];
    
    [item setImage:[IMAGE(strNormalImg) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [item setSelectedImage:[IMAGE(strSelectedImg) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    return item;
}


@end
