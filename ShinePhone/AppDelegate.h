//
//  AppDelegate.h
//  ShinePhone
//
//  Created by LinKai on 15/5/18.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

#define kOnGotDeviceByScan              @"kOnGotDeviceByScan"
@property (strong, nonatomic) UIWindow *window;

@property(strong) Reachability *reach;



-(NSString *)getWifiName;


@end

