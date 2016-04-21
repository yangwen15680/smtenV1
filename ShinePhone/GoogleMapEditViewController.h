//
//  GoogleMapEditViewController.h
//  ShinePhone
//
//  Created by ZML on 15/6/3.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import <GoogleMaps/GoogleMaps.h>

typedef void(^SnapshotSuccessBlock)(UIImage *snapshotImage);
typedef void(^LocationBlock)(CLLocationCoordinate2D coordinate);

@interface GoogleMapEditViewController : RootViewController
@property (nonatomic, copy) SnapshotSuccessBlock snapshotSuccessBlock;
@property (nonatomic, copy) LocationBlock locationBlock;

- (instancetype)initWithDataDict:(NSMutableDictionary *)dataDict;

- (instancetype)initToGetLocation;

@end
