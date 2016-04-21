//
//  GoogleMapViewController.h
//  ShinePhone
//
//  Created by ZML on 15/6/2.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface GoogleMapViewController : RootViewController
@property (nonatomic, strong) NSString *stationId;
@property(nonatomic,strong)CLLocation *plantLocation;
@property (nonatomic, strong) NSString *stationName;
-(instancetype)initWithLocation:(CLLocation *)location name:(NSString *)name;

@end
