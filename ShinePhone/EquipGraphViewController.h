//
//  EquipGraphViewController.h
//  ShinePhone
//
//  Created by ZML on 15/6/1.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "RootViewController.h"

@interface EquipGraphViewController : RootViewController

@property (nonatomic, strong) NSString *stationId;
@property (nonatomic, strong) NSString *equipId;
@property (nonatomic, strong) NSDictionary *dictInfo;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSDictionary *dictMonth;
@property (nonatomic, strong) NSDictionary *dictYear;
@property (nonatomic, strong) NSDictionary *dictAll;

@end
