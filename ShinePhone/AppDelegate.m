//
//  AppDelegate.m
//  ShinePhone
//
//  Created by LinKai on 15/5/18.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomePageViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import <GoogleMaps.h>
#import "JDStatusBarNotification.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CommonCrypto/CommonDigest.h>

@interface AppDelegate () <BMKMapViewDelegate> {
    BMKMapManager* _mapManager;
    BMKMapView* _mapView;
}

@end

@implementation AppDelegate
{
    NSMutableArray  *_scanList;
    Boolean isReachable ;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    //百度地图授权
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"pbZCyVXmQaU8rBzHpnsuBGoo"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //谷歌地图授权
    [GMSServices provideAPIKey:@"AIzaSyA6iLZrNX7BofHNaliRoALgtJLXfEBXzJg"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KNOTIFICATION_LOGINCHANGE object:nil];
    [self loginStateChange:nil];

    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //网络状态
    self.reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    [_reach startNotifier];
    
    return YES;
}

//当网络状态改变时回调
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable) {
        [JDStatusBarNotification showWithStatus:@"No Internet Connection!" dismissAfter:2.0 styleName:JDStatusBarStyleWarning];
    }
}

-(NSString *)getWifiName
{
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            //            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
}

-(void)loginStateChange:(NSNotification *)notification{
    if ([UserInfo defaultUserInfo].isAutoLogin) {
        HomePageViewController *hpvc = [[HomePageViewController alloc] init];
        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:hpvc];
        self.window.rootViewController = navc;
    } else {
        LoginViewController *lvc = [[LoginViewController alloc] init];
        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:lvc];
        self.window.rootViewController = navc;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
