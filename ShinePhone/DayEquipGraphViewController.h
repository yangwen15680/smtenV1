//
//  DayEquipGraphViewController.h
//  ShinePhone
//
//  Created by ZML on 15/6/4.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface DayEquipGraphViewController : RootViewController
@property (nonatomic, strong) NSString *stationId;
@property (nonatomic, strong) NSString *equipId;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *site;
@property (nonatomic, strong) NSDictionary *dict;
- (instancetype)initWithName:(NSString *)name;
@end
