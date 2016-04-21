//
//  DeviceManageViewController.h
//  smartYogurtMaker
//
//  Created by mqw on 15/7/10.
//  Copyright (c) 2015年 mqw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


//设备管理
@interface DeviceManageViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *deviceArray;//接收所有可控制设备的信息
@property (strong, nonatomic) MBProgressHUD        *HUD;


-(void) searching;


@end
